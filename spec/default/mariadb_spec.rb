require 'spec_helper'

describe 'MariaDB' do

  %w[mariadb mariadb-server mariadb-libs].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe file('/root/.my.cnf') do
    it { should exist }
    it { should be_file }
  end

  describe service('mariadb') do
    it { should be_enabled }
    it { should be_running }
  end
  describe file('/etc/my.cnf.d/custom.cnf') do
    it { should exist }
    it { should be_file }
  end

  describe 'MariaDB config parameters' do
    # sql_mode
    context command('/usr/libexec/mysqld --verbose --help 2> /dev/null | grep \'^sql-mode\' ') do
      sql_mode = [
        'ONLY_FULL_GROUP_BY',
        'STRICT_TRANS_TABLES',
        'NO_ZERO_IN_DATE',
        'NO_ZERO_DATE',
        'ERROR_FOR_DIVISION_BY_ZERO',
        'NO_AUTO_CREATE_USER',
        'NO_ENGINE_SUBSTITUTION'
      ]
      its(:stdout) { should match(/^sql\-mode\s+#{sql_mode.join(',')}/) }
    end
    # character_set_server = utf8
    context command('/usr/libexec/mysqld --verbose --help 2> /dev/null | grep \'^character-set-server\' ') do
      its(:stdout) { should match(/^character-set-server\s+utf8/) }
    end
    # collation_server = utf8_general_ci
    context command('/usr/libexec/mysqld --verbose --help 2> /dev/null | grep \'^collation-server\' ') do
      its(:stdout) { should match(/^collation-server\s+utf8_general_ci/) }
    end
    # slow_query_log = ON
    context command('/usr/libexec/mysqld --verbose --help 2> /dev/null | grep \'^slow-query-log \' ') do
      its(:stdout) { should match(/^slow-query-log\s+TRUE$/) }
    end
    # long_query_time = 1
    context command('/usr/libexec/mysqld --verbose --help 2> /dev/null | grep \'^long-query-time\' ') do
      its(:stdout) { should match(/^long-query-time\s+1$/) }
    end
    # slow_query_log_file = /var/log/mysql/slow_query.log
    context command('/usr/libexec/mysqld --verbose --help 2> /dev/null | grep \'^slow-query-log-file\' ') do
      its(:stdout) { should match(%r{^slow-query-log-file\s+/var/log/mariadb/slow_query.log$}) }
    end
  end

  describe port(3306) do
    it { should be_listening }
  end
end
