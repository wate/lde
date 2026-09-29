#!/usr/bin/env bash
set -eo pipefail

if [ -f composer.json ] && [ ! -e vendor ]; then
  composer install --no-interaction
fi

if [ -f package.json ] && [ ! -e node_modules ]; then
  ## @see https://github.com/antfu/ni
  ni
fi

if type "direnv" >/dev/null 2>&1 && [ -f .envrc ]; then
  direnv allow
fi

PROVISION_DIR=$(dirname $0)
if type "ansible" >/dev/null 2>&1 && [ -f "${PROVISION_DIR}/post_start.yml" ]; then
  ansible-playbook  -i 127.0.0.1, -c local --diff "${PROVISION_DIR}/post_start.yml"
fi

if [ -z "${__GIT_PROMPT_SHOW_CHANGED_FILES_COUNT}" ]; then
  source "${HOME}/.bashrc"
fi

if [ -f .pre-commit-config.yaml ] && [ -e ~/.local/pipx/venvs/pre-commit ] && [ ! -f .git/hooks/pre-commit ]; then
  pre-commit install
fi

# .devcontainer/compose.yml側で/usr/local/bin/apache2-foregroundで起動している
# Webサーバーのログなどをターミナルで確認したい場合は、
# compose.yml側のcommand部を`sleep infinity`に変更して、下記のコマンドで起動する
# apache2ctl start
