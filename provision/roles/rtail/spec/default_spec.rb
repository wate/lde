require 'spec_helper'

describe 'role rtail' do
  describe user(property['rtail_user']) do
    it { should exist }
  end
  describe package('rtail') do
    it { should be_installed.by('npm') }
  end
  describe service('rtail-server') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(property['rtail_udp_port']) do
    it { should be_listening.with('udp') }
  end
  describe port(property['rtail_web_port']) do
    it { should be_listening.with('tcp') }
  end
end
