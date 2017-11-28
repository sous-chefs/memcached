apt_update 'update'

include_recipe 'runit::default' # installs runit

memcached_instance_runit 'legacy_web_cache' do
  port 11_212
  memory 64
  action [:start, :enable]
end

memcached_instance_runit 'legacy_frontend_cache' do
  port 11_213
  memory 64
  action [:create] # legacy action from < 3.0 cookbook
end
