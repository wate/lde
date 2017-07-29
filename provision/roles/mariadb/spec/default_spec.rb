require 'spec_helper'

describe 'role mariadb' do
  property['mariadb_packages'].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
  describe package('MySQL-python') do
    it { should be_installed }
  end
  %w{client mysql mysqld}.each do |name|
    describe file('/etc/my.cnf.d/' + name + '.cnf') do
      it { should exist }
      it { should be_file }
    end
  end
  describe file('/root/.my.cnf') do
    it { should exist }
    it { should be_file }
  end
  describe service('mariadb') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(3306) do
    it { should be_listening }
  end
end
