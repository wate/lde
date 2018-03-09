# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

Vagrant.configure("2") do |config|
  # Load Vagrant config file
  vagrant_setting_file = File.expand_path(File.join(File.dirname(__FILE__), 'config.yml'))
  settings = YAML.load_file(vagrant_setting_file)
  # Merge Ansiblle host variables
  ansible_vars_file = File.expand_path(File.join(File.dirname(__FILE__), 'provision','host_vars', 'default.yml'))
  settings.merge!(YAML.load_file(ansible_vars_file));

  config.vm.box = settings['vagrant']['box'] || 'wate/centos-7'

  config.vm.network "private_network", ip: settings['vagrant']['ipaddress'] || '192.168.33.10'

  # port Forwarding
  if settings['vagrant'].has_key?('forwarded_ports')
    settings['vagrant']['forwarded_ports'].each do |forwarded_port|
      config.vm.network "forwarded_port",
        guest: forwarded_port['guest'] ,
        host: forwarded_port['host'] || forwarded_port['guest'] ,
        id: forwarded_port['id'] || nil
    end
  end
  # synced folders
  app_type = settings['app_type']
  synced_folder_args = [
    settings['vagrant']['synced_folder']['type'][app_type]['local'],
    settings['vagrant']['synced_folder']['type'][app_type]['remote']
  ]
  settings['vagrant']['synced_folder'].delete('type')
  unless settings['vagrant']['synced_folder'].empty?
    synced_folder_args.push(settings['vagrant']['synced_folder'].map{|k,v| [k.to_sym, v] }.to_h)
  end
  config.vm.send(:synced_folder, *synced_folder_args)

  vm_host_aliases = [
    settings['domain'],
    'www.' + settings['domain'],
    # phpMyAdmin
    'db.' + settings['domain'],
    # MailCatcher
    'mail.' + settings['domain'],
    # WWW SQL Designer
    'er.' + settings['domain'],
  ]
  # vagrant-hostsupdater
  plugin_setting = {}
  if settings['vagrant'].has_key?('plugin') and settings['vagrant']['plugin'].has_key?('hostsupdater')
    plugin_setting = config['vagrant']['plugin']['hostsupdater']
  end
  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.remove_on_suspend = plugin_setting.has_key?('remove_on_suspend') ? plugin_setting['remove_on_suspend'] : true
    config.hostsupdater.aliases = vm_host_aliases
  end
  # plugin vagrant-hostmanager
  plugin_setting = {}
  if settings['vagrant'].has_key?('plugin') and settings['vagrant']['plugin'].has_key?('hostmanager')
    plugin_setting = config['plugin']['hostmanager']
  end
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = plugin_setting.has_key?('enabled') ? plugin_setting['enabled'] : false
    config.hostmanager.manage_host = plugin_setting.has_key?('manage_host') ? plugin_setting['manage_host'] : true
    config.hostmanager.manage_guest = plugin_setting.has_key?('manage_guest') ? plugin_setting['manage_guest'] : true
    config.hostmanager.aliases = vm_host_aliases
  end

  # Provisioning
  if Vagrant::Util::Platform.windows? or settings['vagrant']['provisioner'] == 'ansible_local'
    config.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.provisioning_path = "/vagrant/provision"
    end
  else
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "provision/playbook.yml"
      ansible.config_file = "provision/ansible.cfg"
      ansible.groups = {
        "vagrant" => ["default"],
      }
    end
  end
  # VirtualBox settings
  config.vm.provider "virtualbox" do |vm|
    vm.name = settings['vagrant']['vm_name'] || settings['domain']
    vm.gui = settings['vagrant']['vm_gui'] || false
    vm.cpus = settings['vagrant']['vm_cpu'] || 1
    vm.memory = settings['vagrant']['vm_memory'] || 1024
  end
end
