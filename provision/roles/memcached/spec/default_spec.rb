require 'spec_helper'

describe package('memcached') do
  it { should be_installed }
end

memcached_port = 11_211
memcached_port = property['memcached_cfg']['port'] if property['memcached_cfg'].key?('port')

describe file('/etc/sysconfig/memcached') do
  it { should exist }
  it { should be_file }
  it { should contain "PORT=\"#{memcached_port}\"" }
  it { should contain "USER=\"#{property['memcached_cfg']['user']}\"" }
  it { should contain "MAXCONN=\"#{property['memcached_cfg']['maxconn']}\"" }
  it { should contain "CACHESIZE=\"#{property['memcached_cfg']['cachesize']}\"" }
  memcached_options = property['memcached_cfg']['options']
  if property['memcached_cfg']['options'].is_a?(Array)
    memcached_options = property['memcached_cfg']['options'].join(' ')
  end
  it { should contain "OPTIONS=\"#{memcached_options}\"" }
end

describe service('memcached') do
  it { should be_enabled }
  it { should be_running }
end

describe port(memcached_port) do
  it { should be_listening }
end
