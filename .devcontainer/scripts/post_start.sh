#!/usr/bin/env bash
if [ -f composer.json ] && [ ! -e vendor ]; then
  composer install --no-interaction
fi

if [ -f package.json ] && [ ! -e node_modules ]; then
  npm install
fi

if type "direnv" >/dev/null 2>&1 && [ -f .envrc ]; then
  direnv allow
fi

# if type "pre-commit" >/dev/null 2>&1 && [ -f .pre-commit-config.yaml ]; then
#   if [ ! -e .git/hooks/pre-commit ]; then
#     pre-commit install
#   fi
#   pre-commit autoupdate
# fi

if type "ansible" >/dev/null 2>&1 && [ -f "$(dirname $0)/post_start.yml" ]; then
  ansible-playbook  -i 127.0.0.1, -c local --diff "$(dirname $0)/post_start.yml"
fi

apache2ctl start
