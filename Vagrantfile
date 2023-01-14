# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # --------
  # Vagrant boxes
  # --------
  config.vm.box = ENV["VAGRANT_VM_IMAGE"] || "wate/debian-11"
  # config.vm.box_check_update = false


  # --------
  # SSH
  # --------
  config.ssh.forward_agent = true

  vagrantfile_dir = Dir.pwd
  until File.exists?(File.join(vagrantfile_dir, "Vagrantfile")) do
    vagrantfile_dir = File.dirname(vagrantfile_dir)
  end
  PROJECT_DIR = vagrantfile_dir
  # --------
  # Networking
  # --------
  forward_ports = ENV.select { |k,v| k.match?(/^VAGRANT_FORWARD_PORT_/) }
  if forward_ports.empty?
    forward_ports = {
      "VAGRANT_FORWARD_PORT_HTTP" => "80 -> 8080",
    }
  end
  forward_ports.each_value do |forward_port|
    forward_port_guest, forward_port_host = nil, nil
    if forward_port =~ /^\d+$/
      forward_port_guest = forward_port.to_i
      forward_port_host = forward_port_guest
    elsif forward_port =~ /^(\d+)\s*(?:-|=)>\s*(\d+)$/
      forward_port_guest = Regexp.last_match[1].to_i
      forward_port_host = Regexp.last_match[2].to_i
    end
    if forward_port_guest
      config.vm.network "forwarded_port", guest: forward_port_guest, host: forward_port_host
    end
  end
  VM_IP_ADDRESS = ENV["VAGRAN_IP_ADDRESS"] || "192.168.56.10"
  config.vm.network "private_network", ip: VM_IP_ADDRESS
  # --------
  # Plugin
  # --------
  ## plugin vagrant-vbguest
  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = false
  end
  vm_domain = ENV["VAGRAN_VM_DOMAIN"] || 'lde.local'
  vm_hosts = ENV.select { |k,v| k.match?(/^VAGRANT_VM_HOST_/) }
  if vm_hosts.empty?
    vm_hosts = {
      "@" => vm_domain,
      "cache" => "cache." + vm_domain
    }
  end
  vm_host_aliases = vm_hosts.values
  vm_host_aliases.uniq!
  ## plugin vagrant-hostsupdater
  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.remove_on_suspend = true
    config.hostsupdater.aliases = vm_host_aliases
  end
  ## plugin vagrant-hostmanager
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = false
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.aliases = vm_host_aliases
  end
  # --------
  # Synced Folders
  # --------
  config.vm.synced_folder ".", "/vagrant"
  sync_folders = ENV.select { |k,v| k.match?(/^VAGRANT_SYNC_FOLDER_/) }
  unless sync_folders.empty?
    sync_folders.each_value do |sync_folder|
      host_folder, guest_folder = sync_folder.split(/(?:-|=)>/, 2)
      if host_folder && guest_folder
        host_folder.strip!
        guest_folder.strip!
        config.vm.synced_folder host_folder, guest_folder
      end
    end
  end
  # --------
  # Providers
  # --------
  vm_name = File.basename(PROJECT_DIR)
  vm_name = ENV["VAGRANT_VM_NAME"] if ENV["VAGRANT_VM_NAME"]
  vm_cpu = ENV["VAGRANT_VM_CPU"] || 1
  vm_memory = ENV["VAGRANT_VM_MEMORY"] || 1024
  config.vm.provider "virtualbox" do |vm|
    vm.name = vm_name
    vm.cpus = vm_cpu.to_i
    vm.memory = vm_memory.to_i
    # vm.linked_clone = false
    # vm.customize ["modifyvm", :id, "--firmware", "efi"]
  end

  # --------
  # Provisioning
  # --------
  LDE_CONFIG_DIR = '.devcontainer'
  ANSIBLR_CONFIG_FILE = File.expand_path(File.join(LDE_CONFIG_DIR, 'ansible.cfg'))
  ANSIBLR_GALAXY_ROLE_FILE = File.expand_path(File.join(LDE_CONFIG_DIR, 'requirements.yml'))
  ansible_groups = {
    "vagrant" => ["default"],
  }
  ansible_extra_vars = {
    "domain" => vm_domain,
  }
  if File.exists?(File.join(LDE_CONFIG_DIR, "extra_vars.yml"))
    ansible_extra_vars.merge!(YAML.load_file(File.join(LDE_CONFIG_DIR, "extra_vars.yml")))
  end
  ansible_raw_arguments = []
  ansible_argument_env_vars = ENV.select { |k,v| k.match?(/^VAGRANT_ANSIBLE_RAW_ARGMENT_/) }
  unless ansible_argument_env_vars.empty?
    ansible_argument_env_vars.each_value do |env_var|
      ansible_raw_arguments.push(env_var)
    end
  end
  ansible_tags = nil
  ansible_tags_env_vars = ENV.select { |k,v| k.match?(/^VAGRANT_ANSIBLE_TAGS_/) }
  unless ansible_tags_env_vars.empty?
    ansible_tags = []
    ansible_tags_env_vars.each_value do |env_var|
      ansible_tags.push(env_var)
    end
  end
  ansible_skip_tags = []
  ansible_skip_tags_env_vars = ENV.select { |k,v| k.match?(/^VAGRANT_ANSIBLE_SKIP_TAGS_/) }
  unless ansible_skip_tags_env_vars.empty?
    ansible_skip_tags_env_vars.each_value do |env_var|
      ansible_skip_tags.push(env_var)
    end
  end
  ANSIBLR_PLAYBOOK = File.expand_path(File.join(LDE_CONFIG_DIR, 'playbook.yml'))
  if File.exists?(ANSIBLR_PLAYBOOK)
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = ANSIBLR_PLAYBOOK
      ansible.config_file = ANSIBLR_CONFIG_FILE if File.exists?(ANSIBLR_CONFIG_FILE)
      ansible.galaxy_role_file = ANSIBLR_GALAXY_ROLE_FILE if File.exists?(ANSIBLR_GALAXY_ROLE_FILE)
      ansible.galaxy_roles_path = ".vagrant/provisioners/ansible/roles"
      ansible.extra_vars = ansible_extra_vars
      ansible.tags = ansible_tags
      ansible.skip_tags = ansible_skip_tags
      ansible.raw_arguments = ansible_raw_arguments
      ansible.groups = ansible_groups
    end
  end
  ANSIBLR_USER_SETTING_PLAYBOOK = File.expand_path(File.join(LDE_CONFIG_DIR, 'my_env.yml'))
  if File.exists?(ANSIBLR_USER_SETTING_PLAYBOOK)
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = ANSIBLR_USER_SETTING_PLAYBOOK
      ansible.config_file = ANSIBLR_CONFIG_FILE if File.exists?(ANSIBLR_CONFIG_FILE)
      ansible.galaxy_roles_path = ".vagrant/provisioners/ansible/roles"
      ansible.extra_vars = ansible_extra_vars
      ansible.tags = ansible_tags
      ansible.skip_tags = ansible_skip_tags
      ansible.raw_arguments = ansible_raw_arguments
      ansible.groups = ansible_groups
    end
  end
  unless ENV.has_key?('VAGRANT_TREIGGER_DISABLE') || ENV.has_key?('VAGRANT_TREIGGER_DISABLE_PROVISION')
    config.trigger.after :provision do |trigger|
      trigger.info = "Restore Database(app_dev) Data"
      trigger.run_remote = {
        path: ".devcontainer/scripts/vagrant_afte_provision.sh"
      }
    end
  end
  unless ENV.has_key?('VAGRANT_TREIGGER_DISABLE') && ENV.has_key?('VAGRANT_TREIGGER_DISABLE_DESTROY')
    config.trigger.before :destroy do |trigger|
      trigger.info = "Backup Database(app_dev) Data"
      trigger.run_remote = {
        path: ".devcontainer/scripts/vagrant_befor_destroy.sh"
      }
    end
  end
end
