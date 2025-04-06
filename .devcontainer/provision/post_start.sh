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

# apache2ctl start
