# Redmine

This cookbook install and configure [redmine](http://www.redmine.org/).

## Supported Platforms

* Debian 7 only.

## Attributes

* default['redmine']['version'] = '2.6.1'
* default['redmine']['language'] = 'fr'
* default['redmine']['domain_name'] = 'redmine.dev'
* default['redmine']['mysql_root_pw'] = 'password'
* default['redmine']['apps'] = 'redmine'
* default['redmine']['admin'] = 'redmine'
* default['redmine']['password'] = 'password'
* default['redmine']['db_server'] = 'localhost'
* default['redmine']['apps_server'] = 'localhost'
* default['redmine']['group'] = 'redmine'

## Usage

Include `redmine` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[redmine::database]",
    "recipe[redmine::apps]"
  ]
}
```

## Evaluation/Development

### Prerequisite

* chefdk - chef developers only ([https://downloads.chef.io/chef-dk/](https://downloads.chef.io/chef-dk/))
* vagrant ([https://www.vagrantup.com/](https://www.vagrantup.com/))
* vagrant plugins :
  * vagrant-cachier : ```vagrant plugin install vagrant-cachier```
  * vagrant-omnibus : ```vagrant plugin install vagrant-omnibus```
  * vagrant-hostmanager : ```vagrant plugin install vagrant-hostmanager```
  * vagrant-berkshelf : ```vagrant plugin install vagrant-berkshelf```
* virtualbox ([https://www.virtualbox.org/](https://www.virtualbox.org/))

### Provisionning

#### Evaluation

After installing all the prerequisite, you can edit attributes in ```Vagrantfile``` then :

```
git clone https://github.com/sitle/chef-redmine.git
cd chef-redmine
vagrant up
```

Note : You can, then, access to it (http://redmine.dev - admin/admin).

#### Development

After installing all the prerequisite, you can edit attributes in ```.kitchen.yml``` then :

```
git clone https://github.com/sitle/chef-redmine.git
cd chef-redmine
kitchen converge default
```

Note : You can, then, access to it (http://redmine.dev - admin/admin).

## License and Authors

```
Copyright 2015 Léonard TAVAE

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

Authors :

* Léonard TAVAE (<leonard.tavae@informatique.gov.pf>)