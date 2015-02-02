#
# Cookbook Name:: redmine
# Recipe:: redmine
#
# Copyright (C) 2015 Leonard TAVAE
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

group node['redmine']['group'] do
  action :create
end

user node['redmine']['admin'] do
  action :create
  gid node['redmine']['group']
  home '/home/' + node['redmine']['admin']
  shell '/bin/bash'
  password node['redmine']['password']
  supports manage_home: true
end

%w(git subversion imagemagick libmagickwand-dev ruby libruby ruby-dev).each do |package|
  package package do
    action :install
  end
end

bash 'Install bundler' do
  user 'root'
  code <<-EOH
  gem install bundler --no-ri --no-rdoc
  EOH
  not_if { ::File.exist?('/usr/local/bin/bundler') }
end

remote_file '/opt/redmine.tar.gz' do
  owner 'root'
  group 'root'
  mode '0644'
  source 'http://www.redmine.org/releases/redmine-' + node['redmine']['version'] + '.tar.gz'
  not_if { ::File.exist?('/opt/redmine.tar.gz') }
end

bash 'Untar redmine archive' do
  user 'root'
  cwd '/opt'
  code <<-EOH
  tar -xvzf redmine.tar.gz
  mv redmine-#{node['redmine']['version']} redmine
  chown -R #{node['redmine']['admin']}:#{node['redmine']['group']} redmine
  EOH
  not_if { ::File.exist?('/opt/redmine') }
end

template '/opt/redmine/config/database.yml' do
  source 'database.yml.erb'
  owner node['redmine']['admin']
  group node['redmine']['group']
  mode '0644'
  notifies :restart, 'service[apache2]'
end

template '/opt/redmine/config/configuration.yml' do
  source 'configuration.yml.erb'
  owner node['redmine']['admin']
  group node['redmine']['group']
  mode '0644'
  notifies :restart, 'service[apache2]'
end

bash 'Install gem dependencies' do
  user node['redmine']['admin']
  cwd '/opt/redmine'
  code <<-EOH
  bundle install --without development test --path vendor/
  bundle exec rake generate_secret_token
  RAILS_ENV=production bundle exec rake db:migrate
  REDMINE_LANG=#{node['redmine']['language']} RAILS_ENV=production bundle exec rake redmine:load_default_data
  EOH
  not_if { ::File.exist?('/opt/redmine/vendor/ruby') }
end

directory '/opt/git' do
  owner node['redmine']['admin']
  group node['redmine']['group']
  mode '0755'
  action :create
end

directory '/opt/svn' do
  owner node['redmine']['admin']
  group node['redmine']['group']
  mode '0755'
  action :create
end

git '/opt/redmine/public/themes/redmine-pixo-theme' do
  repository 'https://github.com/Pixopat/redmine-pixo-theme.git'
  reference 'master'
  user node['redmine']['admin']
  group node['redmine']['group']
  action :sync
  not_if { ::File.exist?('/opt/redmine/public/themes/redmine-pixo-theme') }
end

node.set['passenger']['root_path'] = '/var/lib/gems/1.9.1/gems/passenger-4.0.53'
node.set['passenger']['ruby_bin'] = '/usr/bin/ruby1.9.1'
include_recipe 'passenger_apache2'

web_app 'redmine' do
  docroot '/opt/redmine/public'
  server_name node['redmine']['domain_name']
  rails_env 'production'
  cookbook 'apache2'
end
