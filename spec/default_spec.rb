require 'spec_helper'

describe file('/etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL') do
  it { should exist }
  it { should be_file }
end

describe file('/etc/yum.repos.d/nodesource-el.repo') do
  it { should exist }
  it { should be_file }
  repo_baseurl = 'https://rpm.nodesource.com/pub_' + property['nodejs_major_version'].to_s + '.x/el/'
  its(:content) { should match(/baseurl\s*=\s*#{e(repo_baseurl)}/) }
end

describe yumrepo('nodesource') do
  it { should exist }
  it { should be_enabled }
end

describe yumrepo('nodesource-source') do
  it { should exist }
  it { should_not be_enabled }
end

describe package('nodejs') do
  it { should be_installed }
end
