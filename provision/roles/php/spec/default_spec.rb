require 'spec_helper'

def e(value)
  return Regexp.escape(value)
end

def get_ini_value(value)
  if value.kind_of?(TrueClass) || value.kind_of?(FalseClass)
    return value ? 'On' : 'Off'
  elsif value.nil?
      return ""
  else
    return value.to_s
  end
end

describe 'role php' do
  php_repo_id = 'remi-php' + property['php_version'].to_s.gsub('.', '')
  describe yumrepo(php_repo_id) do
    it { should exist }
    it { should be_enabled }
  end
  property['php_packages'].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
  describe file('/usr/local/bin/composer') do
    it { should exist }
    it { should be_file }
    it { should be_executable }
  end
  describe file('/etc/php.ini') do
    property['php_cfg'].each do |key, value|
      if key != 'extra_parameters'
        if value.is_a?(Hash)
          value.each do |subkey, subvalue|
            ini_value = e(get_ini_value(subvalue))
            if key + '.' + subkey == 'url_rewriter.tags'
              ini_value = '"' + ini_value + '"'
            end
            its(:content) { should match /^#{key}.#{subkey} = #{ini_value}/ }
          end
        else
          its(:content) { should match /^#{key} = #{e(get_ini_value(value))}/ }
        end
      else
        value.each do |section, settings|
          settings.each do |subkey, subvalue|
            its(:content) { should match /^#{section}.#{subkey} = #{e(get_ini_value(subvalue))}/ }
          end
        end
      end
    end
  end
  if property['php_packages'].include?('php-fpm')
    describe service('php-fpm') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
