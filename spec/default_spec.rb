require 'spec_helper'

describe 'role mysql' do
  describe package('mysql' + property['mysql_ga_version'].to_s.gsub('.', '') + '-community-release') do
    it { should be_installed }
  end
  %w{5.5 5.6 5.7 8.0}.each do |version|
    describe yumrepo('mysql' + version.to_s.gsub('.', '') + '-community') do
      it { should exist }
      if version == property['mysql_version'].to_s
        it { should be_enabled }
      else
        it { should_not be_enabled }
      end
    end
  end
  property['mysql_packages'].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
  describe package('MySQL-python') do
    it { should be_installed }
  end
  describe port(3306) do
    it { should be_listening }
  end
  describe service('mysqld') do
    it { should be_enabled }
    it { should be_running }
  end
end
