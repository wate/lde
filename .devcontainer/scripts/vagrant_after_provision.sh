#!/usr/bin/env bash
if type "mysql" >/dev/null 2>&1 && [ -f /vagrant/database_backup.sql ]; then
  mysql -u app_dev -papp_dev_password app_dev </vagrant/database_backup.sql
  if [ $? -eq 0 ]; then
    rm -f /vagrant/database_backup.sql
  fi
fi
