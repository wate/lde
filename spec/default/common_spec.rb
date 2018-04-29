require 'spec_helper'

describe 'common' do
  describe file('/etc/skel/public') do
    it { should exist }
    it { should be_directory }
    it { should be_mode 755 }
  end

  describe file('/home') do
    it { should be_mode 755 }
  end
  common_packages = [
    'unzip',
    'zip',
    'perl',
    'cpp',
    'make',
    'autoconf',
    'automake',
    'diffstat',
    'm4',
    'libtool',
    'gcc',
    'gcc-c++',
    'patch',
    'git',
    'yum-utils',
    'vim-enhanced',
    'bash-completion',
    'tig',
  ]
  common_packages.each do |pkg|
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
end
