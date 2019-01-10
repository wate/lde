import os
import yaml
import pytest

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
    pkg = host.package('python2-dns-lexicon')
    assert pkg.is_installed


@pytest.mark.parametrize('name', ansible_target_variables['lexicon_additional_packages'])
def test_additional_package(host, name):
    pkg = host.package(name)
    assert pkg.is_installed
