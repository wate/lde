require 'spec_helper'

describe 'dehydrated' do
  describe package('dehydrated') do
    it { should be_installed }
  end

  describe file('/etc/dehydrated/conf.d/local.sh') do
    it { should exist }
    it { should be_file }
  end

  describe file('/etc/dehydrated/domains.txt') do
    it { should exist }
    it { should be_file }
  end

  describe file('/etc/dehydrated/hook.sh') do
    it { should exist }
    it { should be_file }
    it { should be_mode 750 }
  end
end
