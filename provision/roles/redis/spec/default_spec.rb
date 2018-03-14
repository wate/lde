require 'spec_helper'

describe package('redis') do
  it { should be_installed }
end

describe file('/etc/redis.conf') do
  it { should exist }
  it { should be_file }
  redis_cfg = property['redis_cfg']
  its(:content) { should match(/^bind #{redis_cfg['bind']}/) }
  its(:content) { should match(/^protected-mode #{redis_cfg['protected_mode'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^port #{redis_cfg['port']}/) }
  its(:content) { should match(/^tcp-backlog #{redis_cfg['tcp_backlog']}/) }
  if redis_cfg['unixsocket']
    its(:content) { should match(/^unixsocket #{redis_cfg['unixsocket']}/) }
  end
  if redis_cfg['unixsocketperm']
    its(:content) { should match(/^unixsocketperm #{redis_cfg['unixsocketperm']}/) }
  end
  its(:content) { should match(/^timeout #{redis_cfg['timeout']}/) }
  its(:content) { should match(/^tcp-keepalive #{redis_cfg['tcp_keepalive']}/) }
  its(:content) { should match(/^daemonize #{redis_cfg['daemonize'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^supervised #{redis_cfg['supervised']}/) }
  its(:content) { should match(/^pidfile #{redis_cfg['pidfile']}/) }
  its(:content) { should match(/^loglevel #{redis_cfg['loglevel']}/) }
  its(:content) { should match(/^logfile #{redis_cfg['logfile']}/) }
  if redis_cfg.key?('syslog_enabled')
    its(:content) { should match(/^syslog-enabled #{redis_cfg['syslog_enabled'] ? 'yes' : 'no'}/) }
  end
  if redis_cfg.key?('syslog_ident')
    its(:content) { should match(/^syslog-ident #{redis_cfg['syslog_ident']}/) }
  end
  if redis_cfg.key?('syslog_facility')
    its(:content) { should match(/^syslog-facility #{redis_cfg['syslog_facility']}/) }
  end
  its(:content) { should match(/^databases #{redis_cfg['databases']}/) }
  redis_cfg['save'].each do |save|
    its(:content) { should match(/^save #{save['seconds']} #{save['changes']}/) }
  end
  its(:content) { should match(/^stop-writes-on-bgsave-error #{redis_cfg['stop_writes_on_bgsave_error'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^rdbcompression #{redis_cfg['rdbcompression'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^rdbchecksum #{redis_cfg['rdbchecksum'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^dbfilename #{redis_cfg['dbfilename']}/) }
  its(:content) { should match(/^dir #{redis_cfg['dir']}/) }
  if redis_cfg['slaveof']
    its(:content) { should match(/^slaveof #{redis_cfg['slaveof']['ipaddr']} #{redis_cfg['slaveof']['port']}/) }
  end
  if redis_cfg['masterauth']
    its(:content) { should match(/^masterauth #{redis_cfg['masterauth']}/) }
  end
  its(:content) { should match(/^slave-serve-stale-data #{redis_cfg['slave_serve_stale_data'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^slave-read-only #{redis_cfg['slave_read_only'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^repl-diskless-sync #{redis_cfg['repl_diskless_sync'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^repl-diskless-sync-delay #{redis_cfg['repl_diskless_sync_delay']}/) }
  if redis_cfg['repl_ping_slave_period']
    its(:content) { should match(/^repl-ping-slave-period #{redis_cfg['repl_ping_slave_period']}/) }
  end
  if redis_cfg['repl_timeout']
    its(:content) { should match(/^repl-timeout #{redis_cfg['repl_timeout']}/) }
  end
  its(:content) { should match(/^repl-disable-tcp-nodelay #{redis_cfg['repl_disable_tcp_nodelay'] ? 'yes' : 'no'}/) }
  if redis_cfg['repl_backlog_size']
    its(:content) { should match(/^repl-backlog-size #{redis_cfg['repl_backlog_size']}/) }
  end
  if redis_cfg['repl_backlog_ttl']
    its(:content) { should match(/^repl-backlog-ttl #{redis_cfg['repl_backlog_ttl']}/) }
  end
  its(:content) { should match(/^slave-priority #{redis_cfg['slave_priority']}/) }
  if redis_cfg['min_slaves_to_write']
    its(:content) { should match(/^min-slaves-to-write #{redis_cfg['min_slaves_to_write']}/) }
  end
  if redis_cfg['min_slaves_max_lag']
    its(:content) { should match(/^min-slaves-max-lag #{redis_cfg['min_slaves_max_lag']}/) }
  end
  if redis_cfg['slave_announce_ip']
    its(:content) { should match(/^slave-announce-ip #{redis_cfg['slave_announce_ip']}/) }
  end
  if redis_cfg['slave_announce_port']
    its(:content) { should match(/^slave-announce-port #{redis_cfg['slave_announce_port']}/) }
  end
  if redis_cfg['maxclients']
    its(:content) { should match(/^maxclients #{redis_cfg['maxclients']}/) }
  end
  if redis_cfg['maxmemory']
    its(:content) { should match(/^maxmemory #{redis_cfg['maxmemory']}/) }
  end
  if redis_cfg['maxmemory_policy']
    its(:content) { should match(/^maxmemory-policy #{redis_cfg['maxmemory_policy']}/) }
  end
  if redis_cfg['maxmemory_samples']
    its(:content) { should match(/^maxmemory-samples #{redis_cfg['maxmemory_samples']}/) }
  end
  its(:content) { should match(/^appendonly #{redis_cfg['appendonly'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^appendfilename "#{redis_cfg['appendfilename']}"/) }
  its(:content) { should match(/^appendfsync #{redis_cfg['appendfsync']}/) }
  its(:content) { should match(/^no-appendfsync-on-rewrite #{redis_cfg['no_appendfsync_on_rewrite'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^auto-aof-rewrite-percentage #{redis_cfg['auto_aof_rewrite_percentage']}/) }
  its(:content) { should match(/^auto-aof-rewrite-min-size #{redis_cfg['auto_aof_rewrite_min_size']}/) }
  its(:content) { should match(/^aof-load-truncated #{redis_cfg['aof_load_truncated'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^lua-time-limit #{redis_cfg['lua_time_limit']}/) }
  if redis_cfg.key?('cluster_enabled')
    its(:content) { should match(/^cluster-enabled #{redis_cfg['cluster_enabled'] ? 'yes' : 'no'}/) }
  end

  if redis_cfg['cluster_config_file']
    its(:content) { should match(/^cluster-config-file #{redis_cfg['cluster_config_file']}/) }
  end
  if redis_cfg['cluster_node_timeout']
    its(:content) { should match(/^cluster-node-timeout #{redis_cfg['cluster_node_timeout']}/) }
  end
  if redis_cfg['cluster_slave_validity_factor']
    its(:content) { should match(/^cluster-slave-validity-factor #{redis_cfg['cluster_slave_validity_factor']}/) }
  end
  if redis_cfg['cluster_migration_barrier']
    its(:content) { should match(/^cluster-migration-barrier #{redis_cfg['cluster_migration_barrier']}/) }
  end
  if redis_cfg.key?('cluster_require_full_coverage')
    its(:content) { should match(/^cluster-require-full-coverage #{redis_cfg['cluster_require_full_coverage'] ? 'yes' : 'no'}/) }
  end
  its(:content) { should match(/^slowlog-log-slower-than #{redis_cfg['slowlog_log_slower_than']}/) }
  its(:content) { should match(/^slowlog-max-len #{redis_cfg['slowlog_max_len']}/) }
  its(:content) { should match(/^latency-monitor-threshold #{redis_cfg['latency_monitor_threshold']}/) }
  its(:content) { should match(/^notify-keyspace-events "#{redis_cfg['notify_keyspace_events']}"/) }
  its(:content) { should match(/^hash-max-ziplist-entries #{redis_cfg['hash_max_ziplist_entries']}/) }
  its(:content) { should match(/^hash-max-ziplist-value #{redis_cfg['hash_max_ziplist_value']}/) }
  its(:content) { should match(/^list-max-ziplist-size #{redis_cfg['list_max_ziplist_size']}/) }
  its(:content) { should match(/^list-compress-depth #{redis_cfg['list_compress_depth']}/) }
  its(:content) { should match(/^set-max-intset-entries #{redis_cfg['set_max_intset_entries']}/) }
  its(:content) { should match(/^zset-max-ziplist-entries #{redis_cfg['zset_max_ziplist_entries']}/) }
  its(:content) { should match(/^zset-max-ziplist-value #{redis_cfg['zset_max_ziplist_value']}/) }
  its(:content) { should match(/^hll-sparse-max-bytes #{redis_cfg['hll_sparse_max_bytes']}/) }
  its(:content) { should match(/^activerehashing #{redis_cfg['activerehashing'] ? 'yes' : 'no'}/) }
  redis_cfg['client_output_buffer_limit'].each do |buffer_limit|
    its(:content) { should match(/^client-output-buffer-limit #{buffer_limit['class']} #{buffer_limit['hard_limit']} #{buffer_limit['soft_limit']} #{buffer_limit['soft_seconds']}/) }
  end
  its(:content) { should match(/^hz #{redis_cfg['hz']}/) }
  its(:content) { should match(/^aof-rewrite-incremental-fsync #{redis_cfg['aof_rewrite_incremental_fsync'] ? 'yes' : 'no'}/) }
end

describe service('redis') do
  it { should be_enabled }
  it { should be_running }
end

describe port(redis_cfg['port']) do
  it { should be_listening }
end
