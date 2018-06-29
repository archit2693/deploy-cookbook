app_name = 'Deploy'
release_file = Github.new('ritik02/Deploy').get_release_file
release_name = Github.new('ritik02/Deploy').get_release_name

apt_repository 'brightbox-ruby' do
  uri 'ppa:brightbox/ruby-ng'
end

apt_update 'update' do
  action :update
end