root_password = node['database_root_password']
postgresql_server_version = node['postgres_server_version']
app_db_user = node['app_db_user']
app_db_password = node['app_db_password']
app_db_name = node['app_db_name']
db_user_address = node['db_user_address']
listen_address = node['listen_address']

config_hash = {
 listen_addresses: listen_address
}

postgresql_server_install 'install Postgresql Server' do
 action :install
end

postgresql_server_conf 'postgres_server_conf' do
 additional_config  config_hash
end

postgresql_server_install 'Setup postgresql server' do
  version postgresql_server_version
  password root_password
  action :create
end

postgresql_access 'create a superuser' do
  access_type 'local'
  access_db 'all'
  access_user 'postgres'
  access_addr nil
  access_method 'ident'
end

postgresql_user "#{app_db_user}" do
  user 'postgres'
  password app_db_password
  createdb true
  action :create
  sensitive false
end

postgresql_access 'give access to service user' do
  access_type 'host'
  access_db 'all'
  access_user app_db_user
  access_addr db_user_address
  access_method 'md5'
end

postgresql_database 'creating database' do
  database app_db_name
  template 'template0'
  encoding 'UNICODE'
  owner app_db_user
  action :create
end