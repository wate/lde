#!/usr/bin/env bash

SCRIPT_PATH=$(realpath $0)
BIN_DIR=$(dirname $SCRIPT_PATH)
ansible-playbook -i 127.0.0.1, -c local ${BIN_DIR}/fetch_wiki.yml
