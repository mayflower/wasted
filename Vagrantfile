# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

Vagrant.require_version ">= 1.5"

if Vagrant.has_plugin?('vagrant-vbguest')
  class GuestAdditionsFixer < VagrantVbguest::Installers::Ubuntu
    def install(opts=nil, &block)
      super
      communicate.sudo('([ -e /opt/VBoxGuestAdditions-4.3.10 ] && sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions) || true')
    end
  end
end

cnf = {}

configdir = Dir.glob('*/vagrant-cfg', File::FNM_DOTMATCH)[0]
configfn  = Dir.glob('*/devstack.yaml', File::FNM_DOTMATCH)[0]

if not configdir and not configfn
  abort 'Run vagrant/bootstrap.sh before running vagrant! (no devstack.yaml/vagrant-cfg exists)'
end

if configfn
  basedir    = File.absolute_path(File.dirname(configfn))
  vagrantdir = File.absolute_path(File.dirname(configfn)  == '..' ? '.' : 'vagrant')
  cnf        = cnf.merge(YAML::load(File.open(configfn)))

  local_configfn = Dir.glob('*/local_devstack.yaml', File::FNM_DOTMATCH)[0]
  if local_configfn
    cnf = cnf.merge(YAML::load(File.open(local_configfn)))
  end
end

if configdir
  basedir    = File.absolute_path(File.dirname(configdir))
  vagrantdir = File.absolute_path(File.dirname(configdir) == '..' ? '.' : 'vagrant')

  configs = [['common.yaml'], ['dev', 'common.yaml'], ['local', 'common.yaml']]
  configs.each do |config|
    configfn = File.join(configdir, *config)
    if File.exist?(configfn)
      cnf = cnf.merge(YAML::load(File.open(configfn)))
    end
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
    config.hostmanager.aliases = "hhvm.#{cnf['vhost']}"
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

  # Install r10k using the shell provisioner and download the Puppet modules
  config.vm.provision :shell, :path => File.join(vagrantdir, 'puppet-bootstrap.sh')

  config.vm.synced_folder "#{basedir}/", cnf['path'], :nfs => cnf['nfs']
  config.vm.network :private_network, :ip => cnf['ip']

  config.vm.synced_folder basedir, '/vagrant', :nfs => cnf['nfs']

  config.vm.provision :hostmanager if Vagrant.has_plugin?('vagrant-hostmanager')
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path    = File.join(vagrantdir, 'manifests')
    puppet.manifest_file     = 'ubuntu_devstack.pp'
    puppet.module_path       = ['modules', 'site'].map { |dir| File.join(vagrantdir, dir) }
    puppet.options           = ["--graphdir=/vagrant/vagrant/graphs --graph --environment dev"] if not ENV["VAGRANT_PUPPET_DEBUG"]
    puppet.options           = ["--debug --graphdir=/vagrant/vagrant/graphs --graph --environment dev"] if ENV["VAGRANT_PUPPET_DEBUG"]
    puppet.hiera_config_path = File.join(vagrantdir, 'hiera.yaml')
  end
end
