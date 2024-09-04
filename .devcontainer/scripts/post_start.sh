#!/usr/bin/env bash
set -euxo pipefail

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

if type "ansible" >/dev/null 2>&1 && [ -f "$(dirname $0)/post_start.yml" ]; then
  ansible-playbook  -i 127.0.0.1, -c local --diff "$(dirname $0)/post_start.yml"
fi

apache2ctl start
