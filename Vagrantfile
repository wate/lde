# -*- mode: ruby -*-
# vi: set ft=ruby :
require "yaml"

Vagrant.configure("2") do |config|
  # --------
  # Vagrant boxes
  # --------
  config.vm.box = ENV["VAGRANT_VM_IMAGE"] || "bento/debian-13"
  # config.vm.box_check_update = false

  # --------
  # SSH
  # --------
  config.ssh.forward_agent = true

  base_dir = Dir.pwd
  until File.exist?(File.join(base_dir, "Vagrantfile")) do
    base_dir = File.dirname(base_dir)
  end
  PROJECT_DIR = base_dir
  # --------
  # Networking
  # --------
  forward_ports = ENV.select { |k,v| k.match?(/^VAGRANT_FORWARD_PORT_/) }
  if forward_ports.empty?
    forward_ports = {
      "VAGRANT_FORWARD_PORT_HTTP" => "80 -> 8080",
      "VAGRANT_FORWARD_PORT_DB" => "3306 -> 3306",
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
  VM_IP_ADDRESS = ENV["VAGRANT_IP_ADDRESS"] || "192.168.56.10"
  config.vm.network "private_network", ip: VM_IP_ADDRESS
  # --------
  # Plugin
  # --------
  vm_domain = ENV["VAGRANT_VM_DOMAIN"] || "lde.local"
  vm_host_aliases = [
    vm_domain,
    "www." + vm_domain,
    "cache." + vm_domain,
    "mailpit." + vm_domain,
    "search." + vm_domain,
    "log." + vm_domain,
  ]
  vm_host_envs = ENV.select { |k,v| k.match?(/^VAGRANT_VM_HOST_/) }
  unless vm_host_envs.empty?
    vm_host_aliases.concat vm_host_envs.values
  end
  vm_host_aliases.uniq!
  ## plugin vagrant-hostsupdater
  if Vagrant.has_plugin?("vagrant-hostsupdater")
    config.hostsupdater.remove_on_suspend = true
    config.hostsupdater.aliases = vm_host_aliases
  end
  ## plugin vagrant-hostmanager
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = false
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.aliases = vm_host_aliases
  end
  # --------
  # Synced Folders
  # --------
  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777", "fmode=777"]
  sync_folders = ENV.select { |k,v| k.match?(/^VAGRANT_SYNC_FOLDER_/) }
  unless sync_folders.empty?
    sync_folders.each_value do |sync_folder|
      host_folder, guest_folder = sync_folder.split(/(?:-|=)>/, 2)
      if host_folder && guest_folder
        host_folder.strip!
        guest_folder.strip!
        config.vm.synced_folder host_folder, guest_folder, :mount_options => ["dmode=777", "fmode=777"]
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
  LDE_CONFIG_DIR = ".devcontainer"
  ## Ansible config path
  ANSIBLE_CONFIG_FILE = File.expand_path(File.join(LDE_CONFIG_DIR, "ansible.cfg"))
  ## Ansible playbook paths
  ANSIBLE_PLAYBOOK = File.expand_path(File.join(LDE_CONFIG_DIR, "playbook.yml"))
  ANSIBLE_CUSTOM_PLAYBOOK = File.expand_path(File.join(LDE_CONFIG_DIR, "custom.yml"))
  ANSIBLE_VERIFY_PLAYBOOK = File.expand_path(File.join(LDE_CONFIG_DIR, "verify.yml"))
  ANSIBLE_REPORT_PLAYBOOK = File.expand_path(File.join(LDE_CONFIG_DIR, "report.yml"))
  ## Ansible galaxy role file
  ANSIBLE_GALAXY_ROLE_FILE = File.expand_path(File.join(LDE_CONFIG_DIR, "requirements.yml"))
  ## Ansible roles path
  ANSIBLE_GALAXY_ROLES_PATH = File.join(".vagrant", "provisioners", "ansible", "roles")
  ansible_groups = {
    "vagrant" => ["default"],
  }
  ansible_extra_vars = {
    "domain" => vm_domain,
  }
  ansible_raw_arguments = []
  ansible_argument_env_vars = ENV.select { |k,v| k.match?(/^VAGRANT_ANSIBLE_RAW_ARGUMENT_/) }
  unless ansible_argument_env_vars.empty?
    ansible_argument_env_vars.each_value do |env_var|
      ansible_raw_arguments.push(env_var)
    end
  end
  ## Ansible roles update
  provision_role_update = !File.exist?(ANSIBLE_GALAXY_ROLES_PATH)
  ansible_provision_tags = []
  ansible_provision_skip_tags = []
  provision_config = nil
  provision_config_file_dirs = [".", LDE_CONFIG_DIR]
  provision_config_file_dirs.each do |target_dir|
    provision_config_file = File.expand_path(File.join(target_dir.to_s, "provision_config.yml"))
    if File.exist?(File.expand_path(provision_config_file))
      provision_config = YAML.load_file(provision_config_file)
      break
    end
  end
  if provision_config
    if provision_config.key?("role_update") && !provision_config["role_update"].nil?
      provision_role_update = provision_config["role_update"]
    end
    if provision_config.key?("extra_var") && !provision_config["extra_var"].nil?
      ansible_extra_vars.merge!(provision_config["extra_var"])
    end
    if provision_config.key?("pre_task") && !provision_config["pre_task"].nil?
      pre_task_setting = provision_config["pre_task"]
      if pre_task_setting.key?("update_cache") && !pre_task_setting["update_cache"].nil?
        ansible_extra_vars["pre_task_update_cache"] = pre_task_setting["update_cache"]
      end
      if pre_task_setting.key?("update_package") && !pre_task_setting["update_package"].nil?
        ansible_extra_vars["pre_task_update_package"] = pre_task_setting["update_package"]
      end
    end
    if provision_config.key?("tags") && !provision_config["tags"].nil?
      ansible_provision_tags = provision_config["tags"]
    end
    if provision_config.key?("skip_tags") && !provision_config["skip_tags"].nil?
      ansible_provision_skip_tags = provision_config["skip_tags"]
    end
    if provision_config.key?("raw_arguments") && !provision_config["raw_arguments"].nil?
      ansible_raw_arguments.concat(provision_config["raw_arguments"]).uniq!
    end
  end

  if File.exist?(ANSIBLE_PLAYBOOK)
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = ANSIBLE_PLAYBOOK
      ansible.config_file = ANSIBLE_CONFIG_FILE if File.exist?(ANSIBLE_CONFIG_FILE)
      ansible.galaxy_role_file = ANSIBLE_GALAXY_ROLE_FILE if File.exist?(ANSIBLE_GALAXY_ROLE_FILE) && provision_role_update
      ansible.galaxy_roles_path = ANSIBLE_GALAXY_ROLES_PATH
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = ansible_extra_vars if ansible_extra_vars.length > 0
      ansible.tags = ansible_provision_tags if ansible_provision_tags.length > 0
      ansible.skip_tags = ansible_provision_skip_tags if ansible_provision_skip_tags.length > 0
      ansible.raw_arguments = ansible_raw_arguments if ansible_raw_arguments.length > 0
      ansible.groups = ansible_groups
    end
  end
  if File.exist?(ANSIBLE_CUSTOM_PLAYBOOK)
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = ANSIBLE_CUSTOM_PLAYBOOK
      ansible.config_file = ANSIBLE_CONFIG_FILE if File.exist?(ANSIBLE_CONFIG_FILE)
      ansible.galaxy_roles_path = ANSIBLE_GALAXY_ROLES_PATH
      ansible.compatibility_mode = "2.0"
      ansible.extra_vars = ansible_extra_vars if ansible_extra_vars.length > 0
      ansible.tags = ansible_provision_tags if ansible_provision_tags.length > 0
      ansible.skip_tags = ansible_provision_skip_tags if ansible_provision_skip_tags.length > 0
      ansible.raw_arguments = ansible_raw_arguments if ansible_raw_arguments.length > 0
      ansible.groups = ansible_groups
    end
  end
  if File.exist?(ANSIBLE_VERIFY_PLAYBOOK)
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = ANSIBLE_VERIFY_PLAYBOOK
      ansible.config_file = ANSIBLE_CONFIG_FILE if File.exist?(ANSIBLE_CONFIG_FILE)
      ansible.compatibility_mode = "2.0"
      ansible.galaxy_roles_path = ".vagrant/provisioners/ansible/roles"
      ansible.extra_vars = ansible_extra_vars if ansible_extra_vars.length > 0
      ansible.tags = ansible_provision_tags if ansible_provision_tags.length > 0
      ansible.skip_tags = ansible_provision_skip_tags if ansible_provision_skip_tags.length > 0
      ansible.raw_arguments = ansible_raw_arguments if ansible_raw_arguments.length > 0
      ansible.groups = ansible_groups
    end
  end
  if File.exist?(ANSIBLE_VERIFY_PLAYBOOK)
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = ANSIBLE_REPORT_PLAYBOOK
      ansible.config_file = ANSIBLE_CONFIG_FILE if File.exist?(ANSIBLE_CONFIG_FILE)
      ansible.compatibility_mode = "2.0"
      ansible.galaxy_roles_path = ".vagrant/provisioners/ansible/roles"
      ansible.extra_vars = ansible_extra_vars if ansible_extra_vars.length > 0
      ansible.tags = ansible_provision_tags if ansible_provision_tags.length > 0
      ansible.skip_tags = ansible_provision_skip_tags if ansible_provision_skip_tags.length > 0
      ansible.raw_arguments = ansible_raw_arguments if ansible_raw_arguments.length > 0
      ansible.groups = ansible_groups
    end
  end

  TRIGGER_SCRIPT_DIR = ".devcontainer/vagrant_trigger"
  trigger_scripts = {
    "up_after.sh" => { event: :up, timing: :after },
    "provision_before.sh" => { event: :provision, timing: :before },
    "provision_after.sh" => { event: :provision, timing: :after },
    "halt_before.sh" => { event: :halt, timing: :before, on_error: :continue },
    "destroy_before.sh" => { event: :destroy, timing: :before, on_error: :continue }
  }
  trigger_scripts.each do |script, options|
    trigger_script_path = File.join(TRIGGER_SCRIPT_DIR, script)
    if File.exist?(trigger_script_path)
      config.trigger.send(options[:timing], options[:event]) do |trigger|
        trigger.info = "Run #{options[:timing]} #{options[:event]} task"
        trigger.run_remote = { path: trigger_script_path }
        trigger.on_error = options[:on_error] if options[:on_error]
      end
    end
  end
end
