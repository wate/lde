require 'spec_helper'

describe file('/etc/php.ini') do
  php_cfg = property['php_cfg']
  # Core
  if php_cfg.key?('user_ini')
    if php_cfg['user_ini'].key?('filename')
      its(:content) { should match(/^user_ini.filename = #{e(php_cfg['user_ini']['filename'])}$/) }
    end
    if php_cfg['user_ini'].key?('cache_ttl')
      its(:content) { should match(/^user_ini.cache_ttl = #{e(php_cfg['user_ini']['cache_ttl'])}$/) }
    end
  end
  its(:content) { should match(/^engine = #{e(php_cfg['engine'])}$/) }
  its(:content) { should match(/^short_open_tag = #{e(php_cfg['short_open_tag'])}$/) }
  if Gem::Version.new(property['php_version'].to_s) < Gem::Version.new('7') && php_cfg.key?('asp_tags')
    its(:content) { should match(/^asp_tags = #{e(php_cfg['asp_tags'])}$/) }
  end
  its(:content) { should match(/^precision = #{e(php_cfg['precision'])}$/) }
  its(:content) { should match(/^output_buffering = #{e(php_cfg['output_buffering'])}$/) }
  if php_cfg.key?('output_handler')
    its(:content) { should match(/^output_handler = #{e(php_cfg['output_handler'])}$/) }
  end
  its(:content) { should match(/^implicit_flush = #{e(php_cfg['implicit_flush'])}$/) }
  its(:content) { should match(/^unserialize_callback_func = #{e(php_cfg['unserialize_callback_func'])}$/) }
  its(:content) { should match(/^serialize_precision = #{e(php_cfg['serialize_precision'])}$/) }
  if php_cfg.key?('open_basedir')
    its(:content) { should match(/^open_basedir = #{e(php_cfg['open_basedir'])}$/) }
  end
  its(:content) { should match(/^disable_functions = #{e(php_cfg['disable_functions'])}$/) }
  its(:content) { should match(/^disable_classes = #{e(php_cfg['disable_classes'])}$/) }
  if php_cfg.key?('ignore_user_abort')
    its(:content) { should match(/^ignore_user_abort = #{e(php_cfg['ignore_user_abort'])}$/) }
  end
  if php_cfg.key?('realpath_cache_size')
    its(:content) { should match(/^realpath_cache_size = #{e(php_cfg['realpath_cache_size'])}$/) }
  end
  if php_cfg.key?('realpath_cache_ttl')
    its(:content) { should match(/^realpath_cache_ttl = #{e(php_cfg['realpath_cache_ttl'])}$/) }
  end
  its(:content) { should match(/^expose_php = #{e(php_cfg['expose_php'])}$/) }
  its(:content) { should match(/^max_execution_time = #{e(php_cfg['max_execution_time'])}$/) }
  its(:content) { should match(/^max_input_time = #{e(php_cfg['max_input_time'])}$/) }
  if php_cfg.key?('max_input_nesting_level')
    its(:content) { should match(/^max_input_nesting_level = #{e(php_cfg['max_input_nesting_level'])}$/) }
  end
  if php_cfg.key?('max_input_vars')
    its(:content) { should match(/^max_input_vars = #{e(php_cfg['max_input_vars'])}$/) }
  end
  its(:content) { should match(/^memory_limit = #{e(php_cfg['memory_limit'])}$/) }
  its(:content) { should match(/^error_reporting = #{e(php_cfg['error_reporting'])}$/) }
  its(:content) { should match(/^display_errors = #{e(php_cfg['display_errors'])}$/) }
  its(:content) { should match(/^display_startup_errors = #{e(php_cfg['display_startup_errors'])}$/) }
  its(:content) { should match(/^log_errors = #{e(php_cfg['log_errors'])}$/) }
  its(:content) { should match(/^log_errors_max_len = #{e(php_cfg['log_errors_max_len'])}$/) }
  its(:content) { should match(/^ignore_repeated_errors = #{e(php_cfg['ignore_repeated_errors'])}$/) }
  its(:content) { should match(/^ignore_repeated_source = #{e(php_cfg['ignore_repeated_source'])}$/) }
  its(:content) { should match(/^report_memleaks = #{e(php_cfg['report_memleaks'])}$/) }
  if php_cfg.key?('report_zend_debug')
    its(:content) { should match(/^report_zend_debug = #{e(php_cfg['report_zend_debug'])}$/) }
  end
  its(:content) { should match(/^track_errors = #{e(php_cfg['track_errors'])}$/) }
  if php_cfg.key?('xmlrpc_errors')
    its(:content) { should match(/^xmlrpc_errors = #{e(php_cfg['xmlrpc_errors'])}$/) }
  end
  if php_cfg.key?('xmlrpc_error_number')
    its(:content) { should match(/^xmlrpc_error_number = #{e(php_cfg['xmlrpc_error_number'])}$/) }
  end
  its(:content) { should match(/^html_errors = #{e(php_cfg['html_errors'])}$/) }
  if php_cfg.key?('docref_root')
    its(:content) { should match(/^docref_root = #{e(php_cfg['docref_root'])}$/) }
  end
  if php_cfg.key?('docref_ext')
    its(:content) { should match(/^docref_ext = #{e(php_cfg['docref_ext'])}$/) }
  end
  if php_cfg.key?('error_prepend_string')
    its(:content) { should match(/^error_prepend_string = #{e(php_cfg['error_prepend_string'])}$/) }
  end
  if php_cfg.key?('error_append_string')
    its(:content) { should match(/^error_append_string = #{e(php_cfg['error_append_string'])}$/) }
  end
  if php_cfg.key?('error_log')
    its(:content) { should match(/^error_log = #{e(php_cfg['error_log'])}$/) }
  end
  its(:content) { should match(/^variables_order = "#{e(php_cfg['variables_order'])}"$/) }
  its(:content) { should match(/^request_order = "#{e(php_cfg['request_order'])}"$/) }
  its(:content) { should match(/^register_argc_argv = #{e(php_cfg['register_argc_argv'])}$/) }
  its(:content) { should match(/^auto_globals_jit = #{e(php_cfg['auto_globals_jit'])}$/) }
  if php_cfg.key?('enable_post_data_reading')
    its(:content) { should match(/^enable_post_data_reading = #{e(php_cfg['enable_post_data_reading'])}$/) }
  end
  its(:content) { should match(/^post_max_size = #{e(php_cfg['post_max_size'])}$/) }
  its(:content) { should match(/^auto_prepend_file = #{e(php_cfg['auto_prepend_file'])}$/) }
  its(:content) { should match(/^auto_append_file = #{e(php_cfg['auto_append_file'])}$/) }
  its(:content) { should match(/^default_mimetype = "#{e(php_cfg['default_mimetype'])}"$/) }
  its(:content) { should match(/^default_charset = "#{e(php_cfg['default_charset'])}"$/) }
  if php_cfg.key?('internal_encoding')
    its(:content) { should match(/^internal_encoding = #{e(php_cfg['internal_encoding'])}$/) }
  end
  if php_cfg.key?('input_encoding')
    its(:content) { should match(/^input_encoding = #{e(php_cfg['input_encoding'])}$/) }
  end
  if php_cfg.key?('output_encoding')
    its(:content) { should match(/^output_encoding = #{e(php_cfg['output_encoding'])}$/) }
  end
  if php_cfg.key?('always_populate_raw_post_data')
    its(:content) { should match(/^always_populate_raw_post_data = #{e(php_cfg['always_populate_raw_post_data'])}$/) }
  end
  if php_cfg.key?('include_path')
    its(:content) { should match(/^include_path = #{e(php_cfg['include_path'])}$/) }
  end
  its(:content) { should match(/^doc_root = #{e(php_cfg['doc_root'])}$/) }
  its(:content) { should match(/^user_dir = #{e(php_cfg['user_dir'])}$/) }
  if php_cfg.key?('extension_dir')
    its(:content) { should match(/^extension_dir = #{e(php_cfg['extension_dir'])}$/) }
  end
  if php_cfg.key?('sys_temp_dir')
    its(:content) { should match(/^sys_temp_dir = #{e(php_cfg['sys_temp_dir'])}$/) }
  end
  its(:content) { should match(/^enable_dl = #{e(php_cfg['enable_dl'])}$/) }
  its(:content) { should match(/^file_uploads = #{e(php_cfg['file_uploads'])}$/) }
  if php_cfg.key?('upload_tmp_dir')
    its(:content) { should match(/^upload_tmp_dir = #{e(php_cfg['upload_tmp_dir'])}$/) }
  end
  its(:content) { should match(/^upload_max_filesize = #{e(php_cfg['upload_max_filesize'])}$/) }
  its(:content) { should match(/^max_file_uploads = #{e(php_cfg['max_file_uploads'])}$/) }
  its(:content) { should match(/^allow_url_fopen = #{e(php_cfg['allow_url_fopen'])}$/) }
  its(:content) { should match(/^allow_url_include = #{e(php_cfg['allow_url_include'])}$/) }
  if php_cfg.key?('from')
    its(:content) { should match(/^from = #{e(php_cfg['from'])}$/) }
  end
  if php_cfg.key?('user_agent')
    its(:content) { should match(/^user_agent = #{e(php_cfg['user_agent'])}$/) }
  end
  its(:content) { should match(/^default_socket_timeout = #{e(php_cfg['default_socket_timeout'])}$/) }
  if php_cfg.key?('auto_detect_line_endings')
    its(:content) { should match(/^auto_detect_line_endings = #{e(php_cfg['auto_detect_line_endings'])}$/) }
  end
  if php_cfg.key?('sendmail_path')
    its(:content) { should match(/^sendmail_path = #{e(php_cfg['sendmail_path'])}$/) }
  end
  if php_cfg.key?('browscap')
    its(:content) { should match(/^browscap = #{e(php_cfg['browscap'])}$/) }
  end
  its(:content) { should match(/^cli_server.color = #{e(php_cfg['cli_server']['color'])}$/) }

  if php_cfg.key?('url_rewriter')
    if php_cfg['url_rewriter'].key?('tags')
      its(:content) { should match(/^url_rewriter.tags = "#{e(php_cfg['url_rewriter']['tags'])}"$/) }
    end
    if php_cfg['url_rewriter'].key?('hosts')
      its(:content) { should match(/^url_rewriter.hosts = "#{e(php_cfg['url_rewriter']['hosts'])}"$/) }
    end
  end
  if php_cfg['mail'].key?('force_extra_parameters')
    its(:content) { should match(/^mail.force_extra_parameters = #{e(php_cfg['mail']['force_extra_parameters'])}$/) }
  end
  its(:content) { should match(/^mail.add_x_header = #{e(php_cfg['mail']['add_x_header'])}$/) }
  if php_cfg['mail'].key?('log')
    its(:content) { should match(/^mail.log = #{e(php_cfg['mail']['log'])}$/) }
  end
  if php_cfg.key?('arg_separator')
    if php_cfg['arg_separator'].key?('output')
      its(:content) { should match(/^arg_separator.output = #{e(php_cfg['arg_separator']['output'])}$/) }
    end
    if php_cfg['arg_separator'].key?('input')
      its(:content) { should match(/^arg_separator.input = #{e(php_cfg['arg_separator']['input'])}$/) }
    end
  end
  if php_cfg.key?('birdstep') && php_cfg['birdstep'].key?('max_links')
    its(:content) { should match(/^birdstep.max_links = #{e(php_cfg['birdstep']['max_links'])}$/) }
  end
  if php_cfg.key?('highlight')
    php_highlight_cfg = php_cfg['highlight']
    if php_highlight_cfg.key?('string')
      its(:content) { should match(/^highlight.string = #{e(php_highlight_cfg['string'])}$/) }
    end
    if php_highlight_cfg.key?('comment')
      its(:content) { should match(/^highlight.comment = #{e(php_highlight_cfg['comment'])}$/) }
    end
    if php_highlight_cfg.key?('keyword')
      its(:content) { should match(/^highlight.keyword = #{e(php_highlight_cfg['keyword'])}$/) }
    end
    if php_highlight_cfg.key?('default')
      its(:content) { should match(/^highlight.default = #{e(php_highlight_cfg['default'])}$/) }
    end
    if php_highlight_cfg.key?('html')
      its(:content) { should match(/^highlight.html = #{e(php_highlight_cfg['html'])}$/) }
    end
  end
  if php_cfg.key?('sysvshm') && php_cfg['sysvshm'].key?('init_mem')
    its(:content) { should match(/^sysvshm.init_mem = #{e(php_cfg['sysvshm']['init_mem'])}$/) }
  end
  # bcmath
  its(:content) { should match(/^bcmath.scale = #{e(php_cfg['bcmath']['scale'])}$/) }
  # curl
  if php_cfg.key?('curl') && php_cfg['curl'].key?('cainfo')
    its(:content) { should match(/^curl.cainfo = #{e(php_cfg['curl']['cainfo'])}$/) }
  end
  # Session
  php_session_cfg = php_cfg['session']
  its(:content) { should match(/^session.save_handler = #{e(php_session_cfg['save_handler'])}$/) }
  if php_session_cfg.key?('save_path')
    its(:content) { should match(/^session.save_path = #{e(php_session_cfg['save_path'])}$/) }
  end
  its(:content) { should match(/^session.use_strict_mode = #{e(php_session_cfg['use_strict_mode'])}$/) }
  its(:content) { should match(/^session.use_cookies = #{e(php_session_cfg['use_cookies'])}$/) }
  if php_session_cfg.key?('cookie_secure')
    its(:content) { should match(/^session.cookie_secure = #{e(php_session_cfg['cookie_secure'])}$/) }
  end
  its(:content) { should match(/^session.use_only_cookies = #{e(php_session_cfg['use_only_cookies'])}$/) }
  its(:content) { should match(/^session.name = #{e(php_session_cfg['name'])}$/) }
  its(:content) { should match(/^session.auto_start = #{e(php_session_cfg['auto_start'])}$/) }
  its(:content) { should match(/^session.cookie_lifetime = #{e(php_session_cfg['cookie_lifetime'])}$/) }
  its(:content) { should match(/^session.cookie_path = #{e(php_session_cfg['cookie_path'])}$/) }
  its(:content) { should match(/^session.cookie_domain = #{e(php_session_cfg['cookie_domain'])}$/) }
  its(:content) { should match(/^session.cookie_httponly = #{e(php_session_cfg['cookie_httponly'])}$/) }
  its(:content) { should match(/^session.serialize_handler = #{e(php_session_cfg['serialize_handler'])}$/) }
  its(:content) { should match(/^session.gc_probability = #{e(php_session_cfg['gc_probability'])}$/) }
  its(:content) { should match(/^session.gc_divisor = #{e(php_session_cfg['gc_divisor'])}$/) }
  its(:content) { should match(/^session.gc_maxlifetime = #{e(php_session_cfg['gc_maxlifetime'])}$/) }
  its(:content) { should match(/^session.referer_check = #{e(php_session_cfg['referer_check'])}$/) }

  if php_session_cfg.key?('entropy_length') && Gem::Version.new(property['php_version'].to_s) < Gem::Version.new('7.1')
    its(:content) { should match(/^session.entropy_length = #{e(php_session_cfg['entropy_length'])}$/) }
  end
  if php_session_cfg.key?('entropy_file') && Gem::Version.new(property['php_version'].to_s) < Gem::Version.new('7.1')
    its(:content) { should match(/^session.entropy_file = #{e(php_session_cfg['entropy_file'])}$/) }
  end
  its(:content) { should match(/^session.cache_limiter = #{e(php_session_cfg['cache_limiter'])}$/) }
  its(:content) { should match(/^session.cache_expire = #{e(php_session_cfg['cache_expire'])}$/) }
  its(:content) { should match(/^session.use_trans_sid = #{e(php_session_cfg['use_trans_sid'])}$/) }
  if Gem::Version.new(property['php_version'].to_s) >= Gem::Version.new('7.1')
    if php_session_cfg.key?('sid_length')
      its(:content) { should match(/^session.sid_length = #{e(php_session_cfg['sid_length'])}$/) }
    end
    if php_session_cfg.key?('trans_sid_tags')
      its(:content) { should match(/^session.trans_sid_tags = "#{e(php_session_cfg['trans_sid_tags'])}"$/) }
    end
    if php_session_cfg.key?('trans_sid_hosts')
      its(:content) { should match(/^session.trans_sid_hosts = #{e(php_session_cfg['trans_sid_hosts'])}$/) }
    end
    if php_session_cfg.key?('sid_bits_per_character')
      its(:content) { should match(/^session.sid_bits_per_character = #{e(php_session_cfg['sid_bits_per_character'])}$/) }
    end
  else
    if php_session_cfg.key?('hash_bits_per_character')
      its(:content) { should match(/^session.hash_bits_per_character = #{e(php_session_cfg['hash_bits_per_character'])}$/) }
    end
    if php_session_cfg.key?('hash_function')
      its(:content) { should match(/^session.hash_function = #{e(php_session_cfg['hash_function'])}$/) }
    end
  end
  if php_session_cfg.key?('upload_progress')
    if php_session_cfg['upload_progress'].key?('enabled')
      its(:content) { should match(/^session.upload_progress.enabled = #{e(php_session_cfg['upload_progress'])}$/) }
    end
    if php_session_cfg['upload_progress'].key?('cleanup')
      its(:content) { should match(/^session.upload_progress.cleanup = #{e(php_session_cfg['upload_progress'])}$/) }
    end
    if php_session_cfg['upload_progress'].key?('prefix')
      its(:content) { should match(/^session.upload_progress.prefix = #{e(php_session_cfg['upload_progress'])}$/) }
    end
    if php_session_cfg['upload_progress'].key?('name')
      its(:content) { should match(/^session.upload_progress.name = #{e(php_session_cfg['upload_progress'])}$/) }
    end
    if php_session_cfg['upload_progress'].key?('freq')
      its(:content) { should match(/^session.upload_progress.freq = #{e(php_session_cfg['upload_progress'])}$/) }
    end
    if php_session_cfg['upload_progress'].key?('min_freq')
      its(:content) { should match(/^session.upload_progress.min_freq = #{e(php_session_cfg['upload_progress'])}$/) }
    end
  end
  if php_session_cfg.key?('lazy_write')
    its(:content) { should match(/^session.lazy_write = #{e(php_session_cfg['lazy_write'])}$/) }
  end
  its(:content) { should match(/^sql.safe_mode = #{e(php_cfg['sql']['safe_mode'])}$/) }
  # Date
  php_date_cfg = php_cfg['date']
  its(:content) { should match(/^date.timezone = #{e(php_date_cfg['timezone'])}$/) }
  if php_date_cfg.key?('default_latitude')
    its(:content) { should match(/^date.default_latitude = #{e(php_date_cfg['default_latitude'])}$/) }
  end
  if php_date_cfg.key?('default_longitude')
    its(:content) { should match(/^date.default_longitude = #{e(php_date_cfg['default_longitude'])}$/) }
  end
  if php_date_cfg.key?('sunrise_zenith')
    its(:content) { should match(/^date.sunrise_zenith = #{e(php_date_cfg['sunrise_zenith'])}$/) }
  end
  if php_date_cfg.key?('sunset_zenith')
    its(:content) { should match(/^date.sunset_zenith = #{e(php_date_cfg['sunset_zenith'])}$/) }
  end
  # zend
  its(:content) { should match(/^zend.enable_gc = #{e(php_cfg['zend']['enable_gc'])}$/) }
  if php_cfg['zend'].key?('multibyte')
    its(:content) { should match(/^zend.multibyte = #{e(php_cfg['zend']['multibyte'])}$/) }
  end
  if php_cfg['zend'].key?('script_encoding')
    its(:content) { should match(/^zend.script_encoding = #{e(php_cfg['zend']['script_encoding'])}$/) }
  end
  if php_cfg['zend'].key?('assertions')
    its(:content) { should match(/^zend.assertions = #{e(php_cfg['zend']['assertions'])}$/) }
  end
  # DBA
  if php_cfg.key?('dba') && php_cfg['dba'].key?('default_handler')
    its(:content) { should match(/^dba.default_handler = #{e(php_cfg['dba']['default_handler'])}$/) }
  end
  # CGI
  if php_cfg.key?('cgi')
    php_cgi_cfg = php_cfg['cgi']
    if php_cgi_cfg.key?('force_redirect')
      its(:content) { should match(/^cgi.force_redirect = #{e(php_cgi_cfg['force_redirect'])}$/) }
    end
    if php_cgi_cfg.key?('nph')
      its(:content) { should match(/^cgi.nph = #{e(php_cgi_cfg['nph'])}$/) }
    end
    if php_cgi_cfg.key?('redirect_status_env')
      its(:content) { should match(/^cgi.redirect_status_env = #{e(php_cgi_cfg['redirect_status_env'])}$/) }
    end
    if php_cgi_cfg.key?('fix_pathinfo')
      its(:content) { should match(/^cgi.fix_pathinfo = #{e(php_cgi_cfg['fix_pathinfo'])}$/) }
    end
    if php_cgi_cfg.key?('discard_path')
      its(:content) { should match(/^cgi.discard_path = #{e(php_cgi_cfg['discard_path'])}$/) }
    end
    if php_cgi_cfg.key?('rfc2616_headers')
      its(:content) { should match(/^cgi.rfc2616_headers = #{e(php_cgi_cfg['rfc2616_headers'])}$/) }
    end
    if php_cgi_cfg.key?('check_shebang_line')
      its(:content) { should match(/^cgi.check_shebang_line = #{e(php_cgi_cfg['check_shebang_line'])}$/) }
    end
  end
  # fastcgi
  if php_cfg.key?('fastcgi')
    if php_cfg['fastcgi'].key?('impersonate')
      its(:content) { should match(/^fastcgi.impersonate = #{e(php_cfg['fastcgi']['impersonate'])}$/) }
    end
    if php_cfg['fastcgi'].key?('logging')
      its(:content) { should match(/^fastcgi.logging = #{e(php_cfg['fastcgi']['logging'])}$/) }
    end
  end
  # ibase
  its(:content) { should match(/^ibase.allow_persistent = #{e(php_cfg['ibase']['allow_persistent'])}$/) }
  its(:content) { should match(/^ibase.max_persistent = #{e(php_cfg['ibase']['max_persistent'])}$/) }
  its(:content) { should match(/^ibase.max_links = #{e(php_cfg['ibase']['max_links'])}$/) }
  if php_cfg['ibase'].key?('default_db')
    its(:content) { should match(/^ibase.default_db = #{e(php_cfg['ibase']['default_db'])}$/) }
  end
  if php_cfg['ibase'].key?('default_user')
    its(:content) { should match(/^ibase.default_user = #{e(php_cfg['ibase']['default_user'])}$/) }
  end
  if php_cfg['ibase'].key?('default_password')
    its(:content) { should match(/^ibase.default_password = #{e(php_cfg['ibase']['default_password'])}$/) }
  end
  if php_cfg['ibase'].key?('default_charset')
    its(:content) { should match(/^ibase.default_charset = #{e(php_cfg['ibase']['default_charset'])}$/) }
  end
  its(:content) { should match(/^ibase.timestampformat = "#{e(php_cfg['ibase']['timestampformat'])}"$/) }
  its(:content) { should match(/^ibase.dateformat = "#{e(php_cfg['ibase']['dateformat'])}"$/) }
  its(:content) { should match(/^ibase.timeformat = "#{e(php_cfg['ibase']['timeformat'])}"$/) }
  # ODBC
  if php_cfg['odbc'].key?('default_db')
    its(:content) { should match(/^odbc.default_db = #{e(php_cfg['odbc']['default_db'])}$/) }
  end
  if php_cfg['odbc'].key?('default_user')
    its(:content) { should match(/^odbc.default_user = #{e(php_cfg['odbc']['default_user'])}$/) }
  end
  if php_cfg['odbc'].key?('default_pw')
    its(:content) { should match(/^odbc.default_pw = #{e(php_cfg['odbc']['default_pw'])}$/) }
  end
  if php_cfg['odbc'].key?('default_cursortype')
    its(:content) { should match(/^odbc.default_cursortype = #{e(php_cfg['odbc']['default_cursortype'])}$/) }
  end
  its(:content) { should match(/^odbc.allow_persistent = #{e(php_cfg['odbc']['allow_persistent'])}$/) }
  its(:content) { should match(/^odbc.check_persistent = #{e(php_cfg['odbc']['check_persistent'])}$/) }
  its(:content) { should match(/^odbc.max_persistent = #{e(php_cfg['odbc']['max_persistent'])}$/) }
  its(:content) { should match(/^odbc.max_links = #{e(php_cfg['odbc']['max_links'])}$/) }
  its(:content) { should match(/^odbc.defaultlrl = #{e(php_cfg['odbc']['defaultlrl'])}$/) }
  its(:content) { should match(/^odbc.defaultbinmode = #{e(php_cfg['odbc']['defaultbinmode'])}$/) }
  # OpenSSL
  if php_cfg.key?('openssl')
    if php_cfg['openssl'].key?('cafile')
      its(:content) { should match(/^openssl.cafile = #{e(php_cfg['openssl']['cafile'])}$/) }
    end
    if php_cfg['openssl'].key?('capath')
      its(:content) { should match(/^openssl.capath = #{e(php_cfg['openssl']['capath'])}$/) }
    end
  end
  # PDO(MySQL)
  its(:content) { should match(/^pdo_mysql.cache_size = #{e(php_cfg['pdo_mysql']['cache_size'])}$/) }
  its(:content) { should match(/^pdo_mysql.default_socket = #{e(php_cfg['pdo_mysql']['default_socket'])}$/) }
  # PDO(ODBC)
  if php_cfg.key?('pdo_odbc')
    if php_cfg['pdo_odbc'].key?('connection_pooling')
      its(:content) { should match(/^pdo_odbc.connection_pooling = #{e(php_cfg['pdo_odbc']['connection_pooling'])}$/) }
    end
    if php_cfg['pdo_odbc'].key?('db2_instance_name')
      its(:content) { should match(/^pdo_odbc.db2_instance_name = #{e(php_cfg['pdo_odbc']['db2_instance_name'])}$/) }
    end
  end
  # PCRE
  if php_cfg.key?('pcre')
    if php_cfg['pcre'].key?('backtrack_limit')
      its(:content) { should match(/^pcre.backtrack_limit = #{e(php_cfg['pcre']['backtrack_limit'])}$/) }
    end
    if php_cfg['pcre'].key?('recursion_limit')
      its(:content) { should match(/^pcre.recursion_limit = #{e(php_cfg['pcre']['recursion_limit'])}$/) }
    end
    if php_cfg['pcre'].key?('jit')
      its(:content) { should match(/^pcre.jit = #{e(php_cfg['pcre']['jit'])}$/) }
    end
  end
  # Phar
  if php_cfg.key?('phar')
    if php_cfg['phar'].key?('readonly')
      its(:content) { should match(/^phar.readonly = #{e(php_cfg['phar']['readonly'])}$/) }
    end
    if php_cfg['phar'].key?('require_hash')
      its(:content) { should match(/^phar.require_hash = #{e(php_cfg['phar']['require_hash'])}$/) }
    end
    if php_cfg['phar'].key?('cache_list')
      its(:content) { should match(/^phar.cache_list = #{e(php_cfg['phar']['cache_list'])}$/) }
    end
  end
  # zlib
  its(:content) { should match(/^zlib.output_compression = #{e(php_cfg['zlib']['output_compression'])}$/) }
  if php_cfg['zlib'].key?('output_compression_level')
    its(:content) { should match(/^zlib.output_compression_level = #{e(php_cfg['zlib']['output_compression_level'])}$/) }
  end
  if php_cfg['zlib'].key?('output_handler')
    its(:content) { should match(/^zlib.output_handler = #{e(php_cfg['zlib']['output_handler'])}$/) }
  end
  # SQLite3
  if php_cfg.key?('sqlite3') && php_cfg['sqlite3'].key?('extension_dir')
    its(:content) { should match(/^sqlite3.extension_dir = #{e(php_cfg['sqlite3']['extension_dir'])}$/) }
  end
  # intl
  if php_cfg.key?('intl')
    if php_cfg['intl'].key?('default_locale')
      its(:content) { should match(/^intl.default_locale = #{e(php_cfg['intl']['default_locale'])}$/) }
    end
    if php_cfg['intl'].key?('error_level')
      its(:content) { should match(/^intl.error_level = #{e(php_cfg['intl']['error_level'])}$/) }
    end
    if php_cfg['intl'].key?('use_exceptions')
      its(:content) { should match(/^intl.use_exceptions = #{e(php_cfg['intl']['use_exceptions'])}$/) }
    end
  end
  # MySQLi
  its(:content) { should match(/^mysqli.max_persistent = #{e(php_cfg['mysqli']['max_persistent'])}$/) }
  if php_cfg['mysqli'].key?('allow_local_infile')
    its(:content) { should match(/^mysqli.allow_local_infile = #{e(php_cfg['mysqli']['allow_local_infile'])}$/) }
  end
  its(:content) { should match(/^mysqli.allow_persistent = #{e(php_cfg['mysqli']['allow_persistent'])}$/) }
  its(:content) { should match(/^mysqli.max_links = #{e(php_cfg['mysqli']['max_links'])}$/) }
  its(:content) { should match(/^mysqli.cache_size = #{e(php_cfg['mysqli']['cache_size'])}$/) }
  its(:content) { should match(/^mysqli.default_port = #{e(php_cfg['mysqli']['default_port'])}$/) }
  its(:content) { should match(/^mysqli.default_socket = #{e(php_cfg['mysqli']['default_socket'])}$/) }
  its(:content) { should match(/^mysqli.default_host = #{e(php_cfg['mysqli']['default_host'])}$/) }
  its(:content) { should match(/^mysqli.default_user = #{e(php_cfg['mysqli']['default_user'])}$/) }
  its(:content) { should match(/^mysqli.default_pw = #{e(php_cfg['mysqli']['default_pw'])}$/) }
  its(:content) { should match(/^mysqli.reconnect = #{e(php_cfg['mysqli']['reconnect'])}$/) }
  # MySQL Native Driver
  php_mysqlnd_cfg = php_cfg['mysqlnd']
  its(:content) { should match(/^mysqlnd.collect_statistics = #{e(php_mysqlnd_cfg['collect_statistics'])}$/) }
  its(:content) { should match(/^mysqlnd.collect_memory_statistics = #{e(php_mysqlnd_cfg['collect_memory_statistics'])}$/) }
  if php_mysqlnd_cfg.key?('debug')
    its(:content) { should match(/^mysqlnd.debug = #{e(php_mysqlnd_cfg['debug'])}$/) }
  end
  if php_mysqlnd_cfg.key?('log_mask')
    its(:content) { should match(/^mysqlnd.log_mask = #{e(php_mysqlnd_cfg['log_mask'])}$/) }
  end
  if php_mysqlnd_cfg.key?('mempool_default_size')
    its(:content) { should match(/^mysqlnd.mempool_default_size = #{e(php_mysqlnd_cfg['mempool_default_size'])}$/) }
  end
  if php_mysqlnd_cfg.key?('net_cmd_buffer_size')
    its(:content) { should match(/^mysqlnd.net_cmd_buffer_size = #{e(php_mysqlnd_cfg['net_cmd_buffer_size'])}$/) }
  end
  if php_mysqlnd_cfg.key?('net_read_buffer_size')
    its(:content) { should match(/^mysqlnd.net_read_buffer_size = #{e(php_mysqlnd_cfg['net_read_buffer_size'])}$/) }
  end
  if php_mysqlnd_cfg.key?('net_read_timeout')
    its(:content) { should match(/^mysqlnd.net_read_timeout = #{e(php_mysqlnd_cfg['net_read_timeout'])}$/) }
  end
  if php_mysqlnd_cfg.key?('sha256_server_public_key')
    its(:content) { should match(/^mysqlnd.sha256_server_public_key = #{e(php_mysqlnd_cfg['sha256_server_public_key'])}$/) }
  end
  # mcrypt
  if php_cfg.key?('mcrypt')
    if php_cfg['mcrypt'].key?('algorithms_dir')
      its(:content) { should match(/^mcrypt.algorithms_dir = #{e(php_cfg['mcrypt']['algorithms_dir'])}$/) }
    end
    if php_cfg['mcrypt'].key?('modes_dir')
      its(:content) { should match(/^mcrypt.modes_dir = #{e(php_cfg['mcrypt']['modes_dir'])}$/) }
    end
  end
  # filter
  if php_cfg.key?('filter')
    if php_cfg['filter'].key?('default')
      its(:content) { should match(/^filter.default = #{e(php_cfg['filter']['default'])}$/) }
    end
    if php_cfg['filter'].key?('default_flags')
      its(:content) { should match(/^filter.default_flags = #{e(php_cfg['filter']['default_flags'])}$/) }
    end
  end
  # pgsql
  its(:content) { should match(/^pgsql.allow_persistent = #{e(php_cfg['pgsql']['allow_persistent'])}$/) }
  its(:content) { should match(/^pgsql.auto_reset_persistent = #{e(php_cfg['pgsql']['auto_reset_persistent'])}$/) }
  its(:content) { should match(/^pgsql.max_persistent = #{e(php_cfg['pgsql']['max_persistent'])}$/) }
  its(:content) { should match(/^pgsql.max_links = #{e(php_cfg['pgsql']['max_links'])}$/) }
  its(:content) { should match(/^pgsql.ignore_notice = #{e(php_cfg['pgsql']['ignore_notice'])}$/) }
  its(:content) { should match(/^pgsql.log_notice = #{e(php_cfg['pgsql']['log_notice'])}$/) }
  # GD
  if php_cfg.key?('gd') && php_cfg['gd'].key?('jpeg_ignore_warning')
    its(:content) { should match(/^gd.jpeg_ignore_warning = #{e(php_cfg['gd']['jpeg_ignore_warning'])}$/) }
  end
  # exif
  if php_cfg.key?('exif')
    php_exif_cfg = php_cfg['exif']
    if php_exif_cfg.key?('encode_unicode')
      its(:content) { should match(/^exif.encode_unicode = #{e(php_exif_cfg['encode_unicode'])}$/) }
    end
    if php_exif_cfg.key?('decode_unicode_motorola')
      its(:content) { should match(/^exif.decode_unicode_motorola = #{e(php_exif_cfg['decode_unicode_motorola'])}$/) }
    end
    if php_exif_cfg.key?('decode_unicode_intel')
      its(:content) { should match(/^exif.decode_unicode_intel = #{e(php_exif_cfg['decode_unicode_intel'])}$/) }
    end
    if php_exif_cfg.key?('encode_jis')
      its(:content) { should match(/^exif.encode_jis = #{e(php_exif_cfg['encode_jis'])}$/) }
    end
    if php_exif_cfg.key?('decode_jis_motorola')
      its(:content) { should match(/^exif.decode_jis_motorola = #{e(php_exif_cfg['decode_jis_motorola'])}$/) }
    end
    if php_exif_cfg.key?('decode_jis_intel')
      its(:content) { should match(/^exif.decode_jis_intel = #{e(php_exif_cfg['decode_jis_intel'])}$/) }
    end
  end
  # tidy
  if php_cfg['tidy'].key?('default_config')
    its(:content) { should match(/^tidy.default_config = #{e(php_cfg['tidy']['default_config'])}$/) }
  end
  its(:content) { should match(/^tidy.clean_output = #{e(php_cfg['tidy']['clean_output'])}$/) }
  # iconv
  if php_cfg.key?('iconv')
    if php_cfg['iconv'].key?('input_encoding')
      its(:content) { should match(/^iconv.input_encoding = #{e(php_cfg['iconv']['input_encoding'])}$/) }
    end
    if php_cfg['iconv'].key?('internal_encoding')
      its(:content) { should match(/^iconv.internal_encoding = #{e(php_cfg['iconv']['internal_encoding'])}$/) }
    end
    if php_cfg['iconv'].key?('output_encoding')
      its(:content) { should match(/^iconv.output_encoding = #{e(php_cfg['iconv']['output_encoding'])}$/) }
    end
  end
  # imagick
  if php_cfg.key?('imagick')
    if php_cfg['imagick'].key?('locale_fix')
      its(:content) { should match(/^extra_parameters.imagick.locale_fix = #{e(php_cfg['imagick']['locale_fix'])}$/) }
    end
    if php_cfg['imagick'].key?('progress_monitor')
      its(:content) { should match(/^extra_parameters.imagick.progress_monitor = #{e(php_cfg['imagick']['progress_monitor'])}$/) }
    end
    if php_cfg['imagick'].key?('skip_version_check')
      its(:content) { should match(/^extra_parameters.imagick.skip_version_check = #{e(php_cfg['imagick']['skip_version_check'])}$/) }
    end
  end
  # mbstring
  if php_cfg.key?('mbstring')
    php_mbstring_cfg = php_cfg['mbstring']
    if php_mbstring_cfg.key?('language')
      its(:content) { should match(/^mbstring.language = #{e(php_mbstring_cfg['language'])}$/) }
    end
    if php_mbstring_cfg.key?('internal_encoding')
      its(:content) { should match(/^mbstring.internal_encoding = #{e(php_mbstring_cfg['internal_encoding'])}$/) }
    end
    if php_mbstring_cfg.key?('http_input')
      its(:content) { should match(/^mbstring.http_input = #{e(php_mbstring_cfg['http_input'])}$/) }
    end
    if php_mbstring_cfg.key?('http_output')
      its(:content) { should match(/^mbstring.http_output = #{e(php_mbstring_cfg['http_output'])}$/) }
    end
    if php_mbstring_cfg.key?('encoding_translation')
      its(:content) { should match(/^mbstring.encoding_translation = #{e(php_mbstring_cfg['encoding_translation'])}$/) }
    end
    if php_mbstring_cfg.key?('detect_order')
      its(:content) { should match(/^mbstring.detect_order = #{e(php_mbstring_cfg['detect_order'])}$/) }
    end
    if php_mbstring_cfg.key?('substitute_character')
      its(:content) { should match(/^mbstring.substitute_character = #{e(php_mbstring_cfg['substitute_character'])}$/) }
    end
    if php_mbstring_cfg.key?('func_overload')
      its(:content) { should match(/^mbstring.func_overload = #{e(php_mbstring_cfg['func_overload'])}$/) }
    end
    if php_mbstring_cfg.key?('strict_detection')
      its(:content) { should match(/^mbstring.strict_detection = #{e(php_mbstring_cfg['strict_detection'])}$/) }
    end
    if php_mbstring_cfg.key?('http_output_conv_mimetype')
      its(:content) { should match(/^mbstring.http_output_conv_mimetype = #{e(php_mbstring_cfg['http_output_conv_mimetype'])}$/) }
    end
  end
  # soap
  its(:content) { should match(/^soap.wsdl_cache_enabled = #{e(php_cfg['soap']['wsdl_cache_enabled'])}$/) }
  its(:content) { should match(/^soap.wsdl_cache_dir = "#{e(php_cfg['soap']['wsdl_cache_dir'])}"$/) }
  its(:content) { should match(/^soap.wsdl_cache_ttl = #{e(php_cfg['soap']['wsdl_cache_ttl'])}$/) }
  its(:content) { should match(/^soap.wsdl_cache_limit = #{e(php_cfg['soap']['wsdl_cache_limit'])}$/) }
  # LDAP
  its(:content) { should match(/^ldap.max_links = #{e(php_cfg['ldap']['max_links'])}$/) }
  # Assert
  if php_cfg.key?('assert')
    if php_cfg['assert'].key?('active')
      its(:content) { should match(/^assert.active = #{e(php_cfg['assert']['active'])}$/) }
    end
    if php_cfg['assert'].key?('exception')
      its(:content) { should match(/^assert.exception = #{e(php_cfg['assert']['exception'])}$/) }
    end
    if php_cfg['assert'].key?('warning')
      its(:content) { should match(/^assert.warning = #{e(php_cfg['assert']['warning'])}$/) }
    end
    if php_cfg['assert'].key?('bail')
      its(:content) { should match(/^assert.bail = #{e(php_cfg['assert']['bail'])}$/) }
    end
    if php_cfg['assert'].key?('callback')
      its(:content) { should match(/^assert.callback = #{e(php_cfg['assert']['callback'])}$/) }
    end
    if php_cfg['assert'].key?('quiet_eval')
      its(:content) { should match(/^assert.quiet_eval = #{e(php_cfg['assert']['quiet_eval'])}$/) }
    end
  end
  # Opcache
  if php_cfg.key?('opcache')
    php_opcache_cfg = php_cfg['opcache']
    if php_opcache_cfg.key?('enable')
      its(:content) { should match(/^opcache.enable = #{e(php_opcache_cfg['enable'])}$/) }
    end
    if php_opcache_cfg.key?('enable_cli')
      its(:content) { should match(/^opcache.enable_cli = #{e(php_opcache_cfg['enable_cli'])}$/) }
    end
    if php_opcache_cfg.key?('memory_consumption')
      its(:content) { should match(/^opcache.memory_consumption = #{e(php_opcache_cfg['memory_consumption'])}$/) }
    end
    if php_opcache_cfg.key?('interned_strings_buffer')
      its(:content) { should match(/^opcache.interned_strings_buffer = #{e(php_opcache_cfg['interned_strings_buffer'])}$/) }
    end
    if php_opcache_cfg.key?('max_accelerated_files')
      its(:content) { should match(/^opcache.max_accelerated_files = #{e(php_opcache_cfg['max_accelerated_files'])}$/) }
    end
    if php_opcache_cfg.key?('max_wasted_percentage')
      its(:content) { should match(/^opcache.max_wasted_percentage = #{e(php_opcache_cfg['max_wasted_percentage'])}$/) }
    end
    if php_opcache_cfg.key?('use_cwd')
      its(:content) { should match(/^opcache.use_cwd = #{e(php_opcache_cfg['use_cwd'])}$/) }
    end
    if php_opcache_cfg.key?('validate_timestamps')
      its(:content) { should match(/^opcache.validate_timestamps = #{e(php_opcache_cfg['validate_timestamps'])}$/) }
    end
    if php_opcache_cfg.key?('revalidate_freq')
      its(:content) { should match(/^opcache.revalidate_freq = #{e(php_opcache_cfg['revalidate_freq'])}$/) }
    end
    if php_opcache_cfg.key?('revalidate_path')
      its(:content) { should match(/^opcache.revalidate_path = #{e(php_opcache_cfg['revalidate_path'])}$/) }
    end
    if php_opcache_cfg.key?('save_comments')
      its(:content) { should match(/^opcache.save_comments = #{e(php_opcache_cfg['save_comments'])}$/) }
    end
    if php_opcache_cfg.key?('fast_shutdown')
      its(:content) { should match(/^opcache.fast_shutdown = #{e(php_opcache_cfg['fast_shutdown'])}$/) }
    end
    if php_opcache_cfg.key?('enable_file_override')
      its(:content) { should match(/^opcache.enable_file_override = #{e(php_opcache_cfg['enable_file_override'])}$/) }
    end
    if php_opcache_cfg.key?('optimization_level')
      its(:content) { should match(/^opcache.optimization_level = #{e(php_opcache_cfg['optimization_level'])}$/) }
    end
    if php_opcache_cfg.key?('inherited_hack')
      its(:content) { should match(/^opcache.inherited_hack = #{e(php_opcache_cfg['inherited_hack'])}$/) }
    end
    if php_opcache_cfg.key?('dups_fix')
      its(:content) { should match(/^opcache.dups_fix = #{e(php_opcache_cfg['dups_fix'])}$/) }
    end
    if php_opcache_cfg.key?('blacklist_filename')
      its(:content) { should match(/^opcache.blacklist_filename = #{e(php_opcache_cfg['blacklist_filename'])}$/) }
    end
    if php_opcache_cfg.key?('max_file_size')
      its(:content) { should match(/^opcache.max_file_size = #{e(php_opcache_cfg['max_file_size'])}$/) }
    end
    if php_opcache_cfg.key?('consistency_checks')
      its(:content) { should match(/^opcache.consistency_checks = #{e(php_opcache_cfg['consistency_checks'])}$/) }
    end
    if php_opcache_cfg.key?('force_restart_timeout')
      its(:content) { should match(/^opcache.force_restart_timeout = #{e(php_opcache_cfg['force_restart_timeout'])}$/) }
    end
    if php_opcache_cfg.key?('error_log')
      its(:content) { should match(/^opcache.error_log = #{e(php_opcache_cfg['error_log'])}$/) }
    end
    if php_opcache_cfg.key?('log_verbosity_level')
      its(:content) { should match(/^opcache.log_verbosity_level = #{e(php_opcache_cfg['log_verbosity_level'])}$/) }
    end
    if php_opcache_cfg.key?('preferred_memory_model')
      its(:content) { should match(/^opcache.preferred_memory_model = #{e(php_opcache_cfg['preferred_memory_model'])}$/) }
    end
    if php_opcache_cfg.key?('protect_memory')
      its(:content) { should match(/^opcache.protect_memory = #{e(php_opcache_cfg['protect_memory'])}$/) }
    end
    if php_opcache_cfg.key?('file_update_protection')
      its(:content) { should match(/^opcache.file_update_protection = #{e(php_opcache_cfg['file_update_protection'])}$/) }
    end
    if php_opcache_cfg.key?('restrict_api')
      its(:content) { should match(/^opcache.restrict_api = #{e(php_opcache_cfg['restrict_api'])}$/) }
    end
    if php_opcache_cfg.key?('mmap_base')
      its(:content) { should match(/^opcache.mmap_base = #{e(php_opcache_cfg['mmap_base'])}$/) }
    end
    if php_opcache_cfg.key?('file_cache')
      its(:content) { should match(/^opcache.file_cache = #{e(php_opcache_cfg['file_cache'])}$/) }
    end
    if php_opcache_cfg.key?('file_cache_only')
      its(:content) { should match(/^opcache.file_cache_only = #{e(php_opcache_cfg['file_cache_only'])}$/) }
    end
    if php_opcache_cfg.key?('file_cache_consistency_checks')
      its(:content) { should match(/^opcache.file_cache_consistency_checks = #{e(php_opcache_cfg['file_cache_consistency_checks'])}$/) }
    end
    if php_opcache_cfg.key?('file_cache_fallback')
      its(:content) { should match(/^opcache.file_cache_fallback = #{e(php_opcache_cfg['file_cache_fallback'])}$/) }
    end
    if php_opcache_cfg.key?('huge_code_pages')
      its(:content) { should match(/^opcache.huge_code_pages = #{e(php_opcache_cfg['huge_code_pages'])}$/) }
    end
    if php_opcache_cfg.key?('validate_permission')
      its(:content) { should match(/^opcache.validate_permission = #{e(php_opcache_cfg['validate_permission'])}$/) }
    end
    if php_opcache_cfg.key?('validate_root')
      its(:content) { should match(/^opcache.validate_root = #{e(php_opcache_cfg['validate_root'])}$/) }
    end
  end
  if php_cfg.key?('extra_setting')
    php_cfg['extra_parameters'].each do |section, settings|
      settings.each do |setting_name, setting_value|
        its(:content) { should match(/^#{section}.#{setting_name} = #{e(setting_value)}$/) }
      end
    end
  end
end
