require 'spec_helper'

describe "redis" do
  describe package('redis') do
    it { should be_installed }
  end
  context 'Configration' do
    describe file('/etc/redis.conf') do
      it { should exist }
      it { should be_file }
      its(:content) { should match /^bind #{property['redis_cfg']['bind']}/ }
      its(:content) { should match /^protected-mode #{property['redis_cfg']['protected_mode'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^port #{property['redis_cfg']['port']}/ }
      its(:content) { should match /^tcp-backlog #{property['redis_cfg']['tcp_backlog']}/ }
      if property['redis_cfg']['unixsocket']
        its(:content) { should match /^unixsocket #{property['redis_cfg']['unixsocket']}/ }
      end
      if property['redis_cfg']['unixsocketperm']
        its(:content) { should match /^unixsocketperm #{property['redis_cfg']['unixsocketperm']}/ }
      end
      its(:content) { should match /^timeout #{property['redis_cfg']['timeout']}/ }
      its(:content) { should match /^tcp-keepalive #{property['redis_cfg']['tcp_keepalive']}/ }
      its(:content) { should match /^daemonize #{property['redis_cfg']['daemonize'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^supervised #{property['redis_cfg']['supervised']}/ }
      its(:content) { should match /^pidfile #{property['redis_cfg']['pidfile']}/ }
      its(:content) { should match /^loglevel #{property['redis_cfg']['loglevel']}/ }
      its(:content) { should match /^logfile #{property['redis_cfg']['logfile']}/ }
      if property['redis_cfg'].has_key?('syslog_enabled')
          its(:content) { should match /^syslog-enabled #{property['redis_cfg']['syslog_enabled'] ? 'yes' : 'no'}/ }
      end
      if property['redis_cfg'].has_key?('syslog_ident')
        its(:content) { should match /^syslog-ident #{property['redis_cfg']['syslog_ident']}/ }
      end
      if property['redis_cfg'].has_key?('syslog_facility')
        its(:content) { should match /^syslog-facility #{property['redis_cfg']['syslog_facility']}/ }
      end
      its(:content) { should match /^databases #{property['redis_cfg']['databases']}/ }
      property['redis_cfg']['save'].each do |save|
        its(:content) { should match /^save #{save['seconds']} #{save['changes']}/ }
      end
      its(:content) { should match /^stop-writes-on-bgsave-error #{property['redis_cfg']['stop_writes_on_bgsave_error'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^rdbcompression #{property['redis_cfg']['rdbcompression'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^rdbchecksum #{property['redis_cfg']['rdbchecksum'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^dbfilename #{property['redis_cfg']['dbfilename']}/ }
      its(:content) { should match /^dir #{property['redis_cfg']['dir']}/ }
      if property['redis_cfg']['slaveof']
        its(:content) { should match /^slaveof #{property['redis_cfg']['slaveof']['ipaddr']} #{property['redis_cfg']['slaveof']['port']}/ }
      end
      if property['redis_cfg']['masterauth']
        its(:content) { should match /^masterauth #{property['redis_cfg']['masterauth']}/ }
      end
      its(:content) { should match /^slave-serve-stale-data #{property['redis_cfg']['slave_serve_stale_data'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^slave-read-only #{property['redis_cfg']['slave_read_only'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^repl-diskless-sync #{property['redis_cfg']['repl_diskless_sync'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^repl-diskless-sync-delay #{property['redis_cfg']['repl_diskless_sync_delay']}/ }
      if property['redis_cfg']['repl_ping_slave_period']
        its(:content) { should match /^repl-ping-slave-period #{property['redis_cfg']['repl_ping_slave_period']}/ }
      end
      if property['redis_cfg']['repl_timeout']
        its(:content) { should match /^repl-timeout #{property['redis_cfg']['repl_timeout']}/ }
      end
      its(:content) { should match /^repl-disable-tcp-nodelay #{property['redis_cfg']['repl_disable_tcp_nodelay'] ? 'yes' : 'no'}/ }
      if property['redis_cfg']['repl_backlog_size']
        its(:content) { should match /^repl-backlog-size #{property['redis_cfg']['repl_backlog_size']}/ }
      end
      if property['redis_cfg']['repl_backlog_ttl']
        its(:content) { should match /^repl-backlog-ttl #{property['redis_cfg']['repl_backlog_ttl']}/ }
      end
      its(:content) { should match /^slave-priority #{property['redis_cfg']['slave_priority']}/ }
      if property['redis_cfg']['min_slaves_to_write']
        its(:content) { should match /^min-slaves-to-write #{property['redis_cfg']['min_slaves_to_write']}/ }
      end
      if property['redis_cfg']['min_slaves_max_lag']
        its(:content) { should match /^min-slaves-max-lag #{property['redis_cfg']['min_slaves_max_lag']}/ }
      end
      if property['redis_cfg']['slave_announce_ip']
        its(:content) { should match /^slave-announce-ip #{property['redis_cfg']['slave_announce_ip']}/ }
      end
      if property['redis_cfg']['slave_announce_port']
        its(:content) { should match /^slave-announce-port #{property['redis_cfg']['slave_announce_port']}/ }
      end
      if property['redis_cfg']['maxclients']
        its(:content) { should match /^maxclients #{property['redis_cfg']['maxclients']}/ }
      end
      if property['redis_cfg']['maxmemory']
        its(:content) { should match /^maxmemory #{property['redis_cfg']['maxmemory']}/ }
      end
      if property['redis_cfg']['maxmemory_policy']
        its(:content) { should match /^maxmemory-policy #{property['redis_cfg']['maxmemory_policy']}/ }
      end
      if property['redis_cfg']['maxmemory_samples']
        its(:content) { should match /^maxmemory-samples #{property['redis_cfg']['maxmemory_samples']}/ }
      end
      its(:content) { should match /^appendonly #{property['redis_cfg']['appendonly'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^appendfilename "#{property['redis_cfg']['appendfilename']}"/ }
      its(:content) { should match /^appendfsync #{property['redis_cfg']['appendfsync']}/ }
      its(:content) { should match /^no-appendfsync-on-rewrite #{property['redis_cfg']['no_appendfsync_on_rewrite'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^auto-aof-rewrite-percentage #{property['redis_cfg']['auto_aof_rewrite_percentage']}/ }
      its(:content) { should match /^auto-aof-rewrite-min-size #{property['redis_cfg']['auto_aof_rewrite_min_size']}/ }
      its(:content) { should match /^aof-load-truncated #{property['redis_cfg']['aof_load_truncated'] ? 'yes' : 'no'}/ }
      its(:content) { should match /^lua-time-limit #{property['redis_cfg']['lua_time_limit']}/ }
      if property['redis_cfg'].has_key?('cluster_enabled')
        its(:content) { should match /^cluster-enabled #{property['redis_cfg']['cluster_enabled'] ? 'yes' : 'no'}/ }
      end

      if property['redis_cfg']['cluster_config_file']
        its(:content) { should match /^cluster-config-file #{property['redis_cfg']['cluster_config_file']}/ }
      end
      if property['redis_cfg']['cluster_node_timeout']
        its(:content) { should match /^cluster-node-timeout #{property['redis_cfg']['cluster_node_timeout']}/ }
      end
      if property['redis_cfg']['cluster_slave_validity_factor']
        its(:content) { should match /^cluster-slave-validity-factor #{property['redis_cfg']['cluster_slave_validity_factor']}/ }
      end
      if property['redis_cfg']['cluster_migration_barrier']
        its(:content) { should match /^cluster-migration-barrier #{property['redis_cfg']['cluster_migration_barrier']}/ }
      end
      if property['redis_cfg'].has_key?('cluster_require_full_coverage')
        its(:content) { should match /^cluster-require-full-coverage #{property['redis_cfg']['cluster_require_full_coverage'] ? 'yes' : 'no'}/ }
      end
      its(:content) { should match /^slowlog-log-slower-than #{property['redis_cfg']['slowlog_log_slower_than']}/ }
      its(:content) { should match /^slowlog-max-len #{property['redis_cfg']['slowlog_max_len']}/ }
      its(:content) { should match /^latency-monitor-threshold #{property['redis_cfg']['latency_monitor_threshold']}/ }
      its(:content) { should match /^notify-keyspace-events "#{property['redis_cfg']['notify_keyspace_events']}"/ }
      its(:content) { should match /^hash-max-ziplist-entries #{property['redis_cfg']['hash_max_ziplist_entries']}/ }
      its(:content) { should match /^hash-max-ziplist-value #{property['redis_cfg']['hash_max_ziplist_value']}/ }
      its(:content) { should match /^list-max-ziplist-size #{property['redis_cfg']['list_max_ziplist_size']}/ }
      its(:content) { should match /^list-compress-depth #{property['redis_cfg']['list_compress_depth']}/ }
      its(:content) { should match /^set-max-intset-entries #{property['redis_cfg']['set_max_intset_entries']}/ }
      its(:content) { should match /^zset-max-ziplist-entries #{property['redis_cfg']['zset_max_ziplist_entries']}/ }
      its(:content) { should match /^zset-max-ziplist-value #{property['redis_cfg']['zset_max_ziplist_value']}/ }
      its(:content) { should match /^hll-sparse-max-bytes #{property['redis_cfg']['hll_sparse_max_bytes']}/ }
      its(:content) { should match /^activerehashing #{property['redis_cfg']['activerehashing'] ? 'yes' : 'no'}/ }
      property['redis_cfg']['client_output_buffer_limit'].each do |buffer_limit|
        its(:content) { should match /^client-output-buffer-limit #{buffer_limit['class']} #{buffer_limit['hard_limit']} #{buffer_limit['soft_limit']} #{buffer_limit['soft_seconds']}/ }
      end
      its(:content) { should match /^hz #{property['redis_cfg']['hz']}/ }
      its(:content) { should match /^aof-rewrite-incremental-fsync #{property['redis_cfg']['aof_rewrite_incremental_fsync'] ? 'yes' : 'no'}/ }
    end
  end
  describe service('redis') do
    it { should be_enabled }
    it { should be_running }
  end
  describe port(property['redis_cfg']['port']) do
    it { should be_listening }
  end
end
