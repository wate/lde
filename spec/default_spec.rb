require 'spec_helper'

def e(value)
  return Regexp.escape(value)
end

describe 'role apache' do
  property['apache_packages'].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
  describe file('/etc/httpd/conf/httpd.conf') do
    it { should exist }
    it { should be_file }

    include_path = e(property['apache_virtualhost_conf_dir'] + '/*.conf')
    its(:content) { should match /^Include #{include_path}/ }

    enable_sendfile = property['apache_cfg']['enable_sendfile'] ? 'on' : 'off'
    its(:content) { should match /^EnableSendfile #{enable_sendfile}/ }
  end
  describe file('/etc/httpd/conf.d/security.conf') do
    it { should exist }
    it { should be_file }

    trace_enable = property['apache_secrity_cfg']['trace_enable'] ? 'on' : 'off'
    its(:content) { should match /^TraceEnable #{trace_enable}/ }

    its(:content) { should match /^ServerTokens #{property['apache_secrity_cfg']['server_tokens']}/ }
    property['apache_secrity_cfg']['headers'].each do |name, value|
      its(:content) { should match /^Header set #{e(name)} #{e(value)}/ }
    end
  end

  describe file(property['apache_virtualhost_conf_dir']) do
    it { should exist }
    it { should be_directory }
  end

  property['apache_vhosts'].each do |site|
    state = site.has_key?('state') ? site['state'] : true
    file_name = site.has_key?('name') ? site['name'] : site['server_name']
    describe file('/etc/httpd/vhost/' + file_name + '.conf') do
        if state
          it { should exist }
          it { should be_file }
        else
          it { should_not exist }
        end
    end
  end
  describe service('httpd') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(80) do
    it { should be_listening }
  end
  if property['apache_packages'].include?('mod_ssl')
    describe file('/etc/httpd/conf.d/ssl.conf') do
      it { should exist }
      it { should be_file }

      ssl_protocol = property['apache_ssl_cfg']['protocol'].join(' ')
      its(:content) { should match /^SSLProtocol #{e(ssl_protocol)}/ }

      ssl_cipher_suite = property['apache_ssl_cfg']['cipher_suite'].join(':')
      its(:content) { should match /^SSLCipherSuite #{e(ssl_cipher_suite)}/ }

      ssl_honor_cipher_order = property['apache_ssl_cfg']['honor_cipher_order'] ? 'on' : 'off'
      its(:content) { should match /^SSLHonorCipherOrder #{ssl_honor_cipher_order}/ }

      ssl_compression = property['apache_ssl_cfg']['compression'] ? 'on' : 'off'
      its(:content) { should match /^SSLCompression #{ssl_compression}/ }

      ssl_use_stapling = property['apache_ssl_cfg']['use_stapling'] ? 'on' : 'off'
      its(:content) { should match /^SSLUseStapling #{ssl_use_stapling}/ }

      its(:content) { should match /^SSLStaplingResponderTimeout #{e(property['apache_ssl_cfg']['stapling_responder_timeout'].to_s)}/ }

      ssl_stapling_return_responder_errors = property['apache_ssl_cfg']['stapling_return_responder_errors'] ? 'on' : 'off'
      its(:content) { should match /^SSLStaplingReturnResponderErrors #{ssl_stapling_return_responder_errors}/ }

      its(:content) { should match /^SSLStaplingCache #{e(property['apache_ssl_cfg']['stapling_cache'])}/ }
    end
    describe port(443) do
      it { should be_listening }
    end
  end
end
