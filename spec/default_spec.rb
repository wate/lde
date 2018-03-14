require 'spec_helper'
require 'open-uri'

describe file('/etc/skel/public') do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
end

describe file('/home') do
  it { should be_mode 755 }
end

describe file('/etc/sudoers.d/wheel') do
  it { should exist }
  it { should be_file }
  if property['sudo_require_password']
    it { should contain '%wheel ALL=(ALL) ' }
    it { should_not contain '%wheel ALL=(ALL) NOPASSWD: ALL' }
  else
    it { should contain '%wheel ALL=(ALL) NOPASSWD: ALL' }
  end
end

property['common_groups'].each do |group|
  describe group(group['name']) do
    is_removed = group.key?('remove') && group['remove']
    if is_removed
      it { should_not exist }
    else
      it { should exist }
    end
  end
end

property['common_users'].each do |user|
  describe user(user['name']) do
    is_removed = user.key?('remove') && user['remove']
    if is_removed
      it { should_mot exist }
    else
      it { should exist }
      it { should have_login_shell user['shell'] } if user.key?('shell')
      if user.key?('groups')
        user['groups'].each do |group_name|
          it { should belong_to_group group_name }
        end
      end
    end
  end
end

property['common_packages'].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe package('firewalld') do
  it { should be_installed }
end

describe package('etckeeper') do
  it { should be_installed }
end

describe package('fail2ban') do
  it { should be_installed }
end

describe service('firewalld') do
  it { should be_enabled }
  it { should be_running }
end

describe service('fail2ban') do
  it { should be_enabled }
  it { should be_running }
end
