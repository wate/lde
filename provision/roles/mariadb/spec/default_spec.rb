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
  describe file('/etc/my.cnf.d/client.cnf') do
    it { should exist }
    it { should be_file }
    its(:content) { should match /^default_character_set = #{e(property['mariadb_default_charset'])}/ }
  end
  describe file('/etc/my.cnf.d/mysql.cnf') do
    it { should exist }
    it { should be_file }
    its(:content) { should match /^default_character_set = #{e(property['mariadb_default_charset'])}/ }
  end
  describe file('/etc/my.cnf.d/mysqld.cnf') do
    it { should exist }
    it { should be_file }
    its(:content) { should match /^character_set_server = #{e(property['mariadb_default_charset'])}/ }
    its(:content) { should match /^collation_server = #{e(property['mariadb_default_collation'])}/ }
    its(:content) { should match /^sql_mode = "#{e(property['mariadb_cfg']['mysqld']['sql_mode'])}"/ }
    if property['mariadb_cfg']['mysqld'].has_key?('datadir')
      its(:content) { should match /^datadir = #{e(property['mariadb_cfg']['mysqld']['datadir'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('socket')
      its(:content) { should match /^socket = #{e(property['mariadb_cfg']['mysqld']['socket'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('innodb_data_home_dir')
      its(:content) { should match /^innodb_data_home_dir = #{e(property['mariadb_cfg']['mysqld']['innodb_data_home_dir'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('innodb_data_file_path')
      its(:content) { should match /^innodb_data_file_path = #{e(property['mariadb_cfg']['mysqld']['innodb_data_file_path'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('max_connections')
      its(:content) { should match /^max_connections = #{property['mariadb_cfg']['mysqld']['max_connections']}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('connect_timeout')
      its(:content) { should match /^connect_timeout = #{property['mariadb_cfg']['mysqld']['connect_timeout']}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('max_allowed_packet')
      its(:content) { should match /^max_allowed_packet = #{e(property['mariadb_cfg']['mysqld']['max_allowed_packet'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('skip_name_resolve')
      its(:content) { should match /^skip_name_resolve$/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('interactive_timeout')
      its(:content) { should match /^interactive_timeout = #{property['mariadb_cfg']['mysqld']['interactive_timeout']}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('wait_timeout')
      its(:content) { should match /^wait_timeout = #{property['mariadb_cfg']['mysqld']['wait_timeout']}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('table_open_cache')
      its(:content) { should match /^table_open_cache = #{property['mariadb_cfg']['mysqld']['table_open_cache']}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('thread_cache_size')
      its(:content) { should match /^thread_cache_size = #{e(property['mariadb_cfg']['mysqld']['thread_cache_size'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('table_definition_cache')
      its(:content) { should match /^table_definition_cache = #{e(property['mariadb_cfg']['mysqld']['table_definition_cache'])}/ }
    end
    its(:content) { should match /^query_cache_size = #{e(property['mariadb_cfg']['mysqld']['query_cache_size'])}/ }
    its(:content) { should match /^query_cache_type = #{e(property['mariadb_cfg']['mysqld']['query_cache_type'])}/ }
    its(:content) { should match /^innodb_buffer_pool_size = #{e(property['mariadb_cfg']['mysqld']['innodb_buffer_pool_size'])}/ }
    its(:content) { should match /^innodb_log_buffer_size = #{e(property['mariadb_cfg']['mysqld']['innodb_log_buffer_size'])}/ }
    its(:content) { should match /^key_buffer_size = #{e(property['mariadb_cfg']['mysqld']['key_buffer_size'])}/ }
    if property['mariadb_cfg']['mysqld'].has_key?('innodb_flush_log_at_trx_commit')
      its(:content) { should match /^innodb_flush_log_at_trx_commit = #{e(property['mariadb_cfg']['mysqld']['innodb_flush_log_at_trx_commit'])}/ }
    end

    if property['mariadb_cfg']['mysqld'].has_key?('join_buffer_size')
      its(:content) { should match /^join_buffer_size = #{e(property['mariadb_cfg']['mysqld']['join_buffer_size'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('read_buffer_size')
      its(:content) { should match /^read_buffer_size = #{e(property['mariadb_cfg']['mysqld']['read_buffer_size'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('read_rnd_buffer_size')
      its(:content) { should match /^read_rnd_buffer_size = #{e(property['mariadb_cfg']['mysqld']['read_rnd_buffer_size'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('sort_buffer_size')
      its(:content) { should match /^sort_buffer_size = #{e(property['mariadb_cfg']['mysqld']['sort_buffer_size'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('myisam_sort_buffer_size')
      its(:content) { should match /^myisam_sort_buffer_size = #{e(property['mariadb_cfg']['mysqld']['myisam_sort_buffer_size'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('max_heap_table_size')
      its(:content) { should match /^max_heap_table_size = #{e(property['mariadb_cfg']['mysqld']['max_heap_table_size'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('tmp_table_size')
      its(:content) { should match /^tmp_table_size = #{e(property['mariadb_cfg']['mysqld']['tmp_table_size'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('slow_query_log')
      its(:content) { should match /^slow_query_log = #{e(property['mariadb_cfg']['mysqld']['slow_query_log'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('log_warnings')
      its(:content) { should match /^log_warnings = #{e(property['mariadb_cfg']['mysqld']['log_warnings'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('long_query_time')
      its(:content) { should match /^long_query_time = #{e(property['mariadb_cfg']['mysqld']['long_query_time'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('slow_query_log_file')
      its(:content) { should match /^slow_query_log_file = #{e(property['mariadb_cfg']['mysqld']['slow_query_log_file'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('slow_query_log_file')
      general_log = property['mariadb_cfg']['mysqld']['general_log'] ? 1 : 0
      its(:content) { should match /^general_log = #{general_log}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('general_log_file')
      its(:content) { should match /^general_log_file = #{e(property['mariadb_cfg']['mysqld']['general_log_file'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('gtid_domain_id')
      its(:content) { should match /^gtid_domain_id = #{e(property['mariadb_cfg']['mysqld']['gtid_domain_id'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('server_id')
      its(:content) { should match /^server_id = #{e(property['mariadb_cfg']['mysqld']['server_id'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('log_bin')
      its(:content) { should match /^log_bin = #{e(property['mariadb_cfg']['mysqld']['log_bin'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('binlog_format')
      its(:content) { should match /^log_bin = #{e(property['mariadb_cfg']['mysqld']['binlog_format'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('expire_logs_days')
      its(:content) { should match /^expire_logs_days = #{e(property['mariadb_cfg']['mysqld']['expire_logs_days'])}/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('read_only') and property['mariadb_cfg']['read_only']
      its(:content) { should match /^read_only$/ }
    end
    if property['mariadb_cfg']['mysqld'].has_key?('log_slave_updates') and property['mariadb_cfg']['log_slave_updates']
      its(:content) { should match /^log_slave_updates$/ }
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
  describe port(3306) do
    it { should be_listening }
  end
end
