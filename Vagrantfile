# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

Vagrant.require_version ">= 1.5"

vagrant_root = File.dirname(__FILE__)

if Vagrant.has_plugin?('vagrant-vbguest')
  class GuestAdditionsFixer < VagrantVbguest::Installers::Ubuntu
    def install(opts=nil, &block)
      super
      communicate.sudo('([ -e /opt/VBoxGuestAdditions-4.3.10 ] && sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions) || true')
    end
  end
end

cnf = {}

configdir = Dir.glob(File.join(vagrant_root, 'vagrant-cfg'), File::FNM_DOTMATCH)[0]

if not configdir
  abort 'Run vagrant/bootstrap.sh before running vagrant! (vagrant-cfg does not exit)'
end


basedir    = File.absolute_path(File.dirname(configdir))
vagrant_dir = 'vagrant'

configs = [['common.yaml'], ['dev', 'common.yaml'], ['local', 'common.yaml']]
configs.each do |config|
  configfn = File.join(configdir, *config)
  if File.exist?(configfn)
    cnf = cnf.merge(YAML::load(File.open(configfn)))
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = cnf['box_name']
  config.vm.hostname = cnf['vhost']

  # Use vagrant-hostmanager if installed
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.include_offline = true
    if cnf['vhost_aliases'].nil?
      cnf['vhost_aliases'] = ["hhvm.#{cnf['vhost']}"]
    end
    config.hostmanager.aliases = cnf['vhost_aliases']
  end

  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.installer = GuestAdditionsFixer
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # Use vagrant-cachier if installed
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.auto_detect = true
  end

  # If vagrant-proxyconf is installed and proxy is configured set this proxy.
  if Vagrant.has_plugin?('vagrant-proxyconf') && cnf.has_key?('proxy') && cnf.has_key?('no-proxy')
    if !cnf['proxy'].nil? && !cnf['proxy'].empty?
      config.proxy.http = cnf['proxy']
      config.proxy.https = cnf['proxy']
      if !cnf['no-proxy'].nil? && !cnf['no-proxy'].empty?
        config.proxy.no_proxy = cnf['no-proxy']
      end
    end
  end

  # Install r10k using the shell provisioner and download the Puppet modules
  config.vm.provision :shell, :path => File.join(vagrant_dir, 'puppet-bootstrap.sh')

  config.vm.synced_folder "#{basedir}/", cnf['path'], :nfs => cnf['nfs']
  config.vm.network :private_network, :ip => cnf['ip']

  config.vm.synced_folder basedir, '/vagrant', :nfs => cnf['nfs']

  config.vm.provision :hostmanager if Vagrant.has_plugin?('vagrant-hostmanager')
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path    = File.join(vagrant_dir, 'manifests')
    puppet.manifest_file     = 'site.pp'
    puppet.module_path       = ['modules', 'site'].map { |dir| File.join(vagrant_dir, dir) }
    puppet.options           = ["--graphdir=/vagrant/vagrant/graphs --graph --environment dev"] if not ENV["VAGRANT_PUPPET_DEBUG"]
    puppet.options           = ["--debug --graphdir=/vagrant/vagrant/graphs --graph --environment dev"] if ENV["VAGRANT_PUPPET_DEBUG"]
    puppet.hiera_config_path = File.join(vagrant_dir, 'hiera.yaml')
  end
end
