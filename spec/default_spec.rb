require 'spec_helper'

describe 'role phpmyadmin' do
  describe package('phpMyAdmin') do
    it { should be_installed }
  end
  describe file('/etc/httpd/conf.d/phpMyAdmin.conf') do
    it { should_not exist }
  end
end
