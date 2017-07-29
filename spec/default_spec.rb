require 'spec_helper'

describe 'role wp-cli' do
  describe file('/usr/local/bin/wp') do
    it { should exist }
    it { should be_file }
    it { should be_executable }
  end
end
