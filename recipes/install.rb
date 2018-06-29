app_name = 'deploy'
release_file = Github.new('ritik02/Deploy').get_release_file
release_name = Github.new('ritik02/Deploy').get_release_name
script_location = '/home/deploy/deploy_start.sh'
command_name = 'bundle exec rails server'

apt_repository 'brightbox-ruby' do
  uri 'ppa:brightbox/ruby-ng'
end

apt_update 'update' do
  action :update
end

package %w(software-properties-common ruby2.5 nodejs build-essential zlib1g-dev liblzma-dev libpq-dev) do
  action :install
end

gem_package 'bundler'
gem_package 'rails'
gem_package 'rake'

user app_name do
  uid 1111
  home "/home/#{app_name}"
  manage_home true
  shell '/bin/bash'
  action :create
end

directory "/home/#{app_name}/#{release_name}" do
  owner app_name
  recursive true
  action :create
end

file "/etc/default/#{app_name}.conf" do
  owner app_name
  content node['environment_variables'].map {|k,v| "#{k}=#{v}"}.join("\n")
end

tar_extract release_file  do
  target_dir "/home/#{app_name}/#{release_name}"
  download_dir "/home/#{app_name}"
  user "#{app_name}"
end

template script_location do
  source "deploy_start.sh.erb"
  mode   "0755"
  owner app_name
  variables( app_name: app_name, release_name: release_name, command_name: command_name )
  notifies :restart, "service[godeploy]", :delayed
end

template "/etc/systemd/system/godeploy.service" do
  source "systemd.erb"
  owner app_name
  mode "00644"
  variables( app_name: app_name, app_home: app_name, script_location: script_location)
  notifies :run, "execute[systemctl-daemon-reload]", :immediately
  notifies :restart, "service[godeploy]", :delayed
end

execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
end

service "godeploy" do
  supports :status => true, :start => true, :restart => true, :stop => true
  provider Chef::Provider::Service::Systemd
  action [:enable, :restart]
end
