#!/usr/bin/env bash

if [ -d /vagrant/logs ]; then
  rm -f /vagrant/logs/*.log
fi
