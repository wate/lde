require 'spec_helper'

def e(value)
  return Regexp.escape(value.is_a?(String) ? value : value.to_s)
end

describe 'role mariadb' do
  property['mariadb_packages'].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
  describe package('MySQL-python') do
    it { should be_installed }
  end
  describe service('mariadb') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(3306) do
    it { should be_listening }
  end
end
