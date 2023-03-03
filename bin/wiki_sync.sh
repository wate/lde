#!/usr/bin/env bash

BIN_DIR=$(dirname $0)
ansible-playbook -i 127.0.0.1, -c local ${BIN_DIR}/wiki_sync.yml
