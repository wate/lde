require 'spec_helper'

describe 'PHP' do
  php_packages = [
    'php',
    'php-common',
    'php-cli',
    'php-devel',
    'php-opcache',
    'php-mbstring',
    'php-mysqlnd',
    'php-json',
    'php-pdo',
    'php-gd',
    'php-xml',
  ]
  php_packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe 'PHP config parameters' do
    context php_config('display_errors') do
      its(:value) { should eq 1 }
    end
    context php_config('sendmail_path') do
      its(:value) { should eq '/usr/local/bin/mhsendmail' }
    end
  end
end
