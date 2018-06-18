require 'spec_helper'

describe file('/usr/local/bin/mailhog') do
  it { should exist }
  it { should be_file }
  it { should be_executable }
end
describe file('/usr/local/bin/mhsendmail') do
  it { should exist }
  it { should be_file }
  it { should be_executable }
end
describe file('/etc/systemd/system/mailhog.service') do
  it { should exist }
  it { should be_file }
end

describe service('mailhog') do
  it { should be_enabled }
  it { should be_running }
end

describe port(property['mailhog_smtp_port'].to_s) do
  it { should be_listening }
end
describe port(property['mailhog_http_port'].to_s) do
  it { should be_listening }
end
