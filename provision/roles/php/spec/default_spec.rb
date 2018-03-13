require 'spec_helper'

php_repo_id = 'remi-php' + property['php_version'].to_s.delete('.')

describe yumrepo(php_repo_id) do
  it { should exist }
  it { should be_enabled }
end

property['php_packages'].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe package('composer') do
  it { should be_installed }
end

if property['php_packages'].include?('php-fpm')
  describe service('php-fpm') do
    it { should be_enabled }
    it { should be_running }
  end
end
