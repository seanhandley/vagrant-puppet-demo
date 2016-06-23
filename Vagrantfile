# -*- mode: ruby -*-
# vi: set ft=ruby :
# Ensure everyone is running a consistent vagrant version

Vagrant.require_version '~> 1.7.2'

Vagrant.configure('2') do |config|
  # base box and URL where to get it if not present
  config.vm.box = "lucid64"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

  # Virtualbox Provider
  config.vm.provider 'virtualbox' do |virtualbox, override|
    virtualbox.cpus   = 2
    virtualbox.memory = 2000
    virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # Use landrush for DNS resolution
  config.landrush.enabled = true
  config.landrush.tld = 'vagrant.devel'

  # config for the appserver box
  config.vm.define "appserver" do |app|
    app.vm.network 'forwarded_port', guest: 80,
                                    host: 8080,
                                    protocol: 'tcp'
    app.vm.host_name = "appserver01.vagrant.devel"
    app.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "appserver.pp"
    end
  end

  # config for the dbserver box
  config.vm.define "dbserver" do |db|
    db.vm.host_name = "dbserver01.vagrant.devel"
    db.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "dbserver.pp"
    end
  end

end