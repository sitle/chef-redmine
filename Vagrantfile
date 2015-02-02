# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'redmine-berkshelf'
  config.omnibus.chef_version = '11.16.4'
  config.vm.box = 'debian-7-chef'
  config.vm.box_url = 'http://bit.ly/dsi-debian-7-box'
  config.vm.network :private_network, ip: '172.28.128.3'
  config.berkshelf.enabled = true

  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.auto_detect = true
    config.cache.scope = :box
  end
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.hostmanager.aliases = %w(local.dev redmine.dev)

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      redmine: {
        version: '2.6.1',
        language: 'fr',
        domain_name: 'redmine.dev',
        mysql_root_pw: 'password',
        apps: 'redmine',
        admin: 'redmine',
        password: 'password',
        db_server: 'localhost',
        apps_server: 'localhost',
        group: 'redmine'
      }
    }

    chef.run_list = [
      'recipe[redmine::database]',
      'recipe[redmine::apps]'
    ]
  end
end
