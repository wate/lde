require 'spec_helper'

describe 'role repo-remi' do
  describe package('remi-release') do
    it { should be_installed }
  end
  describe yumrepo('remi') do
    it { should exist }
  end
  describe command("yum repolist enabled -C|awk '{print $1}' | grep -E '^remi$'") do
    if property["repo_remi_enabled"]
      its(:stdout) { should contain('remi') }
    else
      its(:stdout) { should_not contain('remi') }
    end
  end
end
