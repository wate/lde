# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

Vagrant.configure("2") do |config|
  # Load config file
  config_file_path = File.expand_path(File.join(File.dirname(__FILE__), 'config.yml'))
  vagrant_config = YAML.load_file(config_file_path)

  config.vm.box = vagrant_config['box'] || 'wate/centos-7'

  config.vm.network "private_network", ip: vagrant_config['ipaddress'] || '192.168.33.10'

  # port Forwarding
  if vagrant_config.has_key?('forwarded_ports')
    vagrant_config['forwarded_ports'].each do |forwarded_port|
      config.vm.network "forwarded_port",
        guest: forwarded_port['guest'] ,
        host: forwarded_port['host'] || forwarded_port['guest'] ,
        id: forwarded_port['id'] || nil
    end
  end
  # synced folders
  config.vm.synced_folder "./", "/vagrant"

  vm_host_aliases = [
    vagrant_config['domain'],
    'www.' + vagrant_config['domain'],
    'db.' + vagrant_config['domain'],
    'mail.' + vagrant_config['domain'],
    'log.' + vagrant_config['domain'],
  ]
  # vagrant-hostsupdater
  plugin_config = {}
  if vagrant_config.has_key?('plugin') and vagrant_config['plugin'].has_key?('hostsupdater')
    plugin_config = vagrant_config['plugin']['hostsupdater']
  end
  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.remove_on_suspend = plugin_config.has_key?('remove_on_suspend') ? plugin_config['remove_on_suspend'] : true
    config.hostsupdater.aliases = vm_host_aliases
  end
  # plugin vagrant-hostmanager
  plugin_config = {}
  if vagrant_config.has_key?('plugin') and vagrant_config['plugin'].has_key?('hostmanager')
    plugin_config = vagrant_config['plugin']['hostmanager']
  end
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = plugin_config.has_key?('enabled') ? plugin_config['enabled'] : false
    config.hostmanager.manage_host = plugin_config.has_key?('manage_host') ? plugin_config['manage_host'] : true
    config.hostmanager.manage_guest = plugin_config.has_key?('manage_guest') ? plugin_config['manage_guest'] : true
    config.hostmanager.aliases = vm_host_aliases
  end

  # Provisioning
  if Vagrant::Util::Platform.windows?
    # config.vm.provision "ansible_local" do |ansible|
    #   ansible.playbook = "provision/playbook.yml"
    #   ansible.config_file = "provision/ansible.cfg"
    # end
  else
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "provision/playbook.yml"
      ansible.config_file = "provision/ansible.cfg"
    end
  end
  # Set VirtualBox setting
  config.vm.provider "virtualbox" do |v|
    v.gui = vagrant_config['vm_gui'] || false
    v.name = vagrant_config['vm_name'] || nil
    v.cpus = vagrant_config['vm_cpu'] || 1
    v.memory = vagrant_config['vm_memory'] || 1024
  end
end
