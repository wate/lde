require 'spec_helper'

property['apache_packages'].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end
describe file('/etc/httpd/conf/httpd.conf') do
  it { should exist }
  it { should be_file }
  include_path = e(property['apache_virtualhost_conf_dir'] + '/*.conf')
  its(:content) { should match(/^Include #{include_path}/) }
  enable_mmap = property['apache_cfg']['enable_mmap'] ? 'on' : 'off'
  its(:content) { should match(/^EnableMMAP #{enable_mmap}/) }
  enable_sendfile = property['apache_cfg']['enable_sendfile'] ? 'on' : 'off'
  its(:content) { should match(/^EnableSendfile #{enable_sendfile}/) }
end

describe file('/etc/httpd/conf.d/security.conf') do
  it { should exist }
  it { should be_file }
  trace_enable = property['apache_secrity_cfg']['trace_enable'] ? 'on' : 'off'
  its(:content) { should match(/^TraceEnable #{trace_enable}/) }
  its(:content) { should match(/^ServerTokens #{property['apache_secrity_cfg']['server_tokens']}/) }
  property['apache_secrity_cfg']['headers'].each do |name, value|
    its(:content) { should match(/^Header set #{e(name)} #{e(value)}/) }
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

describe file(property['apache_snippet_dir']) do
  it { should exist }
  it { should be_directory }
end

property['apache_vhosts'].each do |site|
  state = site.key?('state') ? site['state'] : true
  file_name = site.key?('name') ? site['name'] : site['server_name']
  describe file('/etc/httpd/vhost/' + file_name + '.conf') do
    if state
      it { should exist }
      it { should be_file }
      vhost_ip = site.key?('ip') ? site['ip'] : '*'
      vhost_port = site.key?('ssl') ? '443' : '80'

      vhost_port = site['port'] if site.key?('port')
      its(:content) { should match(/^<VirtualHost #{e(vhost_ip)}:#{e(vhost_port)}>/) }
      its(:content) { should match(/^\s+ServerName #{e(site['server_name'])}/) } if site.key?('server_name')
      if site.key?('server_alias')
        server_alias_value = site['server_alias'].is_a?(Array) ? site['server_alias'].join(' ') : site['server_alias']
        its(:content) { should match(/^\s+ServerAlias #{e(server_alias_value)}/) }
      end
      if site.key?('document_root')
        its(:content) { should match(/^\s+DocumentRoot #{e(site['document_root'])}/) }
        its(:content) { should match(/^\s+<Directory #{e(site['document_root'])}>/) }
        if site.key?('options')
          options_value = site['options'].is_a?(Array) ? site['options'].join(' ') : site['options']
          its(:content) { should match(/^\s+Options #{e(options_value)}/) }
        end

        its(:content) { should match(/^\s+AllowOverride #{e(site['allow_override'])}/) } if site.key?('allow_override')
        if site.key?('require')
          site['require'].each do |require_directive|
            require_type = require_directive['type']
            require_value = require_directive['value']
            op_not = ''
            op_not = 'not ' if require_directive.key?('not') && require_directive['not']
            its(:content) { should match(/^\s+Require #{op_not}#{e(require_type)} #{e(require_value)}/) }
          end
        else
          its(:content) { should match(/^\s+Require all granted/) }
        end
      end
      if site.key?('alias')
        site['alias'].each do |alias_directive|
          its(:content) { should match(/^\s+Alias #{e(alias_directive['from'])} #{e(alias_directive['to'])}/) }
        end
      end
      if site.key?('directory_index')
        directive = site['directory_index'].is_a?(Array) ? site['directory_index'].join(' ') : site['directory_index']
        its(:content) { should match(/^\s+DirectoryIndex #{e(directive)}/) }
      end
      if site.key?('custom_log')
        custom_log_path = site['custom_log']['path']
        custom_log_format = site['custom_log']['format']
        its(:content) { should match(/^\s+CustomLog #{e(custom_log_path)} #{e(custom_log_format)}/) }
      end
      if site.key?('error_log')
        its(:content) { should match(/^\s+ErrorLog #{e(site['error_log']['path'])}/) }
        log_level = site['error_log'].key?('log_level') ? site['error_log']['log_level'] : 'warn'
        its(:content) { should match(/^\s+LogLevel #{e(log_level)}/) }
      end
      if site.key?('transfer_log')
        if site['transfer_log'].key?('format')
          its(:content) { should match(/^\s+LogFormat #{e(site['transfer_log']['format'])}/) }
        end
        its(:content) { should match(/^\s+TransferLog #{e(site['transfer_log']['path'])}/) }
      end
      if site.key?('proxy_pass')
        site['proxy_pass'].each do |proxy_pass|
          proxy_pass_from = proxy_pass['from']
          proxy_pass_to = proxy_pass['to']
          its(:content) { should match(/^\s+ProxyPass #{e(proxy_pass_from)} #{e(proxy_pass_to)}/) }
        end
      end
      if site.key?('proxy_pass_reverse')
        site['proxy_pass_reverse'].each do |proxy_pass_reverse|
          proxy_reverse_from = proxy_pass_reverse['from']
          proxy_reverse_to = proxy_pass_reverse['to']
          its(:content) { should match(/^\s+ProxyPassReverse #{e(proxy_reverse_from)} #{e(proxy_reverse_to)}/) }
        end
      end
      if site.key?('proxy_pass_match')
        site['proxy_pass_match'].each do |proxy_pass_match|
          proxy_match_pattern = proxy_pass_match['pattern']
          proxy_match_to = proxy_pass_match['to']
          its(:content) { should match(/^\s+ProxyPassMatch #{e(proxy_match_pattern)} #{e(proxy_match_to)}/) }
        end
      end
      if site.key?('ssl')
        site_ssl = site['ssl']
        its(:content) { should match(/^\s+SSLEngine on/) }
        its(:content) { should match(/^\s+SSLCertificateFile #{e(site_ssl['certificate_file'])}/) }
        its(:content) { should match(/^\s+SSLCertificateKeyFile #{e(site_ssl['certificate_key_file'])}/) }
        if site.key?('certificate_chain_file')
          its(:content) { should match(/^\s+SSLCertificateChainFile #{e(site_ssl['certificate_chain_file'])}/) }
        end
        if site_ssl.key?('protocol')
          ssl_protocol = site_ssl['protocol'].join(' ')
          its(:content) { should match(/^\s+SSLProtocol #{e(ssl_protocol)}/) }
        end
        if site_ssl.key?('cipher_suite')
          ssl_cipher_suite = site_ssl['cipher_suite'].join(':')
          its(:content) { should match(/^\s+SSLCipherSuite #{e(ssl_cipher_suite)}/) }
        end
        if site_ssl.key?('honor_cipher_order')
          ssl_honor_cipher_order = site_ssl['honor_cipher_order'] ? 'on' : 'off'
          its(:content) { should match(/^\s+SSLHonorCipherOrder #{ssl_honor_cipher_order}/) }
        end
        if site_ssl.key?('compression')
          ssl_compression = site_ssl['compression'] ? 'on' : 'off'
          its(:content) { should match(/^\s+SSLCompression #{ssl_compression}/) }
        end
        if site_ssl.key?('stapling_responder_timeout')
          stapling_responder_timeout = site_ssl['stapling_responder_timeout'].to_s
          its(:content) { should match(/^\s+SSLStaplingResponderTimeout #{e(stapling_responder_timeout)}/) }
        end
        if site_ssl.key?('stapling_return_responder_errors')
          stapling_return_responder_errors = site_ssl['stapling_return_responder_errors'] ? 'on' : 'off'
          its(:content) { should match(/^\s+SSLStaplingReturnResponderErrors #{stapling_return_responder_errors}/) }
        end
        if site_ssl.key?('stapling_cache')
          its(:content) { should match(/^\s+SSLStaplingCache #{e(site_ssl['stapling_cache'])}/) }
        end
        if site_ssl.key?('hsts')
          its(:content) { should match(/^\s+Header always set Strict-Transport-Security #{e(site_ssl['hsts'])}/) }
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
  apache_ssl_cfg = property['apache_ssl_cfg']
  describe file('/etc/httpd/conf.d/ssl.conf') do
    it { should exist }
    it { should be_file }
    ssl_protocol = apache_ssl_cfg['protocol'].join(' ')
    its(:content) { should match(/^SSLProtocol #{e(ssl_protocol)}/) }
    ssl_cipher_suite = apache_ssl_cfg['cipher_suite'].join(':')
    its(:content) { should match(/^SSLCipherSuite #{e(ssl_cipher_suite)}/) }
    ssl_honor_cipher_order = apache_ssl_cfg['honor_cipher_order'] ? 'on' : 'off'
    its(:content) { should match(/^SSLHonorCipherOrder #{ssl_honor_cipher_order}/) }
    ssl_compression = apache_ssl_cfg['compression'] ? 'on' : 'off'
    its(:content) { should match(/^SSLCompression #{ssl_compression}/) }
    ssl_use_stapling = apache_ssl_cfg['use_stapling'] ? 'on' : 'off'
    its(:content) { should match(/^SSLUseStapling #{ssl_use_stapling}/) }
    stapling_responder_timeout = apache_ssl_cfg['stapling_responder_timeout'].to_s
    its(:content) { should match(/^SSLStaplingResponderTimeout #{e(stapling_responder_timeout)}/) }
    ssl_stapling_return_responder_errors = apache_ssl_cfg['stapling_return_responder_errors'] ? 'on' : 'off'
    its(:content) { should match(/^SSLStaplingReturnResponderErrors #{ssl_stapling_return_responder_errors}/) }
    its(:content) { should match(/^SSLStaplingCache #{e(apache_ssl_cfg['stapling_cache'])}/) }
  end
  describe port(443) do
    it { should be_listening }
  end
end
