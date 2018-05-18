require 'spec_helper'

describe package('ngircd') do
  it { should be_installed }
end

describe file('/etc/ngircd.motd') do
  it { should exist }
  it { should be_file }
end

describe file('/etc/ngircd.conf') do
  it { should exist }
  it { should be_file }
end

describe service('ngircd') do
  it { should be_enabled }
  it { should be_running }
end

describe port(6667) do
  it { should be_listening }
  it { should be_listening.with('tcp') }
end
