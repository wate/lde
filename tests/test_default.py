import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
  '.molecule/ansible_inventory').get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'

# def test_apt_line(host):
#     ans_vars = host.ansible('setup')['ansible_facts']
#
#     f = host.file('/etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL')
#     assert f.exists
#     assert f.is_file
#
#     f = host.file('/etc/yum.repos.d/nodesource-el.repo')
#     assert f.exists
#     assert f.is_file
#     repo_baseurl = 'https://rpm.nodesource.com/pub_'
#     repo_baseurl += ans_vars['nodejs_major_version'] + '.x/el/'
#     assert f.contains('baseurl = ' + repo_baseurl)
#
#
# def test_package(host):
#     p = host.package('nodejs')
#     assert p.is_installed
