require 'spec_helper'

%w{mariadb mariadb-server}.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe service('mariadb') do
  it { should be_enabled }
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end
