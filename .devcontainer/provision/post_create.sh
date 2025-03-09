#!/usr/bin/env bash
set -eo pipefail

echo "$(whoami):$(whoami)" | sudo chpasswd

sudo chmod a+x "$(pwd)"
sudo rm -rf /var/www/html
DOC_ROOT=$(pwd)
if [ -d public ]; then
  DOC_ROOT="$(pwd)/public"
elif [ -d webroot ]; then
  DOC_ROOT="$(pwd)/webroot"
fi
sudo ln -s "${DOC_ROOT}" /var/www/html

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

# Destructive warning mode will alert you before executing a sql statement
# that may cause harm to the database such as "drop table", "drop database"
# or "shutdown".
destructive_warning = False

# Enable the pager on startup.
enable_pager = False

# Skip intro info on startup and outro info on exit
less_chatty = True

[alias_dsn]
dev = mysql://app_dev:app_dev_password@db:3306/app_dev
test = mysql://app_test:app_test_password@db:3306/app_test
stg = mysql://app_stg:app_stg_password@db:3306/app_stg
prod = mysql://app_prod:app_prod_password@db:3306/app_prod
EOT

if [ -f composer.json ]; then
  composer install --no-interaction
fi

if [ -f package.json ]; then
  ## @see https://github.com/antfu/ni
  ni
fi

if [ ! -e ~/.local/pipx/venvs/mkdocs ]; then
  pipx install mkdocs --include-deps
  pipx inject mkdocs mkdocs-material mkdocs-git-revision-date-localized-plugin mkdocs-glightbox
  ## 作図関連プラグイン
  pipx inject mkdocs mkdocs-d2-plugin plantuml-markdown mkdocs-drawio
fi
if [ ! -e ~/.local/pipx/venvs/mycli ]; then
  pipx install mycli --include-deps
fi
if [ ! -e ~/.local/pipx/venvs/pre-commit ]; then
  pipx install pre-commit --include-deps
fi
if [ ! -e ~/.local/pipx/venvs/ansible ]; then
  pipx install ansible --include-deps
  pipx inject ansible ansible-lint --include-apps
fi

if [ -f "$(dirname $0)/post_create.yml" ]; then
  ansible-playbook -i 127.0.0.1, -c local --diff "$(dirname $0)/post_create.yml"
fi
if [ -f "$(dirname $0)/verify.yml" ]; then
  ansible-playbook -i 127.0.0.1, -c local --diff "$(dirname $0)/verify.yml"
fi
if [ -f "$(dirname $0)/custom.yml" ]; then
  ansible-playbook -i 127.0.0.1, -c local --diff "$(dirname $0)/custom.yml"
fi
