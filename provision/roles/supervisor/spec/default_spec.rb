require 'spec_helper'

def e(value)
  return Regexp.escape(value.is_a?(String) ? value : value.to_s)
end

describe 'role supervisor' do
  describe package('supervisor') do
    it { should be_installed }
  end
  describe file('/etc/supervisord.conf') do
    it { should exist }
    it { should be_file }
  end
  describe file('/etc/supervisord.d/program.ini') do
    it { should exist }
    it { should be_file }
  end
  describe file('/etc/supervisord.d/eventlistener.ini') do
    it { should exist }
    it { should be_file }
  end
  describe file('/etc/supervisord.d/group.ini') do
    it { should exist }
    it { should be_file }
  end
  describe service('supervisord') do
    it { should be_enabled }
    it { should be_running }
  end
end
