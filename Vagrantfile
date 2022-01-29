# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

Vagrant.configure("2") do |config|
  # Load Ansiblle host variable file
  ansible_vars_file = File.expand_path(File.join(File.dirname(__FILE__), 'provision', 'group_vars', 'all.yml'))
  settings = YAML.load_file(ansible_vars_file)
  # Merge Vagrant config file
  vagrant_setting_file = File.expand_path(File.join(File.dirname(__FILE__), 'config.yml'))
  settings.merge!(YAML.load_file(vagrant_setting_file));

  config.vm.box = settings['vagrant']['box'] || 'wate/debian-11'

  config.vm.network "private_network", ip: settings['vagrant']['ipaddress'] || '192.168.56.10'

  # port Forwarding
  if settings['vagrant'].key?('forwarded_ports')
    settings['vagrant']['forwarded_ports'].each do |forwarded_port|
      config.vm.network "forwarded_port",
        guest: forwarded_port['guest'] ,
        host: forwarded_port['host'] || forwarded_port['guest'] ,
        id: forwarded_port['id'] || nil
    end
  end

  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = false
  end

  # Merge Ansible Extra Variable file
  extra_var_file = File.expand_path(File.join(File.dirname(__FILE__), 'extra_vars.yml'))
  ansible_custom_vars = {}
  if File.exists?(extra_var_file)
    extra_vars = YAML.load_file(extra_var_file)
    if extra_vars.is_a?(Hash)
      ansible_custom_vars = extra_vars
    end
  end
  settings['domain'] = ansible_custom_vars['domain'] if ansible_custom_vars.key?('domain')
  settings['app_type'] = ansible_custom_vars['app_type'] if ansible_custom_vars.key?('app_type')

  # synced folders
  synced_folders = settings['vagrant']['synced_folders'];
  if settings.key?('app_type') && settings['vagrant_synced_folder_types'].key?(settings['app_type'])
    synced_folders.push settings['vagrant_synced_folder_types'][settings['app_type']]
  end
  synced_folders.each do |synced_folder_setting|
    synced_folder_args = [
      synced_folder_setting['local'],
      synced_folder_setting['remote']
    ]
    synced_folder_options = settings['vagrant_synced_folder_default_options'].dup
    synced_folder_setting.delete('local')
    synced_folder_setting.delete('remote')
    unless synced_folder_setting.empty?
      synced_folder_options.merge!(synced_folder_setting);
    end
    # 共有ディレクトリの設定オプションを引数に追加
    synced_folder_args.push(synced_folder_options.map{|k,v| [k.to_sym, v] }.to_h)
    config.vm.send(:synced_folder, *synced_folder_args)
  end

  vm_host_aliases = [
    settings['domain'],
    'www.' + settings['domain'],
    # phpMyAdmin
    'db.' + settings['domain'],
    # MailCatcher
    'mailhog.' + settings['domain'],
    # redis or memcached admin tool
    'cache.' + settings['domain'],
  ]

  if settings['vagrant'].key?('append_vm_hosts')
    vm_host_aliases += settings['vagrant']['append_vm_hosts']
  end
  vm_host_aliases.uniq!

  # vagrant-hostsupdater
  plugin_setting = {}
  if settings['vagrant'].key?('plugin') and settings['vagrant']['plugin'].key?('hostsupdater')
    plugin_setting = config['vagrant']['plugin']['hostsupdater']
  end

  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.remove_on_suspend = plugin_setting.key?('remove_on_suspend') ? plugin_setting['remove_on_suspend'] : true
    config.hostsupdater.aliases = vm_host_aliases
  end
  # plugin vagrant-hostmanager
  plugin_setting = {}
  if settings['vagrant'].key?('plugin') and settings['vagrant']['plugin'].key?('hostmanager')
    plugin_setting = config['plugin']['hostmanager']
  end
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = plugin_setting.key?('enabled') ? plugin_setting['enabled'] : false
    config.hostmanager.manage_host = plugin_setting.key?('manage_host') ? plugin_setting['manage_host'] : true
    config.hostmanager.manage_guest = plugin_setting.key?('manage_guest') ? plugin_setting['manage_guest'] : true
    config.hostmanager.aliases = vm_host_aliases
  end
  # Provisioning
  ansible_extra_vars = {
    'domain' => settings['domain'],
    'php_version' => settings['php_version'],
    'doc_root_suffix' => settings['doc_root_suffix'],
  }
  unless ansible_custom_vars.empty?()
    ansible_extra_vars.merge!(ansible_custom_vars);
  end

  if Vagrant::Util::Platform.windows? or settings['vagrant']['provisioner'] == 'ansible_local'
    # Change Ansible global setting (on windows use)
    # https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-world-writable-dir
    config.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "provision/ansible_local_provisioner_init.yml"
    end
    config.vm.provision "ansible_local" do |ansible|
      ansible_extra_vars['vagrant_provisioner'] = 'ansible_local'
      ansible.playbook = "playbook.yml"
      ansible.provisioning_path = "/vagrant/provision"
      ansible.extra_vars = ansible_extra_vars
      if settings['vagrant'].key?('provision_only_tags')
        ansible.tags = settings['vagrant']['provision_only_tags']
      end
      if settings['vagrant'].key?('provision_skip_tags')
        ansible.skip_tags = settings['vagrant']['provision_skip_tags']
      end
    end
  else
    config.vm.provision "ansible" do |ansible|
      ansible_extra_vars['vagrant_provisioner'] = 'ansible'
      ansible.playbook = "provision/playbook.yml"
      ansible.extra_vars = ansible_extra_vars
      ansible.groups = {
        "vagrant" => ["default"],
      }
      if settings['vagrant'].key?('provision_only_tags')
        ansible.tags = settings['vagrant']['provision_only_tags']
      end
      # ansible.raw_arguments = ['--diff']
      if settings['vagrant'].key?('provision_skip_tags')
        ansible.skip_tags = settings['vagrant']['provision_skip_tags']
      end
    end
  end
  ansible_post_task_file = File.expand_path(File.join(File.dirname(__FILE__), 'post_task.sh'))
  if File.exists?(ansible_post_task_file)
    config.vm.provision "shell", path: "post_task.sh"
  end
  # VirtualBox settings
  config.vm.provider "virtualbox" do |vm|
    vm.name = settings['vagrant']['vm_name'] || settings['domain']
    vm.gui = settings['vagrant']['vm_gui'] || false
    vm.cpus = settings['vagrant']['vm_cpu'] || 1
    vm.memory = settings['vagrant']['vm_memory'] || 1024
  end
end
