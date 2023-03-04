#!/usr/bin/env bash

WORKING_DIR=${PWD}
SCRIPT_PATH=$(realpath $0)
BIN_DIR=$(dirname $SCRIPT_PATH)
ROOT_DIR=$(realpath ${BIN_DIR}/../)
if [ "${ROOT_DIR}" != "${WORKING_DIR}" ]; then
    cd ${ROOT_DIR} || return
fi
ansible-playbook -i 127.0.0.1, -c local ${BIN_DIR}/update_wiki.yml --extra-vars "{root_dir: ${ROOT_DIR}}"
if [ "${ROOT_DIR}" != "${WORKING_DIR}" ]; then
    cd ${WORKING_DIR}  || return
fi
