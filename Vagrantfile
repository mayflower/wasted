# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

Vagrant.require_version ">= 1.7"

Vagrant.configure("2") do |wasted|
  config = load_config Dir.glob("*/vagrant-cfg", File::FNM_DOTMATCH).first

  ##
  # set the name of the basebox and the hostname
  #
  wasted.vm.box = config.fetch("box_name", "mayflower/trusty64-puppet3")
  wasted.vm.hostname = config.fetch("vhost", "wasted.dev")

  ##
  # configure certain plugins, if installed:
  # - hostmanager updates the hostsfile with hostnames, aliases
  # - proxyconf enables http(s) proxying
  # - cachier sets up cache buckets for package managers like apt
  #
  if Vagrant.has_plugin?("vagrant-hostmanager")
    wasted.hostmanager.enabled = true
    wasted.hostmanager.manage_host = (not File.exist?("/etc/NIXOS"))
    wasted.hostmanager.include_offline = true
    wasted.hostmanager.aliases = config.fetch("vhost_aliases", [])
  end

  if Vagrant.has_plugin?("vagrant-proxyconf")
    wasted.proxy.http = wasted.proxy.https = config.fetch("proxy", nil)
    wasted.proxy.no_proxy = config.fetch("no-proxy", nil)
  end

  wasted.cache.scope = :box if Vagrant.has_plugin?("vagrant-cachier")

  ##
  # set up the mount points
  #
  wasted.vm.synced_folder "#{config["dirs"]["base"]}/", config.fetch("path", "/var/www"), :nfs => config.fetch("nfs", false)
  wasted.vm.synced_folder config["dirs"]["base"], "/vagrant", :nfs => config.fetch("nfs", false)

  ##
  # configure the providers:
  # - set box name, cpu count, memory and other parameters
  # - disable nfs for lxc provider
  #
  wasted.vm.provider :virtualbox do |box, override|
    box.name = wasted.vm.hostname
    box.cpus = config.fetch("box_cpus", 2)
    box.memory = config.fetch("box_memory", 1024)
    box.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    override.vm.network :private_network, :ip => config.fetch("ip", "10.11.12.13")
  end

  wasted.vm.provider :lxc do |box, override|
    override.vm.synced_folder "#{config["dirs"]["base"]}/", config.fetch("path", "/var/www"), :nfs => false
    override.vm.synced_folder config["dirs"]["base"], "/vagrant", :nfs => false
  end

  ##
  # configure the provisioners:
  # - bootstrap installs basic dependencies and puppet modules
  # - site installs required software and configures the system
  #
  wasted.vm.provision :puppet do |puppet|
    puppet.manifest_file  = "bootstrap.pp"
    puppet.manifests_path = File.join(config["dirs"]["vagrant"], "manifests")
  end

  wasted.vm.provision :puppet do |puppet|
    puppet.manifest_file     = "site.pp"
    puppet.manifests_path    = File.join(config["dirs"]["vagrant"], "manifests")
    puppet.hiera_config_path = File.join(config["dirs"]["vagrant"], "hiera.yaml")
    puppet.module_path       = ["modules", "site"].map { |dir| File.join(config["dirs"]["vagrant"], dir) }
    puppet.options           = ["--graphdir=/vagrant/vagrant/graphs" "--graph", "--environment=dev"]
    puppet.options.unshift("--debug") if ENV["VAGRANT_PUPPET_DEBUG"]
  end
end

##
# loads and merges the configuration from various sources
#  returns the final configuration as hash
#
def load_config (dir = nil, config = {})
  abort "Run `./vagrant/bootstrap.sh` before running vagrant!" if dir.nil?

  # find and save important directories
  config["dirs"] = {
    "config"  => dir,
    "base"    => File.absolute_path(File.dirname(dir)),
    "vagrant" => File.absolute_path(File.dirname(dir) == ".." ? "." : "vagrant"),
  }

  # descends on the config hierarchy and merges provided settings
  [["common.yaml"], ["dev", "common.yaml"], ["local", "common.yaml"]]
    .map { |dir| File.join(config["dirs"]["config"], *dir) }
    .select { |file| File.exist?(file) }
    .each { |file| config.merge!(YAML::load(File.open(file))) }

  return config
end
