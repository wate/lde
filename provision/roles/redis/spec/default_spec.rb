require 'spec_helper'

describe package('redis') do
  it { should be_installed }
end

describe file('/etc/redis.conf') do
  it { should exist }
  it { should be_file }
  redis_cfg = property['redis_cfg']
  its(:content) { should match(/^bind #{redis_cfg['bind']}/) }
  protected_mode = redis_cfg['protected_mode'] ? 'yes' : 'no'
  its(:content) { should match(/^protected-mode #{protected_mode}/) }
  its(:content) { should match(/^port #{redis_cfg['port']}/) }
  its(:content) { should match(/^tcp-backlog #{redis_cfg['tcp_backlog']}/) }
  its(:content) { should match(/^unixsocket #{redis_cfg['unixsocket']}/) } if redis_cfg['unixsocket']
  its(:content) { should match(/^unixsocketperm #{redis_cfg['unixsocketperm']}/) } if redis_cfg['unixsocketperm']
  its(:content) { should match(/^timeout #{redis_cfg['timeout']}/) }
  its(:content) { should match(/^tcp-keepalive #{redis_cfg['tcp_keepalive']}/) }
  its(:content) { should match(/^daemonize #{redis_cfg['daemonize'] ? 'yes' : 'no'}/) }
  its(:content) { should match(/^supervised #{redis_cfg['supervised']}/) }
  its(:content) { should match(/^pidfile #{redis_cfg['pidfile']}/) }
  its(:content) { should match(/^loglevel #{redis_cfg['loglevel']}/) }
  its(:content) { should match(/^logfile #{redis_cfg['logfile']}/) }
  if redis_cfg.key?('syslog_enabled')
    syslog_enabled = redis_cfg['syslog_enabled'] ? 'yes' : 'no'
    its(:content) { should match(/^syslog-enabled #{syslog_enabled}/) }
  end
  its(:content) { should match(/^syslog-ident #{redis_cfg['syslog_ident']}/) } if redis_cfg.key?('syslog_ident')
  if redis_cfg.key?('syslog_facility')
    its(:content) { should match(/^syslog-facility #{redis_cfg['syslog_facility']}/) }
  end
  its(:content) { should match(/^databases #{redis_cfg['databases']}/) }
  redis_cfg['save'].each do |save|
    its(:content) { should match(/^save #{save['seconds']} #{save['changes']}/) }
  end
  stop_writes_on_bgsave_error = redis_cfg['stop_writes_on_bgsave_error'] ? 'yes' : 'no'
  its(:content) { should match(/^stop-writes-on-bgsave-error #{stop_writes_on_bgsave_error}/) }
  rdbcompression = redis_cfg['rdbcompression'] ? 'yes' : 'no'
  its(:content) { should match(/^rdbcompression #{rdbcompression}/) }
  rdbchecksum = redis_cfg['rdbchecksum'] ? 'yes' : 'no'
  its(:content) { should match(/^rdbchecksum #{rdbchecksum}/) }
  its(:content) { should match(/^dbfilename #{redis_cfg['dbfilename']}/) }
  its(:content) { should match(/^dir #{redis_cfg['dir']}/) }
  if redis_cfg['slaveof']
    its(:content) { should match(/^slaveof #{redis_cfg['slaveof']['ipaddr']} #{redis_cfg['slaveof']['port']}/) }
  end

  its(:content) { should match(/^masterauth #{redis_cfg['masterauth']}/) } if redis_cfg['masterauth']
  slave_serve_stale_data = redis_cfg['slave_serve_stale_data'] ? 'yes' : 'no'
  its(:content) { should match(/^slave-serve-stale-data #{slave_serve_stale_data}/) }
  slave_read_only = redis_cfg['slave_read_only'] ? 'yes' : 'no'
  its(:content) { should match(/^slave-read-only #{slave_read_only}/) }
  repl_diskless_sync = redis_cfg['repl_diskless_sync'] ? 'yes' : 'no'
  its(:content) { should match(/^repl-diskless-sync #{repl_diskless_sync}/) }
  its(:content) { should match(/^repl-diskless-sync-delay #{redis_cfg['repl_diskless_sync_delay']}/) }
  if redis_cfg['repl_ping_slave_period']
    its(:content) { should match(/^repl-ping-slave-period #{redis_cfg['repl_ping_slave_period']}/) }
  end

  its(:content) { should match(/^repl-timeout #{redis_cfg['repl_timeout']}/) } if redis_cfg['repl_timeout']
  repl_disable_tcp_nodelay = redis_cfg['repl_disable_tcp_nodelay'] ? 'yes' : 'no'
  its(:content) { should match(/^repl-disable-tcp-nodelay #{repl_disable_tcp_nodelay}/) }
  if redis_cfg['repl_backlog_size']
    its(:content) { should match(/^repl-backlog-size #{redis_cfg['repl_backlog_size']}/) }
  end
  its(:content) { should match(/^repl-backlog-ttl #{redis_cfg['repl_backlog_ttl']}/) } if redis_cfg['repl_backlog_ttl']
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
  its(:content) { should match(/^maxclients #{redis_cfg['maxclients']}/) } if redis_cfg['maxclients']
  its(:content) { should match(/^maxmemory #{redis_cfg['maxmemory']}/) } if redis_cfg['maxmemory']
  its(:content) { should match(/^maxmemory-policy #{redis_cfg['maxmemory_policy']}/) } if redis_cfg['maxmemory_policy']
  if redis_cfg['maxmemory_samples']
    its(:content) { should match(/^maxmemory-samples #{redis_cfg['maxmemory_samples']}/) }
  end
  appendonly = redis_cfg['appendonly'] ? 'yes' : 'no'
  its(:content) { should match(/^appendonly #{appendonly}/) }
  its(:content) { should match(/^appendfilename "#{redis_cfg['appendfilename']}"/) }
  its(:content) { should match(/^appendfsync #{redis_cfg['appendfsync']}/) }
  no_appendfsync_on_rewrite = redis_cfg['no_appendfsync_on_rewrite'] ? 'yes' : 'no'
  its(:content) { should match(/^no-appendfsync-on-rewrite #{no_appendfsync_on_rewrite}/) }
  its(:content) { should match(/^auto-aof-rewrite-percentage #{redis_cfg['auto_aof_rewrite_percentage']}/) }
  its(:content) { should match(/^auto-aof-rewrite-min-size #{redis_cfg['auto_aof_rewrite_min_size']}/) }
  aof_load_truncated = redis_cfg['aof_load_truncated'] ? 'yes' : 'no'
  its(:content) { should match(/^aof-load-truncated #{aof_load_truncated}/) }
  its(:content) { should match(/^lua-time-limit #{redis_cfg['lua_time_limit']}/) }
  if redis_cfg.key?('cluster_enabled')
    cluster_enabled = redis_cfg['cluster_enabled'] ? 'yes' : 'no'
    its(:content) { should match(/^cluster-enabled #{cluster_enabled}/) }
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
    cluster_require_full_coverage = redis_cfg['cluster_require_full_coverage'] ? 'yes' : 'no'
    its(:content) { should match(/^cluster-require-full-coverage #{cluster_require_full_coverage}/) }
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
  activerehashing = redis_cfg['activerehashing'] ? 'yes' : 'no'
  its(:content) { should match(/^activerehashing #{activerehashing}/) }
  redis_cfg['client_output_buffer_limit'].each do |limit|
    buffer_limit_value = [
      limit['class'],
      limit['hard_limit'],
      limit['soft_limit'],
      limit['soft_seconds']
    ].join(' ')
    its(:content) { should match(/^client-output-buffer-limit #{buffer_limit_value}/) }
  end
  its(:content) { should match(/^hz #{redis_cfg['hz']}/) }
  aof_rewrite_incremental_fsync = redis_cfg['aof_rewrite_incremental_fsync'] ? 'yes' : 'no'
  its(:content) { should match(/^aof-rewrite-incremental-fsync #{aof_rewrite_incremental_fsync}/) }
end

describe service('redis') do
  it { should be_enabled }
  it { should be_running }
end

describe port(property['redis_cfg']['port']) do
  it { should be_listening }
end
