require 'spec_helper'

def e(value)
  return Regexp.escape(value.is_a?(String) ? value : value.to_s)
end

describe 'role mysql' do
  describe file('/etc/my.cnf.d/client.cnf') do
    it { should exist }
    it { should be_file }
    its(:content) { should match /^default-character-set = #{e(property['mysql_default_charset'])}$/ }
  end
  describe file('/etc/my.cnf.d/mysql.cnf') do
    it { should exist }
    it { should be_file }
    its(:content) { should match /^default-character-set = #{e(property['mysql_default_charset'])}$/ }
  end
  describe file('/etc/my.cnf.d/mysqld.cnf') do
    it { should exist }
    it { should be_file }
    its(:content) { should match /^character-set-server = #{e(property['mysql_default_charset'])}$/ }
    its(:content) { should match /^collation-server = #{e(property['mysql_default_collation'])}$/ }
    sql_mode_value = property['mysql_cfg']['mysqld']['sql_mode']
    if property['mysql_cfg']['mysqld']['sql_mode'].is_a?(Array)
      sql_mode_value = property['mysql_cfg']['mysqld']['sql_mode'].join(',')
    end
    its(:content) { should match /^sql_mode = "#{e(sql_mode_value)}"$/ }
    if property['mysql_cfg']['mysqld'].has_key?('datadir')
      its(:content) { should match /^datadir = #{e(property['mysql_cfg']['mysqld']['datadir'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('socket')
      its(:content) { should match /^socket = #{e(property['mysql_cfg']['mysqld']['socket'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('innodb_data_home_dir')
      its(:content) { should match /^innodb_data_home_dir = #{e(property['mysql_cfg']['mysqld']['innodb_data_home_dir'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('innodb_data_file_path')
      its(:content) { should match /^innodb_data_file_path = #{e(property['mysql_cfg']['mysqld']['innodb_data_file_path'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('max_connections')
      its(:content) { should match /^max_connections = #{e(property['mysql_cfg']['mysqld']['max_connections'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('connect_timeout')
      its(:content) { should match /^connect_timeout = #{e(property['mysql_cfg']['mysqld']['connect_timeout'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('max_allowed_packet')
      its(:content) { should match /^max_allowed_packet = #{e(property['mysql_cfg']['mysqld']['max_allowed_packet'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('skip_name_resolve') and property['mysql_cfg']['mysqld']['skip_name_resolve']
      its(:content) { should match /^skip_name_resolve$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('interactive_timeout')
      its(:content) { should match /^interactive_timeout = #{e(property['mysql_cfg']['mysqld']['interactive_timeout'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('wait_timeout')
      its(:content) { should match /^wait_timeout = #{e(property['mysql_cfg']['mysqld']['wait_timeout'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('table_open_cache')
      its(:content) { should match /^table_open_cache = #{e(property['mysql_cfg']['mysqld']['table_open_cache'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('thread_cache_size')
      its(:content) { should match /^thread_cache_size = #{e(property['mysql_cfg']['mysqld']['thread_cache_size'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('table_definition_cache')
      its(:content) { should match /^table_definition_cache = #{e(property['mysql_cfg']['mysqld']['table_definition_cache'])}$/ }
    end
    its(:content) { should match /^query_cache_limit = #{e(property['mysql_cfg']['mysqld']['query_cache_limit'])}$/ }
    its(:content) { should match /^query_cache_size = #{e(property['mysql_cfg']['mysqld']['query_cache_size'])}$/ }
    its(:content) { should match /^query_cache_type = #{e(property['mysql_cfg']['mysqld']['query_cache_type'])}$/ }
    its(:content) { should match /^innodb_buffer_pool_size = #{e(property['mysql_cfg']['mysqld']['innodb_buffer_pool_size'])}$/ }
    its(:content) { should match /^innodb_log_buffer_size = #{e(property['mysql_cfg']['mysqld']['innodb_log_buffer_size'])}$/ }
    its(:content) { should match /^key_buffer_size = #{e(property['mysql_cfg']['mysqld']['key_buffer_size'])}$/ }
    if property['mysql_cfg']['mysqld'].has_key?('innodb_flush_log_at_trx_commit')
      its(:content) { should match /^innodb_flush_log_at_trx_commit = #{e(property['mysql_cfg']['mysqld']['innodb_flush_log_at_trx_commit'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('join_buffer_size')
      its(:content) { should match /^join_buffer_size = #{e(property['mysql_cfg']['mysqld']['join_buffer_size'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('read_buffer_size')
      its(:content) { should match /^read_buffer_size = #{e(property['mysql_cfg']['mysqld']['read_buffer_size'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('read_rnd_buffer_size')
      its(:content) { should match /^read_rnd_buffer_size = #{e(property['mysql_cfg']['mysqld']['read_rnd_buffer_size'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('sort_buffer_size')
      its(:content) { should match /^sort_buffer_size = #{e(property['mysql_cfg']['mysqld']['sort_buffer_size'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('myisam_sort_buffer_size')
      its(:content) { should match /^myisam_sort_buffer_size = #{e(property['mysql_cfg']['mysqld']['myisam_sort_buffer_size'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('max_heap_table_size')
      its(:content) { should match /^max_heap_table_size = #{e(property['mysql_cfg']['mysqld']['max_heap_table_size'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('tmp_table_size')
      its(:content) { should match /^tmp_table_size = #{e(property['mysql_cfg']['mysqld']['tmp_table_size'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('tmp_table_size')
      its(:content) { should match /^tmp_table_size = #{e(property['mysql_cfg']['mysqld']['tmp_table_size'])}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('slow_query_log')
      slow_query_log_value = property['mysql_cfg']['mysqld']['slow_query_log'] ? '1' : '0'
      if property['mysql_cfg']['mysqld']['slow_query_log'].is_a?(Integer) && property['mysql_cfg']['mysqld']['slow_query_log'] == 0
        slow_query_log_value = '0'
      end
      its(:content) { should match /^slow_query_log = #{slow_query_log_value}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('log_warnings')
      its(:content) { should match /^log_warnings = #{property['mysql_cfg']['mysqld']['log_warnings']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('long_query_time')
      its(:content) { should match /^long_query_time = #{property['mysql_cfg']['mysqld']['long_query_time']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('slow_query_log_file')
      its(:content) { should match /^slow_query_log_file = #{property['mysql_cfg']['mysqld']['slow_query_log_file']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('general_log')
      slow_query_log_value = property['mysql_cfg']['mysqld']['general_log'] ? '1' : '0'
      if property['mysql_cfg']['mysqld']['general_log'].is_a?(Integer) && property['mysql_cfg']['mysqld']['general_log'] == 0
        slow_query_log_value = '0'
      end
      its(:content) { should match /^general_log = #{property['mysql_cfg']['mysqld']['general_log']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('general_log_file')
      its(:content) { should match /^general_log_file = #{property['mysql_cfg']['mysqld']['general_log_file']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('gtid_domain_id')
      its(:content) { should match /^gtid_domain_id = #{property['mysql_cfg']['mysqld']['gtid_domain_id']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('server_id')
      its(:content) { should match /^server_id = #{property['mysql_cfg']['mysqld']['server_id']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('log_bin')
      its(:content) { should match /^log_bin = #{property['mysql_cfg']['mysqld']['log_bin']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('binlog_format')
      its(:content) { should match /^binlog_format = #{property['mysql_cfg']['mysqld']['binlog_format']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('expire_logs_days')
      its(:content) { should match /^expire_logs_days = #{property['mysql_cfg']['mysqld']['expire_logs_days']}$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('read_only') && property['mysql_cfg']['mysqld']['read_only']
      its(:content) { should match /^read_only$/ }
    end
    if property['mysql_cfg']['mysqld'].has_key?('log_slave_updates') && property['mysql_cfg']['mysqld']['log_slave_updates']
      its(:content) { should match /^log_slave_updates$/ }
    end
  end
  describe file('/root/.my.cnf') do
    it { should exist }
    it { should be_file }
    its(:content) { should match /^user = root$/ }
    its(:content) { should match /^password = #{property['mysql_root_password']}$/ }
  end
end
