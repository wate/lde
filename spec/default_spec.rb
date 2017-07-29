require 'spec_helper'

describe 'role common' do
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
end
