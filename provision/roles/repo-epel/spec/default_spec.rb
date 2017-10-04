require 'spec_helper'

describe 'role repo-epel' do
  describe package('epel-release') do
    it { should be_installed }
  end
  describe yumrepo('epel') do
    it { should exist }
    if property["repo_epel_enabled"]
      it { should be_enabled }
    else
      it { should_not be_enabled }
    end
  end
end
