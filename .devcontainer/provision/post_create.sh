#!/usr/bin/env bash
set -eo pipefail

DEVCONTAINER_DIR="${PWD}/.devcontainer"

## -------------------
## Windowsでdev containerを利用している人(Docker + WSL)向け対策
##
## > ### Docker Desktop for Windows
## > Inside the container, any mounted files/folders will appear as if they are owned by `root`
## > but the user you specify will still be able to read/write them and all files will be executable.
## > Locally, all filesystem operations will use the permissions of your local user instead.
## > This is because there is fundamentally no way to directly map Windows-style file permissions to Linux.
##
## @see https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user
## -------------------
DEV_CONTAINER_FILE_OWNER=$(stat --format=%U "${DEVCONTAINER_DIR}/devcontainer.json")
if [ "${DEV_CONTAINER_FILE_OWNER}" != "${USER}" ]; then
  echo "Change owner container files"
  sudo chown -R "${USER}:${USER}" "${PWD}"
fi

sudo rm -rf /var/www/html
DOC_ROOT="${PWD}"
if [ -d "${PWD}/public" ]; then
  DOC_ROOT="${PWD}/public"
elif [ -d "${PWD}/webroot" ]; then
  DOC_ROOT="${PWD}/webroot"
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
# Flag to indicate that the migration from my.cnf is complete.
# Suppresses the deprecation warning about reading settings from my.cnf.
my_cnf_transition_done = True

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

[client]
host = db
database = app_dev
user = app_dev
password = app_dev_password

[connection]
default_character_set = utf8mb4

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

## Homebrew
if [ ! -e /home/linuxbrew/.linuxbrew/bin/brew ]; then
  NONINTERACTIVE=1
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
fi

## -------------
## 各種コマンドラインツールをインストール
## ----
## mkdocs-material: https://squidfunk.github.io/mkdocs-material/
## zensical: https://zensical.org/
## mycli: https://www.mycli.net/
## ddgs: https://github.com/deedy5/ddgs
## pre-commit: https://pre-commit.com/
## Ansible: https://docs.ansible.com/
## -------------
if [ ! -e ~/.local/pipx/venvs/mkdocs ]; then
  pipx install mkdocs --include-deps
  pipx inject mkdocs mkdocs-material mkdocs-glightbox
  pipx inject mkdocs mkdocs-literate-nav mkdocs-section-index
fi
if [ ! -e ~/.local/pipx/venvs/zensical ]; then
  pipx install zensical --include-deps
  pipx inject zensical mkdocs-glightbox
  pipx inject zensical mkdocs-literate-nav mkdocs-section-index
  pipx inject mkdocs mkdocs-git-revision-date-localized-plugin
fi
if [ ! -e ~/.local/pipx/venvs/mycli ]; then
  pipx install mycli --include-deps
fi
if [ ! -e ~/.local/pipx/venvs/ddgs ]; then
  pipx install ddgs --include-deps
fi
if [ ! -e ~/.local/pipx/venvs/pre-commit ]; then
  pipx install pre-commit --include-deps
fi
if [ ! -e ~/.local/pipx/venvs/ansible ]; then
  pipx install ansible --include-deps
  pipx inject ansible ansible-lint --include-apps
fi
if [ ! -e "${HOME}/.local/pipx/venvs/markitdown" ]; then
  pipx install "markitdown[all]"
fi

# Playwright利用時のシステム依存ライブラリのインストール(root権限が必要)
sudo npx playwright install-deps chromium

## Claude Code
if [ ! -e ~/.local/bin/claude ]; then
	curl -fsSL https://claude.ai/install.sh | bash
fi
## OpenCode
if [ ! -e ~/.opencode/bin/opencode ]; then
	curl -fsSL https://opencode.ai/install | bash
fi
if [ ! -e ~/.local/bin/opencode ]; then
	ln -s ~/.opencode/bin/opencode  ~/.local/bin/opencode
fi
## Copilot CLI
if [ ! -e ~/.opencode/bin/copilot ]; then
  curl -fsSL https://gh.io/copilot-install | bash
fi

PROVISION_DIR=$(dirname $0)
ROLE_DIR="${PROVISION_DIR}/roles"
if [ -f "${PROVISION_DIR}/requirements.yml" ]; then
  ansible-galaxy install -r "${PROVISION_DIR}/requirements.yml" -p "${ROLE_DIR}" --force
fi
if [ -f "${PROVISION_DIR}/post_create.yml" ]; then
  ansible-playbook -i 127.0.0.1, -c local --diff "${PROVISION_DIR}/post_create.yml"
fi
if [ -f "${PROVISION_DIR}/verify.yml" ]; then
  ansible-playbook -i 127.0.0.1, -c local --diff "${PROVISION_DIR}/verify.yml"
fi
if [ -f "${PROVISION_DIR}/custom.yml" ]; then
  ansible-playbook -i 127.0.0.1, -c local --diff "${PROVISION_DIR}/custom.yml"
fi
