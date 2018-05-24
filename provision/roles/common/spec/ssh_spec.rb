require 'spec_helper'

%w[GeoIP GeoIP-data GeoIP-update].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file('/usr/local/bin/sshfilter') do
  it { should exist }
  it { should be_file }
  it { should be_mode 755 }
  it { should contain "ALLOW_COUNTRIES=\"#{property['common_ssh_allow_countries'].join(' ')}\"" }
end

describe file('/etc/hosts.deny') do
  if property['common_ssh_use_geoip_filter']
    its(:content) { should match(/^sshd: ALL/) }
  else
    its(:content) { should_not match(/^sshd:/) }
  end
end

describe file('/etc/hosts.allow') do
  if property['common_ssh_use_geoip_filter']
    its(:content) { should match(/^sshd:/) }
  else
    its(:content) { should_not match(/^sshd:/) }
  end
end

describe port(property['common_ssh_port']) do
  it { should be_listening }
end
