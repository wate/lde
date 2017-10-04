require 'spec_helper'

describe 'role mailcatcher' do
  %w{gcc gcc-c++ sqlite-devel}.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
  describe package('mailcatcher') do
    it { should be_installed.by('gem') }
  end
  describe service('mailcatcher') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(property['mailcatcher_smtp_port']) do
    it { should be_listening }
  end
  describe port(property['mailcatcher_web_port']) do
    it { should be_listening }
  end
end
