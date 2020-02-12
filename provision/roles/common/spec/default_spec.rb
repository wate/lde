require 'spec_helper'

describe file('/home') do
  it { should be_mode 755 }
end

describe file('/etc/cron.d/ansible_management_job') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
end

property['common_packages'].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe package('firewalld') do
  it { should be_installed }
end

describe service('firewalld') do
  it { should be_enabled }
  it { should be_running }
end
