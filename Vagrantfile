# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

if Vagrant.has_plugin?('vagrant-vbguest')
  class GuestAdditionsFixer < VagrantVbguest::Installers::Ubuntu
    def install(opts=nil, &block)
      super
      communicate.sudo('([ -e /opt/VBoxGuestAdditions-4.3.10 ] && sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions) || true')
    end
  end
end

provider   = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
configfn   = Dir.glob('*/devstack.yaml', File::FNM_DOTMATCH)[0]
relbasedir = File.dirname(configfn)
vagrantdir = relbasedir == '..' ? '.' : 'vagrant'
cnf        = YAML::load(File.open(configfn))

local_configfn = Dir.glob('*/local_devstack.yaml', File::FNM_DOTMATCH)[0]
if local_configfn
  local_cnf      = YAML::load(File.open(local_configfn))
  cnf = cnf.merge(local_cnf)
end

Vagrant.configure("2") do |config|
  config.vm.box = cnf['box_name']
  config.vm.hostname = cnf['vhost']

  # Use vagrant-hostmanager if installed
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.include_offline = true
  end

  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.installer = GuestAdditionsFixer
  end

  if provider == :virtualbox
    config.vm.box_url = 'http://filedump.mayflower.de/baseboxes/ubuntu-14.04-puppet3.4.3-vbox4.3.10.box'
  elsif provider == :lxc
    config.vm.box_url = 'http://filedump.mayflower.de/baseboxes/ubuntu-14.04-puppet3.4.3-lxc.box'
  else
    puts 'Your Vagrant provider isn\'t supported!'
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
  end

  # Use vagrant-cachier if installed
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.auto_detect = true
  end

  # Install r10k using the shell provisioner and download the Puppet modules
  config.vm.provision :shell, :path => File.join(vagrantdir, 'puppet-bootstrap.sh')

  config.vm.synced_folder "#{relbasedir}/", cnf['path']
  config.vm.network :private_network, :ip => cnf['ip']

  config.vm.synced_folder relbasedir, '/vagrant'

  config.vm.provision :hostmanager if Vagrant.has_plugin?('vagrant-hostmanager')
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path    = File.join(vagrantdir, 'manifests')
    puppet.manifest_file     = 'ubuntu_devstack.pp'
    puppet.module_path       = ['modules', 'site'].map { |dir| File.join(vagrantdir, dir) }
    puppet.options           = '--verbose'
    puppet.hiera_config_path = File.join(vagrantdir, 'hiera.yaml')
  end
end
