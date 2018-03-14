require 'spec_helper'

describe file('/etc/my.cnf.d/custom.cnf') do
  it { should exist }
  it { should be_file }
  mariadb_cfg = property['mariadb_cfg']

  its(:content) { should match(/^default-character-set = #{e(property['mariadb_default_charset'])}$/) }

  its(:content) { should match(/^character-set-server = #{e(property['mariadb_default_charset'])}$/) }
  its(:content) { should match(/^collation-server = #{e(property['mariadb_default_collation'])}$/) }
  sql_mode_value = mariadb_cfg['mysqld']['sql_mode']
  if mariadb_cfg['mysqld']['sql_mode'].is_a?(Array)
    sql_mode_value = mariadb_cfg['mysqld']['sql_mode'].join(',')
  end
  its(:content) { should match(/^sql_mode = "#{e(sql_mode_value)}"$/) }
  if mariadb_cfg['mysqld'].key?('datadir')
    its(:content) { should match(/^datadir = #{e(mariadb_cfg['mysqld']['datadir'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('socket')
    its(:content) { should match(/^socket = #{e(mariadb_cfg['mysqld']['socket'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('innodb_data_home_dir')
    its(:content) { should match(/^innodb_data_home_dir = #{e(mariadb_cfg['mysqld']['innodb_data_home_dir'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('innodb_data_file_path')
    its(:content) { should match(/^innodb_data_file_path = #{e(mariadb_cfg['mysqld']['innodb_data_file_path'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('max_connections')
    its(:content) { should match(/^max_connections = #{e(mariadb_cfg['mysqld']['max_connections'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('connect_timeout')
    its(:content) { should match(/^connect_timeout = #{e(mariadb_cfg['mysqld']['connect_timeout'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('max_allowed_packet')
    its(:content) { should match(/^max_allowed_packet = #{e(mariadb_cfg['mysqld']['max_allowed_packet'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('skip_name_resolve') && mariadb_cfg['mysqld']['skip_name_resolve']
    its(:content) { should match(/^skip_name_resolve$/) }
  end
  if mariadb_cfg['mysqld'].key?('interactive_timeout')
    its(:content) { should match(/^interactive_timeout = #{e(mariadb_cfg['mysqld']['interactive_timeout'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('wait_timeout')
    its(:content) { should match(/^wait_timeout = #{e(mariadb_cfg['mysqld']['wait_timeout'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('table_open_cache')
    its(:content) { should match(/^table_open_cache = #{e(mariadb_cfg['mysqld']['table_open_cache'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('thread_cache_size')
    its(:content) { should match(/^thread_cache_size = #{e(mariadb_cfg['mysqld']['thread_cache_size'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('table_definition_cache')
    its(:content) { should match(/^table_definition_cache = #{e(mariadb_cfg['mysqld']['table_definition_cache'])}$/) }
  end
  its(:content) { should match(/^query_cache_limit = #{e(mariadb_cfg['mysqld']['query_cache_limit'])}$/) }
  its(:content) { should match(/^query_cache_size = #{e(mariadb_cfg['mysqld']['query_cache_size'])}$/) }
  its(:content) { should match(/^query_cache_type = #{e(mariadb_cfg['mysqld']['query_cache_type'])}$/) }
  its(:content) { should match(/^innodb_buffer_pool_size = #{e(mariadb_cfg['mysqld']['innodb_buffer_pool_size'])}$/) }
  its(:content) { should match(/^innodb_log_buffer_size = #{e(mariadb_cfg['mysqld']['innodb_log_buffer_size'])}$/) }
  its(:content) { should match(/^key_buffer_size = #{e(mariadb_cfg['mysqld']['key_buffer_size'])}$/) }
  if mariadb_cfg['mysqld'].key?('innodb_flush_log_at_trx_commit')
    its(:content) { should match(/^innodb_flush_log_at_trx_commit = #{e(mariadb_cfg['mysqld']['innodb_flush_log_at_trx_commit'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('join_buffer_size')
    its(:content) { should match(/^join_buffer_size = #{e(mariadb_cfg['mysqld']['join_buffer_size'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('read_buffer_size')
    its(:content) { should match(/^read_buffer_size = #{e(mariadb_cfg['mysqld']['read_buffer_size'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('read_rnd_buffer_size')
    its(:content) { should match(/^read_rnd_buffer_size = #{e(mariadb_cfg['mysqld']['read_rnd_buffer_size'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('sort_buffer_size')
    its(:content) { should match(/^sort_buffer_size = #{e(mariadb_cfg['mysqld']['sort_buffer_size'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('myisam_sort_buffer_size')
    its(:content) { should match(/^myisam_sort_buffer_size = #{e(mariadb_cfg['mysqld']['myisam_sort_buffer_size'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('max_heap_table_size')
    its(:content) { should match(/^max_heap_table_size = #{e(mariadb_cfg['mysqld']['max_heap_table_size'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('tmp_table_size')
    its(:content) { should match(/^tmp_table_size = #{e(mariadb_cfg['mysqld']['tmp_table_size'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('tmp_table_size')
    its(:content) { should match(/^tmp_table_size = #{e(mariadb_cfg['mysqld']['tmp_table_size'])}$/) }
  end
  if mariadb_cfg['mysqld'].key?('slow_query_log')
    slow_query_log_value = mariadb_cfg['mysqld']['slow_query_log'] ? '1' : '0'
    if mariadb_cfg['mysqld']['slow_query_log'].is_a?(Integer) && mariadb_cfg['mysqld']['slow_query_log'] == 0
      slow_query_log_value = '0'
    end
    its(:content) { should match(/^slow_query_log = #{slow_query_log_value}$/) }
  end
  if mariadb_cfg['mysqld'].key?('log_warnings')
    its(:content) { should match(/^log_warnings = #{mariadb_cfg['mysqld']['log_warnings']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('long_query_time')
    its(:content) { should match(/^long_query_time = #{mariadb_cfg['mysqld']['long_query_time']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('slow_query_log_file')
    its(:content) { should match(/^slow_query_log_file = #{mariadb_cfg['mysqld']['slow_query_log_file']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('general_log')
    slow_query_log_value = mariadb_cfg['mysqld']['general_log'] ? '1' : '0'
    if mariadb_cfg['mysqld']['general_log'].is_a?(Integer) && mariadb_cfg['mysqld']['general_log'] == 0
      slow_query_log_value = '0'
    end
    its(:content) { should match(/^general_log = #{mariadb_cfg['mysqld']['general_log']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('general_log_file')
    its(:content) { should match(/^general_log_file = #{mariadb_cfg['mysqld']['general_log_file']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('gtid_domain_id')
    its(:content) { should match(/^gtid_domain_id = #{mariadb_cfg['mysqld']['gtid_domain_id']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('server_id')
    its(:content) { should match(/^server_id = #{mariadb_cfg['mysqld']['server_id']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('log_bin')
    its(:content) { should match(/^log_bin = #{mariadb_cfg['mysqld']['log_bin']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('binlog_format')
    its(:content) { should match(/^binlog_format = #{mariadb_cfg['mysqld']['binlog_format']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('expire_logs_days')
    its(:content) { should match(/^expire_logs_days = #{mariadb_cfg['mysqld']['expire_logs_days']}$/) }
  end
  if mariadb_cfg['mysqld'].key?('read_only') && mariadb_cfg['mysqld']['read_only']
    its(:content) { should match(/^read_only$/) }
  end
  if mariadb_cfg['mysqld'].key?('log_slave_updates') && mariadb_cfg['mysqld']['log_slave_updates']
    its(:content) { should match(/^log_slave_updates$/) }
  end
end

describe file('/root/.my.cnf') do
  it { should exist }
  it { should be_file }
  its(:content) { should match(/^user = root$/) }
  its(:content) { should match(/^password = #{property['mariadb_root_password']}$/) }
end
