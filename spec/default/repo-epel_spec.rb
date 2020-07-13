require 'spec_helper'

describe 'EPEL repository' do
  describe package('epel-release') do
    it { should be_installed }
  end

  describe yumrepo('epel') do
    it { should exist }
    it { should be_enabled }
  end
end
