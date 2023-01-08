#!/usr/bin/env bash
echo "$(whoami):$(whoami)" | sudo chpasswd

if type "direnv" >/dev/null 2>&1; then
  echo 'eval "$(direnv hook bash)"' >>~/.bashrc
fi

if type "exa" >/dev/null 2>&1; then
  echo 'alias ls="exa --git --header"' >>~/.bashrc
fi

if type "composer" >/dev/null 2>&1; then
  echo 'eval "$(composer completion)"' >>~/.bashrc
fi

if type "npm" >/dev/null 2>&1; then
  echo 'eval "$(npm completion)"' >>~/.bashrc
fi

if type "yarn" >/dev/null 2>&1; then
  mkdir -p "${HOME}/.local/share/bash-completion/completions/"
  curl -s -o "${HOME}/.local/share/bash-completion/completions/yarn" \
  https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
fi

if type "tbls" >/dev/null 2>&1; then
  echo "# BEGIN environment variable ANSIBLE MANAGED BLOCK" >>~/.bashrc
  echo 'export TBLS_DSN="mariadb://app_dev:app_dev_password@db:3306/app_dev"' >>~/.bashrc
  echo 'export TBLS_DOC_PATH="docs/schema"' >>~/.bashrc
  echo "# END environment variable ANSIBLE MANAGED BLOCK" >>~/.bashrc
fi

if [ ! -f ~/.inputrc ]; then
  echo "set completion-ignore-case on">~/.inputrc
fi

if [ ! -e ~/.bash-git-prompt ]; then
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
  cat << EOT >>~/.bashrc
# BEGIN bash-git-prompt setting ANSIBLE MANAGED BLOCK
if [ -f "\$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source \$HOME/.bash-git-prompt/gitprompt.sh
fi
# END bash-git-prompt setting ANSIBLE MANAGED BLOCK
EOT

fi

pip3 install --user mycli ansible ansible-lint mkdocs-material mkdocs-tooltips lizard

source ~/.bashrc

cat << EOT >~/.my.cnf
[mysql]
auto-rehash

[client]
host=db
database=app_dev
user=app_dev
password=app_dev_password
default-character-set=utf8mb4
EOT

cat << EOT >~/.myclirc
[main]
# Enables context sensitive auto-completion. If this is disabled then all
# possible completions will be listed.
smart_completion = True

# Multi-line mode allows breaking up the sql statements into multiple lines. If
# this is set to True, then the end of the statements must have a semi-colon.
# If this is set to False then sql statements can't be split into multiple
# lines. End of line (return) is considered as the end of the statement.
multi_line = False

# Enable the pager on startup.
enable_pager = False

# Skip intro info on startup and outro info on exit
less_chatty = True

[alias_dsn]
dev = mysql://app_dev:app_dev_password@db:3306/app_dev
EOT

sudo chmod a+x "$(pwd)"
sudo rm -rf /var/www/html
DOC_ROOT=$(pwd)
if [ -d public ]; then
  DOC_ROOT="$(pwd)/public"
elif [ -d webroot ]; then
  DOC_ROOT="$(pwd)/webroot"
fi
sudo ln -s "${DOC_ROOT}" /var/www/html

if [ -f requirements.txt ]; then
  pip3 install --user --disable-pip-version-check -r requirements.txt
fi

if [ -f composer.json ]; then
  composer install --no-interaction
fi
if [ -f package.json ]; then
  npm install
fi

git config --global --add safe.directory ${PWD}

if [ -f "$(dirname $0)/post_create.yml" ]; then
  ansible-playbook -i 127.0.0.1, -c local --diff "$(dirname $0)/post_create.yml"
fi

if [ -f "${PWD}/.devcontainer/my_env.yml" ]; then
    ansible-playbook -i 127.0.0.1, -c local "${PWD}/.devcontainer/my_env.yml"
fi
