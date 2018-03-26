require 'spec_helper'

describe package('dehydrated') do
  it { should be_installed }
end

describe file('/etc/dehydrated/conf.d/local.sh') do
  it { should exist }
  it { should be_file }
  dehydrated_cfg = property['dehydrated_cfg']
  if dehydrated_cfg.key?('user')
    its(:content) { should match(/^DEHYDRATED_USER=#{dehydrated_cfg['user']}/) }
  end
  if dehydrated_cfg.key?('group')
    its(:content) { should match(/^DEHYDRATED_GROUP=#{dehydrated_cfg['group']}/) }
  end
  if dehydrated_cfg.key?('ip_version')
    its(:content) { should match(/^IP_VERSION="#{dehydrated_cfg['ip_version']}"/) }
  end
  if dehydrated_cfg.key?('ca')
    its(:content) { should match(/^CA="#{dehydrated_cfg['ca']}"/) }
  end
  if dehydrated_cfg.key?('oldca')
    its(:content) { should match(/^OLDCA="#{dehydrated_cfg['oldca']}"/) }
  end
  if dehydrated_cfg.key?('challengetype')
    its(:content) { should match(/^CHALLENGETYPE="#{dehydrated_cfg['challengetype']}"/) }
  end
  if dehydrated_cfg.key?('keysize')
    its(:content) { should match(/^KEYSIZE="#{dehydrated_cfg['keysize']}"/) }
  end
  if dehydrated_cfg.key?('openssl_cnf')
    its(:content) { should match(/^OPENSSL_CNF="#{dehydrated_cfg['openssl_cnf']}"/) }
  end
  if dehydrated_cfg.key?('openssl')
    its(:content) { should match(/^OPENSSL="#{dehydrated_cfg['openssl']}"/) }
  end
  if dehydrated_cfg.key?('curl_opts')
    its(:content) { should match(/^CURL_OPTS="#{dehydrated_cfg['curl_opts']}"/) }
  end
  if dehydrated_cfg.key?('hook_chain')
    hook_chain = dehydrated_cfg['hook_chain'] ? 'yes' : 'no'
    its(:content) { should match(/^HOOK_CHAIN="#{hook_chain}"/) }
  end
  if dehydrated_cfg.key?('renew_days')
    its(:content) { should match(/^RENEW_DAYS="#{dehydrated_cfg['renew_days']}"/) }
  end
  if dehydrated_cfg.key?('wellknown')
    its(:content) { should match(/^WELLKNOWN="#{dehydrated_cfg['wellknown']}"/) }
  end
  if dehydrated_cfg.key?('private_key_renew')
    private_key_renew = dehydrated_cfg['private_key_renew'] ? 'yes' : 'no'
    its(:content) { should match(/^PRIVATE_KEY_RENEW="#{private_key_renew}"/) }
  end
  if dehydrated_cfg.key?('private_key_rollover')
    private_key_rollover = dehydrated_cfg['private_key_rollover'] ? 'yes' : 'no'
    its(:content) { should match(/^PRIVATE_KEY_ROLLOVER="#{private_key_rollover}"/) }
  end
  if dehydrated_cfg.key?('key_algo')
    its(:content) { should match(/^KEY_ALGO="#{dehydrated_cfg['key_algo']}"/) }
  end
  if dehydrated_cfg.key?('contact_email')
    its(:content) { should match(/^CONTACT_EMAIL="#{dehydrated_cfg['contact_email']}"/) }
  end
  if dehydrated_cfg.key?('ocsp_must_staple')
    ocsp_must_staple = dehydrated_cfg['ocsp_must_staple'] ? 'yes' : 'no'
    its(:content) { should match(/^OCSP_MUST_STAPLE="#{ocsp_must_staple}"/) }
  end
  if dehydrated_cfg.key?('ocsp_fetch')
    ocsp_fetch = dehydrated_cfg['ocsp_fetch'] ? 'yes' : 'no'
    its(:content) { should match(/^OCSP_FETCH="#{ocsp_fetch}"/) }
  end
  if dehydrated_cfg.key?('auto_cleanup')
    auto_cleanup = dehydrated_cfg['auto_cleanup'] ? 'yes' : 'no'
    its(:content) { should match(/^AUTO_CLEANUP="#{auto_cleanup}"/) }
  end
  if dehydrated_cfg.key?('api')
    auto_cleanup = dehydrated_cfg['api'] ? 'yes' : 'no'
    its(:content) { should match(/^API="#{dehydrated_cfg['api']}"/) }
  end
end

describe file('/etc/dehydrated/domains.txt') do
  it { should exist }
  it { should be_file }
  property['dehydrated_domains'].each do |domain|
    if domain.is_a?(String)
      its(:content) { should match(/^#{e(domain)}$/) }
    elsif domain.is_a?(Array)
      its(:content) { should match(/^#{e(domain.join(' '))}$/) }
    end
  end
end

describe file('/etc/dehydrated/hook.sh') do
  it { should exist }
  it { should be_file }
  it { should be_mode 750 }
end
