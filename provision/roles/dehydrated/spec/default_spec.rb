require 'spec_helper'

def e(value)
  return Regexp.escape(value)
end

describe 'role dehydrated' do
  describe package('dehydrated') do
    it { should be_installed }
  end
  describe file(property['dehydrated_config_dir'] + '/config') do
    it { should exist }
    it { should be_file }
    if property['dehydrated_cfg'].has_key?('ip_version')
      its(:content) { should match /^IP_VERSION="#{property['dehydrated_cfg']['ip_version']}"/ }
    end
    if property['dehydrated_cfg'].has_key?('ca')
      its(:content) { should match /^CA="#{e(property['dehydrated_cfg']['ca'])}"/ }
    end
    if property['dehydrated_cfg'].has_key?('ca_terms')
      its(:content) { should match /^CA_TERMS="#{e(property['dehydrated_cfg']['ca_terms'])}"/ }
    end
    if property['dehydrated_cfg'].has_key?('challengetype')
      its(:content) { should match /^CHALLENGETYPE="#{e(property['dehydrated_cfg']['challengetype'])}"/ }
    end
    if property['dehydrated_cfg'].has_key?('wellknown')
      its(:content) { should match /^WELLKNOWN="#{e(property['dehydrated_cfg']['wellknown'])}"/ }
    end
    if property['dehydrated_cfg'].has_key?('keysize')
      its(:content) { should match /^KEYSIZE="#{property['dehydrated_cfg']['keysize']}"/ }
    end
    if property['dehydrated_cfg'].has_key?('hook_chain')
      hook_chain = property['dehydrated_cfg']['hook_chain'] ? 'yes' : 'no'
      its(:content) { should match /^HOOK_CHAIN="#{hook_chain}"/ }
    end
    if property['dehydrated_cfg'].has_key?('renew_days')
      its(:content) { should match /^RENEW_DAYS="#{property['dehydrated_cfg']['renew_days']}"/ }
    end
    if property['dehydrated_cfg'].has_key?('private_key_renew')
      private_key_renew = property['dehydrated_cfg']['private_key_renew'] ? 'yes' : 'no'
      its(:content) { should match /^PRIVATE_KEY_RENEW="#{private_key_renew}"/ }
    end
    if property['dehydrated_cfg'].has_key?('private_key_rollover')
      private_key_rollover = property['dehydrated_cfg']['private_key_rollover'] ? 'yes' : 'no'
      its(:content) { should match /^PRIVATE_KEY_ROLLOVER="#{private_key_rollover}"/ }
    end
    if property['dehydrated_cfg'].has_key?('key_algo')
      its(:content) { should match /^KEY_ALGO="#{e(property['dehydrated_cfg']['key_algo'])}"/ }
    end
    if property['dehydrated_cfg'].has_key?('contact_email')
      its(:content) { should match /^CONTACT_EMAIL="#{e(property['dehydrated_cfg']['contact_email'])}"/ }
    end
    if property['dehydrated_cfg'].has_key?('ocsp_must_staple')
      ocsp_must_staple = property['dehydrated_cfg']['ocsp_must_staple'] ? 'yes' : 'no'
      its(:content) { should match /^OCSP_MUST_STAPLE="#{ocsp_must_staple}"/ }
    end
  end
  describe file(property['dehydrated_config_dir'] + '/domains.txt') do
    it { should exist }
    it { should be_file }
    property['dehydrated_domains'].each do |domain|
      if domain.is_a?(String)
        its(:content) { should match /^#{e(domain)}$/ }
      elsif domain.is_a?(Array)
        its(:content) { should match /^#{e(domain.join(' '))}$/ }
      end
    end
  end
  describe file(property['dehydrated_config_dir'] + '/hook.sh') do
    it { should exist }
    it { should be_file }
    it { should be_mode 750 }
  end
end
