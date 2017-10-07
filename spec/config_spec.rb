require 'spec_helper'
def e(value)
  if value.is_a?(TrueClass) || value.is_a?(FalseClass)
    php_ini_value = value ? 'On' : 'Off'
  elsif value.nil?
    php_ini_value = ""
  else
    php_ini_value = value
  end
  return Regexp.escape(php_ini_value.is_a?(String) ? php_ini_value : php_ini_value.to_s)
end
describe "PHP Configration" do
  describe file('/etc/php.ini') do
    # Core
    if property['php_cfg'].has_key?('user_ini')
      if property['php_cfg']['user_ini'].has_key?('filename')
        its(:content) { should match /^user_ini.filename = #{e(property['php_cfg']['user_ini']['filename'])}$/ }
      end
      if property['php_cfg']['user_ini'].has_key?('cache_ttl')
        its(:content) { should match /^user_ini.cache_ttl = #{e(property['php_cfg']['user_ini']['cache_ttl'])}$/ }
      end
    end
    its(:content) { should match /^engine = #{e(property['php_cfg']['engine'])}$/ }
    its(:content) { should match /^short_open_tag = #{e(property['php_cfg']['short_open_tag'])}$/ }
    if Gem::Version.new(property['php_version'].to_s) < Gem::Version.new('7') && property['php_cfg'].has_key?('asp_tags')
      its(:content) { should match /^asp_tags = #{e(property['php_cfg']['asp_tags'])}$/ }
    end
    its(:content) { should match /^precision = #{e(property['php_cfg']['precision'])}$/ }
    its(:content) { should match /^output_buffering = #{e(property['php_cfg']['output_buffering'])}$/ }
    if property['php_cfg'].has_key?('output_handler')
      its(:content) { should match /^output_handler = #{e(property['php_cfg']['output_handler'])}$/ }
    end
    its(:content) { should match /^implicit_flush = #{e(property['php_cfg']['implicit_flush'])}$/ }
    its(:content) { should match /^unserialize_callback_func = #{e(property['php_cfg']['unserialize_callback_func'])}$/ }
    its(:content) { should match /^serialize_precision = #{e(property['php_cfg']['serialize_precision'])}$/ }
    if property['php_cfg'].has_key?('open_basedir')
      its(:content) { should match /^open_basedir = #{e(property['php_cfg']['open_basedir'])}$/ }
    end
    its(:content) { should match /^disable_functions = #{e(property['php_cfg']['disable_functions'])}$/ }
    its(:content) { should match /^disable_classes = #{e(property['php_cfg']['disable_classes'])}$/ }
    if property['php_cfg'].has_key?('ignore_user_abort')
      its(:content) { should match /^ignore_user_abort = #{e(property['php_cfg']['ignore_user_abort'])}$/ }
    end
    if property['php_cfg'].has_key?('realpath_cache_size')
      its(:content) { should match /^realpath_cache_size = #{e(property['php_cfg']['realpath_cache_size'])}$/ }
    end
    if property['php_cfg'].has_key?('realpath_cache_ttl')
      its(:content) { should match /^realpath_cache_ttl = #{e(property['php_cfg']['realpath_cache_ttl'])}$/ }
    end
    its(:content) { should match /^expose_php = #{e(property['php_cfg']['expose_php'])}$/ }
    its(:content) { should match /^max_execution_time = #{e(property['php_cfg']['max_execution_time'])}$/ }
    its(:content) { should match /^max_input_time = #{e(property['php_cfg']['max_input_time'])}$/ }
    if property['php_cfg'].has_key?('max_input_nesting_level')
      its(:content) { should match /^max_input_nesting_level = #{e(property['php_cfg']['max_input_nesting_level'])}$/ }
    end
    if property['php_cfg'].has_key?('max_input_vars')
      its(:content) { should match /^max_input_vars = #{e(property['php_cfg']['max_input_vars'])}$/ }
    end
    its(:content) { should match /^memory_limit = #{e(property['php_cfg']['memory_limit'])}$/ }
    its(:content) { should match /^error_reporting = #{e(property['php_cfg']['error_reporting'])}$/ }
    its(:content) { should match /^display_errors = #{e(property['php_cfg']['display_errors'])}$/ }
    its(:content) { should match /^display_startup_errors = #{e(property['php_cfg']['display_startup_errors'])}$/ }
    its(:content) { should match /^log_errors = #{e(property['php_cfg']['log_errors'])}$/ }
    its(:content) { should match /^log_errors_max_len = #{e(property['php_cfg']['log_errors_max_len'])}$/ }
    its(:content) { should match /^ignore_repeated_errors = #{e(property['php_cfg']['ignore_repeated_errors'])}$/ }
    its(:content) { should match /^ignore_repeated_source = #{e(property['php_cfg']['ignore_repeated_source'])}$/ }
    its(:content) { should match /^report_memleaks = #{e(property['php_cfg']['report_memleaks'])}$/ }
    if property['php_cfg'].has_key?('report_zend_debug')
      its(:content) { should match /^report_zend_debug = #{e(property['php_cfg']['report_zend_debug'])}$/ }
    end
    its(:content) { should match /^track_errors = #{e(property['php_cfg']['track_errors'])}$/ }
    if property['php_cfg'].has_key?('xmlrpc_errors')
      its(:content) { should match /^xmlrpc_errors = #{e(property['php_cfg']['xmlrpc_errors'])}$/ }
    end
    if property['php_cfg'].has_key?('xmlrpc_error_number')
      its(:content) { should match /^xmlrpc_error_number = #{e(property['php_cfg']['xmlrpc_error_number'])}$/ }
    end
    its(:content) { should match /^html_errors = #{e(property['php_cfg']['html_errors'])}$/ }
    if property['php_cfg'].has_key?('docref_root')
      its(:content) { should match /^docref_root = #{e(property['php_cfg']['docref_root'])}$/ }
    end
    if property['php_cfg'].has_key?('docref_ext')
      its(:content) { should match /^docref_ext = #{e(property['php_cfg']['docref_ext'])}$/ }
    end
    if property['php_cfg'].has_key?('error_prepend_string')
      its(:content) { should match /^error_prepend_string = #{e(property['php_cfg']['error_prepend_string'])}$/ }
    end
    if property['php_cfg'].has_key?('error_append_string')
      its(:content) { should match /^error_append_string = #{e(property['php_cfg']['error_append_string'])}$/ }
    end
    if property['php_cfg'].has_key?('error_log')
      its(:content) { should match /^error_log = #{e(property['php_cfg']['error_log'])}$/ }
    end
    its(:content) { should match /^variables_order = "#{e(property['php_cfg']['variables_order'])}"$/ }
    its(:content) { should match /^request_order = "#{e(property['php_cfg']['request_order'])}"$/ }
    its(:content) { should match /^register_argc_argv = #{e(property['php_cfg']['register_argc_argv'])}$/ }
    its(:content) { should match /^auto_globals_jit = #{e(property['php_cfg']['auto_globals_jit'])}$/ }
    if property['php_cfg'].has_key?('enable_post_data_reading')
      its(:content) { should match /^enable_post_data_reading = #{e(property['php_cfg']['enable_post_data_reading'])}$/ }
    end
    its(:content) { should match /^post_max_size = #{e(property['php_cfg']['post_max_size'])}$/ }
    its(:content) { should match /^auto_prepend_file = #{e(property['php_cfg']['auto_prepend_file'])}$/ }
    its(:content) { should match /^auto_append_file = #{e(property['php_cfg']['auto_append_file'])}$/ }
    its(:content) { should match /^default_mimetype = "#{e(property['php_cfg']['default_mimetype'])}"$/ }
    its(:content) { should match /^default_charset = "#{e(property['php_cfg']['default_charset'])}"$/ }
    if property['php_cfg'].has_key?('internal_encoding')
      its(:content) { should match /^internal_encoding = #{e(property['php_cfg']['internal_encoding'])}$/ }
    end
    if property['php_cfg'].has_key?('input_encoding')
      its(:content) { should match /^input_encoding = #{e(property['php_cfg']['input_encoding'])}$/ }
    end
    if property['php_cfg'].has_key?('output_encoding')
      its(:content) { should match /^output_encoding = #{e(property['php_cfg']['output_encoding'])}$/ }
    end
    if property['php_cfg'].has_key?('always_populate_raw_post_data')
      its(:content) { should match /^always_populate_raw_post_data = #{e(property['php_cfg']['always_populate_raw_post_data'])}$/ }
    end
    if property['php_cfg'].has_key?('include_path')
      its(:content) { should match /^include_path = #{e(property['php_cfg']['include_path'])}$/ }
    end
    its(:content) { should match /^doc_root = #{e(property['php_cfg']['doc_root'])}$/ }
    its(:content) { should match /^user_dir = #{e(property['php_cfg']['user_dir'])}$/ }
    if property['php_cfg'].has_key?('extension_dir')
      its(:content) { should match /^extension_dir = #{e(property['php_cfg']['extension_dir'])}$/ }
    end
    if property['php_cfg'].has_key?('sys_temp_dir')
      its(:content) { should match /^sys_temp_dir = #{e(property['php_cfg']['sys_temp_dir'])}$/ }
    end
    its(:content) { should match /^enable_dl = #{e(property['php_cfg']['enable_dl'])}$/ }
    its(:content) { should match /^file_uploads = #{e(property['php_cfg']['file_uploads'])}$/ }
    if property['php_cfg'].has_key?('upload_tmp_dir')
      its(:content) { should match /^upload_tmp_dir = #{e(property['php_cfg']['upload_tmp_dir'])}$/ }
    end
    its(:content) { should match /^upload_max_filesize = #{e(property['php_cfg']['upload_max_filesize'])}$/ }
    its(:content) { should match /^max_file_uploads = #{e(property['php_cfg']['max_file_uploads'])}$/ }
    its(:content) { should match /^allow_url_fopen = #{e(property['php_cfg']['allow_url_fopen'])}$/ }
    its(:content) { should match /^allow_url_include = #{e(property['php_cfg']['allow_url_include'])}$/ }
    if property['php_cfg'].has_key?('from')
      its(:content) { should match /^from = #{e(property['php_cfg']['from'])}$/ }
    end
    if property['php_cfg'].has_key?('user_agent')
      its(:content) { should match /^user_agent = #{e(property['php_cfg']['user_agent'])}$/ }
    end
    its(:content) { should match /^default_socket_timeout = #{e(property['php_cfg']['default_socket_timeout'])}$/ }
    if property['php_cfg'].has_key?('auto_detect_line_endings')
      its(:content) { should match /^auto_detect_line_endings = #{e(property['php_cfg']['auto_detect_line_endings'])}$/ }
    end
    if property['php_cfg'].has_key?('sendmail_path')
      its(:content) { should match /^sendmail_path = #{e(property['php_cfg']['sendmail_path'])}$/ }
    end
    if property['php_cfg'].has_key?('browscap')
      its(:content) { should match /^browscap = #{e(property['php_cfg']['browscap'])}$/ }
    end
    its(:content) { should match /^cli_server.color = #{e(property['php_cfg']['cli_server']['color'])}$/ }

    if property['php_cfg'].has_key?('url_rewriter')
      if property['php_cfg']['url_rewriter'].has_key?('tags')
        its(:content) { should match /^url_rewriter.tags = "#{e(property['php_cfg']['url_rewriter']['tags'])}"$/ }
      end
      if property['php_cfg']['url_rewriter'].has_key?('hosts')
        its(:content) { should match /^url_rewriter.hosts = "#{e(property['php_cfg']['url_rewriter']['hosts'])}"$/ }
      end
    end

    if property['php_cfg']['mail'].has_key?('force_extra_parameters')
      its(:content) { should match /^mail.force_extra_parameters = #{e(property['php_cfg']['mail']['force_extra_parameters'])}$/ }
    end
    its(:content) { should match /^mail.add_x_header = #{e(property['php_cfg']['mail']['add_x_header'])}$/ }
    if property['php_cfg']['mail'].has_key?('log')
      its(:content) { should match /^mail.log = #{e(property['php_cfg']['mail']['log'])}$/ }
    end
    if property['php_cfg'].has_key?('arg_separator')
      if property['php_cfg']['arg_separator'].has_key?('output')
        its(:content) { should match /^arg_separator.output = #{e(property['php_cfg']['arg_separator']['output'])}$/ }
      end
      if property['php_cfg']['arg_separator'].has_key?('input')
        its(:content) { should match /^arg_separator.input = #{e(property['php_cfg']['arg_separator']['input'])}$/ }
      end
    end
    if property['php_cfg'].has_key?('birdstep') && property['php_cfg']['birdstep'].has_key?('max_links')
      its(:content) { should match /^birdstep.max_links = #{e(property['php_cfg']['birdstep']['max_links'])}$/ }
    end
    if property['php_cfg'].has_key?('highlight')
      if property['php_cfg']['highlight'].has_key?('string')
        its(:content) { should match /^highlight.string = #{e(property['php_cfg']['highlight']['string'])}$/ }
      end
      if property['php_cfg']['highlight'].has_key?('comment')
        its(:content) { should match /^highlight.comment = #{e(property['php_cfg']['highlight']['comment'])}$/ }
      end
      if property['php_cfg']['highlight'].has_key?('keyword')
        its(:content) { should match /^highlight.keyword = #{e(property['php_cfg']['highlight']['keyword'])}$/ }
      end
      if property['php_cfg']['highlight'].has_key?('default')
        its(:content) { should match /^highlight.default = #{e(property['php_cfg']['highlight']['default'])}$/ }
      end
      if property['php_cfg']['highlight'].has_key?('html')
        its(:content) { should match /^highlight.html = #{e(property['php_cfg']['highlight']['html'])}$/ }
      end
    end
    if property['php_cfg'].has_key?('sysvshm') && property['php_cfg']['sysvshm'].has_key?('init_mem')
      its(:content) { should match /^sysvshm.init_mem = #{e(property['php_cfg']['sysvshm']['init_mem'])}$/ }
    end
    # bcmath
    its(:content) { should match /^bcmath.scale = #{e(property['php_cfg']['bcmath']['scale'])}$/ }
    # curl
    if property['php_cfg'].has_key?('curl') && property['php_cfg']['curl'].has_key?('cainfo')
      its(:content) { should match /^curl.cainfo = #{e(property['php_cfg']['curl']['cainfo'])}$/ }
    end
    # Session
    its(:content) { should match /^session.save_handler = #{e(property['php_cfg']['session']['save_handler'])}$/ }
    if property['php_cfg']['session'].has_key?('save_path')
      its(:content) { should match /^session.save_path = #{e(property['php_cfg']['session']['save_path'])}$/ }
    end
    its(:content) { should match /^session.use_strict_mode = #{e(property['php_cfg']['session']['use_strict_mode'])}$/ }
    its(:content) { should match /^session.use_cookies = #{e(property['php_cfg']['session']['use_cookies'])}$/ }
    if property['php_cfg']['session'].has_key?('cookie_secure')
      its(:content) { should match /^session.cookie_secure = #{e(property['php_cfg']['session']['cookie_secure'])}$/ }
    end
    its(:content) { should match /^session.use_only_cookies = #{e(property['php_cfg']['session']['use_only_cookies'])}$/ }
    its(:content) { should match /^session.name = #{e(property['php_cfg']['session']['name'])}$/ }
    its(:content) { should match /^session.auto_start = #{e(property['php_cfg']['session']['auto_start'])}$/ }
    its(:content) { should match /^session.cookie_lifetime = #{e(property['php_cfg']['session']['cookie_lifetime'])}$/ }
    its(:content) { should match /^session.cookie_path = #{e(property['php_cfg']['session']['cookie_path'])}$/ }
    its(:content) { should match /^session.cookie_domain = #{e(property['php_cfg']['session']['cookie_domain'])}$/ }
    its(:content) { should match /^session.cookie_httponly = #{e(property['php_cfg']['session']['cookie_httponly'])}$/ }
    its(:content) { should match /^session.serialize_handler = #{e(property['php_cfg']['session']['serialize_handler'])}$/ }
    its(:content) { should match /^session.gc_probability = #{e(property['php_cfg']['session']['gc_probability'])}$/ }
    its(:content) { should match /^session.gc_divisor = #{e(property['php_cfg']['session']['gc_divisor'])}$/ }
    its(:content) { should match /^session.gc_maxlifetime = #{e(property['php_cfg']['session']['gc_maxlifetime'])}$/ }
    its(:content) { should match /^session.referer_check = #{e(property['php_cfg']['session']['referer_check'])}$/ }

    if property['php_cfg']['session'].has_key?('entropy_length') && Gem::Version.new(property['php_version'].to_s) < Gem::Version.new('7.1')
      its(:content) { should match /^session.entropy_length = #{e(property['php_cfg']['session']['entropy_length'])}$/ }
    end
    if property['php_cfg']['session'].has_key?('entropy_file') && Gem::Version.new(property['php_version'].to_s) < Gem::Version.new('7.1')
      its(:content) { should match /^session.entropy_file = #{e(property['php_cfg']['session']['entropy_file'])}$/ }
    end
    its(:content) { should match /^session.cache_limiter = #{e(property['php_cfg']['session']['cache_limiter'])}$/ }
    its(:content) { should match /^session.cache_expire = #{e(property['php_cfg']['session']['cache_expire'])}$/ }
    its(:content) { should match /^session.use_trans_sid = #{e(property['php_cfg']['session']['use_trans_sid'])}$/ }
    if Gem::Version.new(property['php_version'].to_s) >= Gem::Version.new('7.1')
      if property['php_cfg']['session'].has_key?('sid_length')
        its(:content) { should match /^session.sid_length = #{e(property['php_cfg']['session']['sid_length'])}$/ }
      end
      if property['php_cfg']['session'].has_key?('trans_sid_tags')
        its(:content) { should match /^session.trans_sid_tags = "#{e(property['php_cfg']['session']['trans_sid_tags'])}"$/ }
      end
      if property['php_cfg']['session'].has_key?('trans_sid_hosts')
        its(:content) { should match /^session.trans_sid_hosts = #{e(property['php_cfg']['session']['trans_sid_hosts'])}$/ }
      end
      if property['php_cfg']['session'].has_key?('sid_bits_per_character')
        its(:content) { should match /^session.sid_bits_per_character = #{e(property['php_cfg']['session']['sid_bits_per_character'])}$/ }
      end
    else
      if property['php_cfg']['session'].has_key?('hash_bits_per_character')
        its(:content) { should match /^session.hash_bits_per_character = #{e(property['php_cfg']['session']['hash_bits_per_character'])}$/ }
      end
      if property['php_cfg']['session'].has_key?('hash_function')
        its(:content) { should match /^session.hash_function = #{e(property['php_cfg']['session']['hash_function'])}$/ }
      end
    end
    if property['php_cfg']['session'].has_key?('upload_progress')
      if property['php_cfg']['session']['upload_progress'].has_key?('enabled')
          its(:content) { should match /^session.upload_progress.enabled = #{e(property['php_cfg']['session']['upload_progress'])}$/ }
      end
      if property['php_cfg']['session']['upload_progress'].has_key?('cleanup')
        its(:content) { should match /^session.upload_progress.cleanup = #{e(property['php_cfg']['session']['upload_progress'])}$/ }
      end
      if property['php_cfg']['session']['upload_progress'].has_key?('prefix')
        its(:content) { should match /^session.upload_progress.prefix = #{e(property['php_cfg']['session']['upload_progress'])}$/ }
      end
      if property['php_cfg']['session']['upload_progress'].has_key?('name')
        its(:content) { should match /^session.upload_progress.name = #{e(property['php_cfg']['session']['upload_progress'])}$/ }
      end
      if property['php_cfg']['session']['upload_progress'].has_key?('freq')
        its(:content) { should match /^session.upload_progress.freq = #{e(property['php_cfg']['session']['upload_progress'])}$/ }
      end
      if property['php_cfg']['session']['upload_progress'].has_key?('min_freq')
        its(:content) { should match /^session.upload_progress.min_freq = #{e(property['php_cfg']['session']['upload_progress'])}$/ }
      end
    end
    if property['php_cfg']['session'].has_key?('lazy_write')
      its(:content) { should match /^session.lazy_write = #{e(property['php_cfg']['session']['lazy_write'])}$/ }
    end
    its(:content) { should match /^sql.safe_mode = #{e(property['php_cfg']['sql']['safe_mode'])}$/ }
    # Date
    its(:content) { should match /^date.timezone = #{e(property['php_cfg']['date']['timezone'])}$/ }
    if property['php_cfg']['date'].has_key?('default_latitude')
      its(:content) { should match /^date.default_latitude = #{e(property['php_cfg']['date']['default_latitude'])}$/ }
    end
    if property['php_cfg']['date'].has_key?('default_longitude')
      its(:content) { should match /^date.default_longitude = #{e(property['php_cfg']['date']['default_longitude'])}$/ }
    end
    if property['php_cfg']['date'].has_key?('sunrise_zenith')
      its(:content) { should match /^date.sunrise_zenith = #{e(property['php_cfg']['date']['sunrise_zenith'])}$/ }
    end
    if property['php_cfg']['date'].has_key?('sunset_zenith')
      its(:content) { should match /^date.sunset_zenith = #{e(property['php_cfg']['date']['sunset_zenith'])}$/ }
    end
    # zend
    its(:content) { should match /^zend.enable_gc = #{e(property['php_cfg']['zend']['enable_gc'])}$/ }
    if property['php_cfg']['zend'].has_key?('multibyte')
      its(:content) { should match /^zend.multibyte = #{e(property['php_cfg']['zend']['multibyte'])}$/ }
    end
    if property['php_cfg']['zend'].has_key?('script_encoding')
      its(:content) { should match /^zend.script_encoding = #{e(property['php_cfg']['zend']['script_encoding'])}$/ }
    end
    if property['php_cfg']['zend'].has_key?('assertions')
      its(:content) { should match /^zend.assertions = #{e(property['php_cfg']['zend']['assertions'])}$/ }
    end
    # DBA
    if property['php_cfg'].has_key?('dba') && property['php_cfg']['dba'].has_key?('default_handler')
      its(:content) { should match /^dba.default_handler = #{e(property['php_cfg']['dba']['default_handler'])}$/ }
    end
    # CGI
    if property['php_cfg'].has_key?('cgi')
      if property['php_cfg']['cgi'].has_key?('force_redirect')
        its(:content) { should match /^cgi.force_redirect = #{e(property['php_cfg']['cgi']['force_redirect'])}$/ }
      end
      if property['php_cfg']['cgi'].has_key?('nph')
        its(:content) { should match /^cgi.nph = #{e(property['php_cfg']['cgi']['nph'])}$/ }
      end
      if property['php_cfg']['cgi'].has_key?('redirect_status_env')
        its(:content) { should match /^cgi.redirect_status_env = #{e(property['php_cfg']['cgi']['redirect_status_env'])}$/ }
      end
      if property['php_cfg']['cgi'].has_key?('fix_pathinfo')
        its(:content) { should match /^cgi.fix_pathinfo = #{e(property['php_cfg']['cgi']['fix_pathinfo'])}$/ }
      end
      if property['php_cfg']['cgi'].has_key?('discard_path')
        its(:content) { should match /^cgi.discard_path = #{e(property['php_cfg']['cgi']['discard_path'])}$/ }
      end
      if property['php_cfg']['cgi'].has_key?('rfc2616_headers')
        its(:content) { should match /^cgi.rfc2616_headers = #{e(property['php_cfg']['cgi']['rfc2616_headers'])}$/ }
      end
      if property['php_cfg']['cgi'].has_key?('check_shebang_line')
        its(:content) { should match /^cgi.check_shebang_line = #{e(property['php_cfg']['cgi']['check_shebang_line'])}$/ }
      end
    end
    # fastcgi
    if property['php_cfg'].has_key?('fastcgi')
      if property['php_cfg']['fastcgi'].has_key?('impersonate')
        its(:content) { should match /^fastcgi.impersonate = #{e(property['php_cfg']['fastcgi']['impersonate'])}$/ }
      end
      if property['php_cfg']['fastcgi'].has_key?('logging')
        its(:content) { should match /^fastcgi.logging = #{e(property['php_cfg']['fastcgi']['logging'])}$/ }
      end
    end
    # ibase
    its(:content) { should match /^ibase.allow_persistent = #{e(property['php_cfg']['ibase']['allow_persistent'])}$/ }
    its(:content) { should match /^ibase.max_persistent = #{e(property['php_cfg']['ibase']['max_persistent'])}$/ }
    its(:content) { should match /^ibase.max_links = #{e(property['php_cfg']['ibase']['max_links'])}$/ }
    if property['php_cfg']['ibase'].has_key?('default_db')
      its(:content) { should match /^ibase.default_db = #{e(property['php_cfg']['ibase']['default_db'])}$/ }
    end
    if property['php_cfg']['ibase'].has_key?('default_user')
      its(:content) { should match /^ibase.default_user = #{e(property['php_cfg']['ibase']['default_user'])}$/ }
    end
    if property['php_cfg']['ibase'].has_key?('default_password')
      its(:content) { should match /^ibase.default_password = #{e(property['php_cfg']['ibase']['default_password'])}$/ }
    end
    if property['php_cfg']['ibase'].has_key?('default_charset')
      its(:content) { should match /^ibase.default_charset = #{e(property['php_cfg']['ibase']['default_charset'])}$/ }
    end
    its(:content) { should match /^ibase.timestampformat = "#{e(property['php_cfg']['ibase']['timestampformat'])}"$/ }
    its(:content) { should match /^ibase.dateformat = "#{e(property['php_cfg']['ibase']['dateformat'])}"$/ }
    its(:content) { should match /^ibase.timeformat = "#{e(property['php_cfg']['ibase']['timeformat'])}"$/ }
    # ODBC
    if property['php_cfg']['odbc'].has_key?('default_db')
      its(:content) { should match /^odbc.default_db = #{e(property['php_cfg']['odbc']['default_db'])}$/ }
    end
    if property['php_cfg']['odbc'].has_key?('default_user')
      its(:content) { should match /^odbc.default_user = #{e(property['php_cfg']['odbc']['default_user'])}$/ }
    end
    if property['php_cfg']['odbc'].has_key?('default_pw')
      its(:content) { should match /^odbc.default_pw = #{e(property['php_cfg']['odbc']['default_pw'])}$/ }
    end
    if property['php_cfg']['odbc'].has_key?('default_cursortype')
      its(:content) { should match /^odbc.default_cursortype = #{e(property['php_cfg']['odbc']['default_cursortype'])}$/ }
    end
    its(:content) { should match /^odbc.allow_persistent = #{e(property['php_cfg']['odbc']['allow_persistent'])}$/ }
    its(:content) { should match /^odbc.check_persistent = #{e(property['php_cfg']['odbc']['check_persistent'])}$/ }
    its(:content) { should match /^odbc.max_persistent = #{e(property['php_cfg']['odbc']['max_persistent'])}$/ }
    its(:content) { should match /^odbc.max_links = #{e(property['php_cfg']['odbc']['max_links'])}$/ }
    its(:content) { should match /^odbc.defaultlrl = #{e(property['php_cfg']['odbc']['defaultlrl'])}$/ }
    its(:content) { should match /^odbc.defaultbinmode = #{e(property['php_cfg']['odbc']['defaultbinmode'])}$/ }
    # OpenSSL
    if property['php_cfg'].has_key?('openssl')
      if property['php_cfg']['openssl'].has_key?('cafile')
        its(:content) { should match /^openssl.cafile = #{e(property['php_cfg']['openssl']['cafile'])}$/ }
      end
      if property['php_cfg']['openssl'].has_key?('capath')
        its(:content) { should match /^openssl.capath = #{e(property['php_cfg']['openssl']['capath'])}$/ }
      end
    end
    # PDO(MySQL)
    its(:content) { should match /^pdo_mysql.cache_size = #{e(property['php_cfg']['pdo_mysql']['cache_size'])}$/ }
    its(:content) { should match /^pdo_mysql.default_socket = #{e(property['php_cfg']['pdo_mysql']['default_socket'])}$/ }
    # PDO(ODBC)
    if property['php_cfg'].has_key?('pdo_odbc')
      if property['php_cfg']['pdo_odbc'].has_key?('connection_pooling')
        its(:content) { should match /^pdo_odbc.connection_pooling = #{e(property['php_cfg']['pdo_odbc']['connection_pooling'])}$/ }
      end
      if property['php_cfg']['pdo_odbc'].has_key?('db2_instance_name')
        its(:content) { should match /^pdo_odbc.db2_instance_name = #{e(property['php_cfg']['pdo_odbc']['db2_instance_name'])}$/ }
      end
    end
    # PCRE
    if property['php_cfg'].has_key?('pcre')
      if property['php_cfg']['pcre'].has_key?('backtrack_limit')
        its(:content) { should match /^pcre.backtrack_limit = #{e(property['php_cfg']['pcre']['backtrack_limit'])}$/ }
      end
      if property['php_cfg']['pcre'].has_key?('recursion_limit')
        its(:content) { should match /^pcre.recursion_limit = #{e(property['php_cfg']['pcre']['recursion_limit'])}$/ }
      end
      if property['php_cfg']['pcre'].has_key?('jit')
        its(:content) { should match /^pcre.jit = #{e(property['php_cfg']['pcre']['jit'])}$/ }
      end
    end
    # Phar
    if property['php_cfg'].has_key?('phar')
      if property['php_cfg']['phar'].has_key?('readonly')
        its(:content) { should match /^phar.readonly = #{e(property['php_cfg']['phar']['readonly'])}$/ }
      end
      if property['php_cfg']['phar'].has_key?('require_hash')
        its(:content) { should match /^phar.require_hash = #{e(property['php_cfg']['phar']['require_hash'])}$/ }
      end
      if property['php_cfg']['phar'].has_key?('cache_list')
        its(:content) { should match /^phar.cache_list = #{e(property['php_cfg']['phar']['cache_list'])}$/ }
      end
    end
    # zlib
    its(:content) { should match /^zlib.output_compression = #{e(property['php_cfg']['zlib']['output_compression'])}$/ }
    if property['php_cfg']['zlib'].has_key?('output_compression_level')
      its(:content) { should match /^zlib.output_compression_level = #{e(property['php_cfg']['zlib']['output_compression_level'])}$/ }
    end
    if property['php_cfg']['zlib'].has_key?('output_handler')
      its(:content) { should match /^zlib.output_handler = #{e(property['php_cfg']['zlib']['output_handler'])}$/ }
    end
    # SQLite3
    if property['php_cfg'].has_key?('sqlite3') && property['php_cfg']['sqlite3'].has_key?('extension_dir')
      its(:content) { should match /^sqlite3.extension_dir = #{e(property['php_cfg']['sqlite3']['extension_dir'])}$/ }
    end
    # intl
    if property['php_cfg'].has_key?('intl')
      if property['php_cfg']['intl'].has_key?('default_locale')
        its(:content) { should match /^intl.default_locale = #{e(property['php_cfg']['intl']['default_locale'])}$/ }
      end
      if property['php_cfg']['intl'].has_key?('error_level')
        its(:content) { should match /^intl.error_level = #{e(property['php_cfg']['intl']['error_level'])}$/ }
      end
      if property['php_cfg']['intl'].has_key?('use_exceptions')
        its(:content) { should match /^intl.use_exceptions = #{e(property['php_cfg']['intl']['use_exceptions'])}$/ }
      end
    end
    # MySQLi
    its(:content) { should match /^mysqli.max_persistent = #{e(property['php_cfg']['mysqli']['max_persistent'])}$/ }
    if property['php_cfg']['mysqli'].has_key?('allow_local_infile')
      its(:content) { should match /^mysqli.allow_local_infile = #{e(property['php_cfg']['mysqli']['allow_local_infile'])}$/ }
    end
    its(:content) { should match /^mysqli.allow_persistent = #{e(property['php_cfg']['mysqli']['allow_persistent'])}$/ }
    its(:content) { should match /^mysqli.max_links = #{e(property['php_cfg']['mysqli']['max_links'])}$/ }
    its(:content) { should match /^mysqli.cache_size = #{e(property['php_cfg']['mysqli']['cache_size'])}$/ }
    its(:content) { should match /^mysqli.default_port = #{e(property['php_cfg']['mysqli']['default_port'])}$/ }
    its(:content) { should match /^mysqli.default_socket = #{e(property['php_cfg']['mysqli']['default_socket'])}$/ }
    its(:content) { should match /^mysqli.default_host = #{e(property['php_cfg']['mysqli']['default_host'])}$/ }
    its(:content) { should match /^mysqli.default_user = #{e(property['php_cfg']['mysqli']['default_user'])}$/ }
    its(:content) { should match /^mysqli.default_pw = #{e(property['php_cfg']['mysqli']['default_pw'])}$/ }
    its(:content) { should match /^mysqli.reconnect = #{e(property['php_cfg']['mysqli']['reconnect'])}$/ }
    # MySQLnd
    its(:content) { should match /^mysqlnd.collect_statistics = #{e(property['php_cfg']['mysqlnd']['collect_statistics'])}$/ }
    its(:content) { should match /^mysqlnd.collect_memory_statistics = #{e(property['php_cfg']['mysqlnd']['collect_memory_statistics'])}$/ }
    if property['php_cfg']['mysqlnd'].has_key?('debug')
      its(:content) { should match /^mysqlnd.debug = #{e(property['php_cfg']['mysqlnd']['debug'])}$/ }
    end
    if property['php_cfg']['mysqlnd'].has_key?('log_mask')
      its(:content) { should match /^mysqlnd.log_mask = #{e(property['php_cfg']['mysqlnd']['log_mask'])}$/ }
    end
    if property['php_cfg']['mysqlnd'].has_key?('mempool_default_size')
      its(:content) { should match /^mysqlnd.mempool_default_size = #{e(property['php_cfg']['mysqlnd']['mempool_default_size'])}$/ }
    end
    if property['php_cfg']['mysqlnd'].has_key?('net_cmd_buffer_size')
      its(:content) { should match /^mysqlnd.net_cmd_buffer_size = #{e(property['php_cfg']['mysqlnd']['net_cmd_buffer_size'])}$/ }
    end
    if property['php_cfg']['mysqlnd'].has_key?('net_read_buffer_size')
      its(:content) { should match /^mysqlnd.net_read_buffer_size = #{e(property['php_cfg']['mysqlnd']['net_read_buffer_size'])}$/ }
    end
    if property['php_cfg']['mysqlnd'].has_key?('net_read_timeout')
      its(:content) { should match /^mysqlnd.net_read_timeout = #{e(property['php_cfg']['mysqlnd']['net_read_timeout'])}$/ }
    end
    if property['php_cfg']['mysqlnd'].has_key?('sha256_server_public_key')
      its(:content) { should match /^mysqlnd.sha256_server_public_key = #{e(property['php_cfg']['mysqlnd']['sha256_server_public_key'])}$/ }
    end
    # mcrypt
    if property['php_cfg'].has_key?('mcrypt')
      if property['php_cfg']['mcrypt'].has_key?('algorithms_dir')
        its(:content) { should match /^mcrypt.algorithms_dir = #{e(property['php_cfg']['mcrypt']['algorithms_dir'])}$/ }
      end
      if property['php_cfg']['mcrypt'].has_key?('modes_dir')
        its(:content) { should match /^mcrypt.modes_dir = #{e(property['php_cfg']['mcrypt']['modes_dir'])}$/ }
      end
    end
    # filter
    if property['php_cfg'].has_key?('filter')
      if property['php_cfg']['filter'].has_key?('default')
        its(:content) { should match /^filter.default = #{e(property['php_cfg']['filter']['default'])}$/ }
      end
      if property['php_cfg']['filter'].has_key?('default_flags')
        its(:content) { should match /^filter.default_flags = #{e(property['php_cfg']['filter']['default_flags'])}$/ }
      end
    end
    # pgsql
    its(:content) { should match /^pgsql.allow_persistent = #{e(property['php_cfg']['pgsql']['allow_persistent'])}$/ }
    its(:content) { should match /^pgsql.auto_reset_persistent = #{e(property['php_cfg']['pgsql']['auto_reset_persistent'])}$/ }
    its(:content) { should match /^pgsql.max_persistent = #{e(property['php_cfg']['pgsql']['max_persistent'])}$/ }
    its(:content) { should match /^pgsql.max_links = #{e(property['php_cfg']['pgsql']['max_links'])}$/ }
    its(:content) { should match /^pgsql.ignore_notice = #{e(property['php_cfg']['pgsql']['ignore_notice'])}$/ }
    its(:content) { should match /^pgsql.log_notice = #{e(property['php_cfg']['pgsql']['log_notice'])}$/ }
    # GD
    if property['php_cfg'].has_key?('gd') && property['php_cfg']['gd'].has_key?('jpeg_ignore_warning')
      its(:content) { should match /^gd.jpeg_ignore_warning = #{e(property['php_cfg']['gd']['jpeg_ignore_warning'])}$/ }
    end
    # exif
    if property['php_cfg'].has_key?('exif')
      if property['php_cfg']['exif'].has_key?('encode_unicode')
        its(:content) { should match /^exif.encode_unicode = #{e(property['php_cfg']['exif']['encode_unicode'])}$/ }
      end
      if property['php_cfg']['exif'].has_key?('decode_unicode_motorola')
        its(:content) { should match /^exif.decode_unicode_motorola = #{e(property['php_cfg']['exif']['decode_unicode_motorola'])}$/ }
      end
      if property['php_cfg']['exif'].has_key?('decode_unicode_intel')
        its(:content) { should match /^exif.decode_unicode_intel = #{e(property['php_cfg']['exif']['decode_unicode_intel'])}$/ }
      end
      if property['php_cfg']['exif'].has_key?('encode_jis')
        its(:content) { should match /^exif.encode_jis = #{e(property['php_cfg']['exif']['encode_jis'])}$/ }
      end
      if property['php_cfg']['exif'].has_key?('decode_jis_motorola')
        its(:content) { should match /^exif.decode_jis_motorola = #{e(property['php_cfg']['exif']['decode_jis_motorola'])}$/ }
      end
      if property['php_cfg']['exif'].has_key?('decode_jis_intel')
        its(:content) { should match /^exif.decode_jis_intel = #{e(property['php_cfg']['exif']['decode_jis_intel'])}$/ }
      end
    end
    # tidy
    if property['php_cfg']['tidy'].has_key?('default_config')
      its(:content) { should match /^tidy.default_config = #{e(property['php_cfg']['tidy']['default_config'])}$/ }
    end
    its(:content) { should match /^tidy.clean_output = #{e(property['php_cfg']['tidy']['clean_output'])}$/ }
    # iconv
    if property['php_cfg'].has_key?('iconv')
      if property['php_cfg']['iconv'].has_key?('input_encoding')
        its(:content) { should match /^iconv.input_encoding = #{e(property['php_cfg']['iconv']['input_encoding'])}$/ }
      end
      if property['php_cfg']['iconv'].has_key?('internal_encoding')
        its(:content) { should match /^iconv.internal_encoding = #{e(property['php_cfg']['iconv']['internal_encoding'])}$/ }
      end
      if property['php_cfg']['iconv'].has_key?('output_encoding')
        its(:content) { should match /^iconv.output_encoding = #{e(property['php_cfg']['iconv']['output_encoding'])}$/ }
      end
    end
    # imagick
    if property['php_cfg'].has_key?('imagick')
      if property['php_cfg']['imagick'].has_key?('locale_fix')
        its(:content) { should match /^extra_parameters.imagick.locale_fix = #{e(property['php_cfg']['imagick']['locale_fix'])}$/ }
      end
      if property['php_cfg']['imagick'].has_key?('progress_monitor')
        its(:content) { should match /^extra_parameters.imagick.progress_monitor = #{e(property['php_cfg']['imagick']['progress_monitor'])}$/ }
      end
      if property['php_cfg']['imagick'].has_key?('skip_version_check')
        its(:content) { should match /^extra_parameters.imagick.skip_version_check = #{e(property['php_cfg']['imagick']['skip_version_check'])}$/ }
      end
    end
    # mbstring
    if property['php_cfg'].has_key?('mbstring')
      if property['php_cfg']['mbstring'].has_key?('language')
        its(:content) { should match /^mbstring.language = #{e(property['php_cfg']['mbstring']['language'])}$/ }
      end
      if property['php_cfg']['mbstring'].has_key?('internal_encoding')
        its(:content) { should match /^mbstring.internal_encoding = #{e(property['php_cfg']['mbstring']['internal_encoding'])}$/ }
      end
      if property['php_cfg']['mbstring'].has_key?('http_input')
        its(:content) { should match /^mbstring.http_input = #{e(property['php_cfg']['mbstring']['http_input'])}$/ }
      end
      if property['php_cfg']['mbstring'].has_key?('http_output')
        its(:content) { should match /^mbstring.http_output = #{e(property['php_cfg']['mbstring']['http_output'])}$/ }
      end
      if property['php_cfg']['mbstring'].has_key?('encoding_translation')
        its(:content) { should match /^mbstring.encoding_translation = #{e(property['php_cfg']['mbstring']['encoding_translation'])}$/ }
      end
      if property['php_cfg']['mbstring'].has_key?('detect_order')
        its(:content) { should match /^mbstring.detect_order = #{e(property['php_cfg']['mbstring']['detect_order'])}$/ }
      end
      if property['php_cfg']['mbstring'].has_key?('substitute_character')
        its(:content) { should match /^mbstring.substitute_character = #{e(property['php_cfg']['mbstring']['substitute_character'])}$/ }
      end
      if property['php_cfg']['mbstring'].has_key?('func_overload')
        its(:content) { should match /^mbstring.func_overload = #{e(property['php_cfg']['mbstring']['func_overload'])}$/ }
      end
      if property['php_cfg']['mbstring'].has_key?('strict_detection')
        its(:content) { should match /^mbstring.strict_detection = #{e(property['php_cfg']['mbstring']['strict_detection'])}$/ }
      end
      if property['php_cfg']['mbstring'].has_key?('http_output_conv_mimetype')
        its(:content) { should match /^mbstring.http_output_conv_mimetype = #{e(property['php_cfg']['mbstring']['http_output_conv_mimetype'])}$/ }
      end
    end
    # soap
    its(:content) { should match /^soap.wsdl_cache_enabled = #{e(property['php_cfg']['soap']['wsdl_cache_enabled'])}$/ }
    its(:content) { should match /^soap.wsdl_cache_dir = "#{e(property['php_cfg']['soap']['wsdl_cache_dir'])}"$/ }
    its(:content) { should match /^soap.wsdl_cache_ttl = #{e(property['php_cfg']['soap']['wsdl_cache_ttl'])}$/ }
    its(:content) { should match /^soap.wsdl_cache_limit = #{e(property['php_cfg']['soap']['wsdl_cache_limit'])}$/ }
    # LDAP
    its(:content) { should match /^ldap.max_links = #{e(property['php_cfg']['ldap']['max_links'])}$/ }
    # Assert
    if property['php_cfg'].has_key?('assert')
      if property['php_cfg']['assert'].has_key?('active')
        its(:content) { should match /^assert.active = #{e(property['php_cfg']['assert']['active'])}$/ }
      end
      if property['php_cfg']['assert'].has_key?('exception')
        its(:content) { should match /^assert.exception = #{e(property['php_cfg']['assert']['exception'])}$/ }
      end
      if property['php_cfg']['assert'].has_key?('warning')
        its(:content) { should match /^assert.warning = #{e(property['php_cfg']['assert']['warning'])}$/ }
      end
      if property['php_cfg']['assert'].has_key?('bail')
        its(:content) { should match /^assert.bail = #{e(property['php_cfg']['assert']['bail'])}$/ }
      end
      if property['php_cfg']['assert'].has_key?('callback')
        its(:content) { should match /^assert.callback = #{e(property['php_cfg']['assert']['callback'])}$/ }
      end
      if property['php_cfg']['assert'].has_key?('quiet_eval')
        its(:content) { should match /^assert.quiet_eval = #{e(property['php_cfg']['assert']['quiet_eval'])}$/ }
      end
    end
    # Opcache
    if property['php_cfg'].has_key?('opcache')
      if property['php_cfg']['opcache'].has_key?('enable')
        its(:content) { should match /^opcache.enable = #{e(property['php_cfg']['opcache']['enable'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('enable_cli')
        its(:content) { should match /^opcache.enable_cli = #{e(property['php_cfg']['opcache']['enable_cli'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('memory_consumption')
        its(:content) { should match /^opcache.memory_consumption = #{e(property['php_cfg']['opcache']['memory_consumption'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('interned_strings_buffer')
        its(:content) { should match /^opcache.interned_strings_buffer = #{e(property['php_cfg']['opcache']['interned_strings_buffer'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('max_accelerated_files')
        its(:content) { should match /^opcache.max_accelerated_files = #{e(property['php_cfg']['opcache']['max_accelerated_files'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('max_wasted_percentage')
        its(:content) { should match /^opcache.max_wasted_percentage = #{e(property['php_cfg']['opcache']['max_wasted_percentage'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('use_cwd')
        its(:content) { should match /^opcache.use_cwd = #{e(property['php_cfg']['opcache']['use_cwd'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('validate_timestamps')
        its(:content) { should match /^opcache.validate_timestamps = #{e(property['php_cfg']['opcache']['validate_timestamps'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('revalidate_freq')
        its(:content) { should match /^opcache.revalidate_freq = #{e(property['php_cfg']['opcache']['revalidate_freq'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('revalidate_path')
        its(:content) { should match /^opcache.revalidate_path = #{e(property['php_cfg']['opcache']['revalidate_path'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('save_comments')
        its(:content) { should match /^opcache.save_comments = #{e(property['php_cfg']['opcache']['save_comments'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('fast_shutdown')
        its(:content) { should match /^opcache.fast_shutdown = #{e(property['php_cfg']['opcache']['fast_shutdown'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('enable_file_override')
        its(:content) { should match /^opcache.enable_file_override = #{e(property['php_cfg']['opcache']['enable_file_override'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('optimization_level')
        its(:content) { should match /^opcache.optimization_level = #{e(property['php_cfg']['opcache']['optimization_level'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('inherited_hack')
        its(:content) { should match /^opcache.inherited_hack = #{e(property['php_cfg']['opcache']['inherited_hack'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('dups_fix')
        its(:content) { should match /^opcache.dups_fix = #{e(property['php_cfg']['opcache']['dups_fix'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('blacklist_filename')
        its(:content) { should match /^opcache.blacklist_filename = #{e(property['php_cfg']['opcache']['blacklist_filename'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('max_file_size')
        its(:content) { should match /^opcache.max_file_size = #{e(property['php_cfg']['opcache']['max_file_size'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('consistency_checks')
        its(:content) { should match /^opcache.consistency_checks = #{e(property['php_cfg']['opcache']['consistency_checks'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('force_restart_timeout')
        its(:content) { should match /^opcache.force_restart_timeout = #{e(property['php_cfg']['opcache']['force_restart_timeout'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('error_log')
        its(:content) { should match /^opcache.error_log = #{e(property['php_cfg']['opcache']['error_log'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('log_verbosity_level')
        its(:content) { should match /^opcache.log_verbosity_level = #{e(property['php_cfg']['opcache']['log_verbosity_level'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('preferred_memory_model')
        its(:content) { should match /^opcache.preferred_memory_model = #{e(property['php_cfg']['opcache']['preferred_memory_model'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('protect_memory')
        its(:content) { should match /^opcache.protect_memory = #{e(property['php_cfg']['opcache']['protect_memory'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('file_update_protection')
        its(:content) { should match /^opcache.file_update_protection = #{e(property['php_cfg']['opcache']['file_update_protection'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('restrict_api')
        its(:content) { should match /^opcache.restrict_api = #{e(property['php_cfg']['opcache']['restrict_api'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('mmap_base')
        its(:content) { should match /^opcache.mmap_base = #{e(property['php_cfg']['opcache']['mmap_base'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('file_cache')
        its(:content) { should match /^opcache.file_cache = #{e(property['php_cfg']['opcache']['file_cache'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('file_cache_only')
        its(:content) { should match /^opcache.file_cache_only = #{e(property['php_cfg']['opcache']['file_cache_only'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('file_cache_consistency_checks')
        its(:content) { should match /^opcache.file_cache_consistency_checks = #{e(property['php_cfg']['opcache']['file_cache_consistency_checks'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('file_cache_fallback')
        its(:content) { should match /^opcache.file_cache_fallback = #{e(property['php_cfg']['opcache']['file_cache_fallback'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('huge_code_pages')
        its(:content) { should match /^opcache.huge_code_pages = #{e(property['php_cfg']['opcache']['huge_code_pages'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('validate_permission')
        its(:content) { should match /^opcache.validate_permission = #{e(property['php_cfg']['opcache']['validate_permission'])}$/ }
      end
      if property['php_cfg']['opcache'].has_key?('validate_root')
        its(:content) { should match /^opcache.validate_root = #{e(property['php_cfg']['opcache']['validate_root'])}$/ }
      end
    end
    if property['php_cfg'].has_key?('extra_parameters')
      property['php_cfg']['extra_parameters'].each do |section, settings|
        settings.each do |setting_name, setting_value|
          its(:content) { should match /^#{section}.#{setting_name} = #{e(setting_value)}$/ }
        end
      end
    end
  end
end
