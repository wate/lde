import os
import yaml
import glob
# import pytest
# import re

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

role_vars = role_default_vars = {}
role_default_var_file = os.environ['MOLECULE_PROJECT_DIRECTORY'] + '/defaults/main.yml'
if os.path.exists(role_default_var_file):
    role_default_vars.update(yaml.full_load(open(role_default_var_file, 'r')))
    role_vars.update(role_default_vars)

role_var_file = os.environ['MOLECULE_PROJECT_DIRECTORY'] + '/vars/main.yml'
if os.path.exists(role_var_file):
    role_vars.update(yaml.full_load(open(role_var_file, 'r')))

ansible_host_vars = {}
host_dump_var_dir = os.environ['MOLECULE_SCENARIO_DIRECTORY'] + '/dump_vars'
if os.path.exists(host_dump_var_dir):
    dump_var_files = glob.glob(host_dump_var_dir + '/*.yml')
    for dump_var_file in dump_var_files:
        inventory_hostname = os.path.basename(dump_var_file)[:-4]
        ansible_host_vars[inventory_hostname] = yaml.full_load(open(dump_var_file, 'r'))


def test_package(host):
    pkg = host.package('python2-dns-lexicon')
    assert pkg.is_installed
