#!/usr/bin/env bash
if type "mysqldump" >/dev/null 2>&1; then
  mysqldump -u app_dev -papp_dev_password app_dev >/vagrant/database_backup.sql
fi
