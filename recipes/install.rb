app_name = 'deploy'
release_file = Github.new('ritik02/Deploy').get_release_file
release_name = Github.new('ritik02/Deploy').get_release_name

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