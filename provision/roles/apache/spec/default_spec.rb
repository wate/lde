require 'spec_helper'

def e(value)
  return Regexp.escape(value.is_a?(String) ? value : value.to_s)
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
  describe file('/etc/httpd/conf.d/extra.conf') do
    it { should exist }
    it { should be_file }
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
          vhost_ip = site.has_key?('ip') ? site['ip'] : '*'
          vhost_port = site.has_key?('ssl') ? '443' : '80'
          if site.has_key?('port')
            vhost_port = site['port']
          end
          its(:content) { should match /^<VirtualHost #{e(vhost_ip)}:#{e(vhost_port)}>/ }
          if site.has_key?('server_name')
            its(:content) { should match /^\s+ServerName #{e(site['server_name'])}/ }
          end
          if site.has_key?('server_alias')
            directive = site['server_alias'].is_a?(Array) ? site['server_alias'].join(' ') : site['server_alias']
            its(:content) { should match /^\s+ServerAlias #{e(directive)}/ }
          end
          if site.has_key?('document_root')
            its(:content) { should match /^\s+DocumentRoot #{e(site['document_root'])}/ }
            its(:content) { should match /^\s+<Directory #{e(site['document_root'])}>/ }
            if site.has_key?('options')
              directive = site['options'].is_a?(Array) ? site['options'].join(' ') : site['options']
              its(:content) { should match /^\s+Options #{e(directive)}/ }
            end
            if site.has_key?('allow_override')
              its(:content) { should match /^\s+AllowOverride #{e(site['allow_override'])}/ }
            end
            if site.has_key?('require')
              site['require'].each do |directive|
                op_not = ''
                if directive.has_key?('not') and directive['not']
                  op_not = 'not '
                end
                its(:content) { should match /^\s+Require #{op_not}#{e(directive['type'])} #{e(directive['value'])}/ }
              end
            else
              its(:content) { should match /^\s+Require all granted/ }
            end
          end
          if site.has_key?('alias')
            site['alias'].each do |directive|
              its(:content) { should match /^\s+Alias #{e(directive['from'])} #{e(directive['to'])}/ }
            end
          end
          if site.has_key?('directory_index')
            directive = site['directory_index'].is_a?(Array) ? site['directory_index'].join(' ') : site['directory_index']
            its(:content) { should match /^\s+DirectoryIndex #{e(directive)}/ }
          end
          if site.has_key?('custom_log')
            its(:content) { should match /^\s+CustomLog #{e(site['custom_log']['path'])} #{e(site['custom_log']['format'])}/ }
          end
          if site.has_key?('error_log')
            its(:content) { should match /^\s+ErrorLog #{e(site['error_log']['path'])}/ }
            log_level = site['error_log'].has_key?('log_level') ? site['error_log']['log_level'] : 'warn'
            its(:content) { should match /^\s+LogLevel #{e(log_level)}/ }
          end
          if site.has_key?('transfer_log')
            if site['transfer_log'].has_key?('format')
              its(:content) { should match /^\s+LogFormat #{e(site['transfer_log']['format'])}/ }
            end
            its(:content) { should match /^\s+TransferLog #{e(site['transfer_log']['path'])}/ }
          end
          if site.has_key?('proxy_pass')
            site['proxy_pass'].each do |directive|
              its(:content) { should match /^\s+ProxyPass #{e(directive['from'])} #{e(directive['to'])}/ }
            end
          end
          if site.has_key?('proxy_pass_reverse')
            site['proxy_pass_reverse'].each do |directive|
              its(:content) { should match /^\s+ProxyPassReverse #{e(directive['from'])} #{e(directive['to'])}/ }
            end
          end
          if site.has_key?('proxy_pass_match')
            site['proxy_pass_match'].each do |directive|
              its(:content) { should match /^\s+ProxyPassMatch #{e(directive['pattern'])} #{e(directive['to'])}/ }
            end
          end
          if site.has_key?('ssl')
            its(:content) { should match /^\s+SSLEngine on/ }
            its(:content) { should match /^\s+SSLCertificateFile #{e(site['ssl']['certificate_file'])}/ }
            its(:content) { should match /^\s+SSLCertificateKeyFile #{e(site['ssl']['certificate_key_file'])}/ }
            if site.has_key?('certificate_chain_file')
              its(:content) { should match /^\s+SSLCertificateChainFile #{e(site['ssl']['certificate_chain_file'])}/ }
            end
            if site['ssl'].has_key?('protocol')
              ssl_protocol = site['ssl']['protocol'].join(' ')
              its(:content) { should match /^\s+SSLProtocol #{e(ssl_protocol)}/ }
            end
            if site['ssl'].has_key?('cipher_suite')
              ssl_cipher_suite = site['ssl']['cipher_suite'].join(':')
              its(:content) { should match /^\s+SSLCipherSuite #{e(ssl_cipher_suite)}/ }
            end
            if site['ssl'].has_key?('honor_cipher_order')
              ssl_honor_cipher_order = site['ssl']['honor_cipher_order'] ? 'on' : 'off'
              its(:content) { should match /^\s+SSLHonorCipherOrder #{ssl_honor_cipher_order}/ }
            end
            if site['ssl'].has_key?('compression')
              ssl_compression = site['ssl']['compression'] ? 'on' : 'off'
              its(:content) { should match /^\s+SSLCompression #{ssl_compression}/ }
            end
            if site['ssl'].has_key?('stapling_responder_timeout')
              its(:content) { should match /^\s+SSLStaplingResponderTimeout #{e(site['ssl']['stapling_responder_timeout'].to_s)}/ }
            end
            if site['ssl'].has_key?('stapling_return_responder_errors')
              ssl_stapling_return_responder_errors = site['ssl']['stapling_return_responder_errors'] ? 'on' : 'off'
              its(:content) { should match /^\s+SSLStaplingReturnResponderErrors #{ssl_stapling_return_responder_errors}/ }
            end
            if site['ssl'].has_key?('stapling_cache')
              its(:content) { should match /^\s+SSLStaplingCache #{e(site['ssl']['stapling_cache'])}/ }
            end
            if site['ssl'].has_key?('hsts')
              its(:content) { should match /^\s+Header always set Strict-Transport-Security #{e(site['ssl']['hsts'])}/ }
            end
          end
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
