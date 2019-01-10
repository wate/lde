import os
import yaml

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

ansible_target_variables = {}
var_file = os.environ['MOLECULE_PROJECT_DIRECTORY'] + '/defaults/main.yml'
if os.path.exists(var_file):
    ansible_target_variables.update(yaml.load(open(var_file, 'r')))

var_file = os.environ['MOLECULE_PROJECT_DIRECTORY'] + '/vars/main.yml'
if os.path.exists(var_file):
    ansible_target_variables.update(yaml.load(open(var_file, 'r')))


def test_package(host):
    pkg = host.package('epel-release')
    assert pkg.is_installed


def test_yumrepo(host):
    result = host.check_output("yum repolist all -C | awk '{ print $1 }'")
    assert 'epel/' in result
    result = host.check_output("yum repolist enabled -C | awk '{ print $1 }'")
    if ansible_target_variables['repo_epel_enabled']:
        assert 'epel/' in result
    else:
        assert 'epel/' not in result
