apt_update 'update'

memcached_instance 'web_cache' do
  port 11_212
  udp_port 11_212
  memory 64
  action [:start, :enable]
end

user 'memcached_other_user'
user 'memcached_painful_cache'

memcached_instance 'backend_cache' do
  port 11_213
  udp_port 11_213
  memory 64
  ulimit 31_337
  threads 10
  user 'memcached_other_user'
  action [:start, :enable]
end

if Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
  memcached_instance_systemd 'painful_cache' do
    port 11_214
    udp_port 11_214
    memory 64
    ulimit 31_337
    threads 10
    user 'memcached_painful_cache'
    action [:start, :enable]
  end
else
  memcached_instance_sysv_init 'painful_cache' do
    port 11_214
    udp_port 11_214
    memory 64
    ulimit 31_337
    threads 10
    user 'memcached_painful_cache'
    action [:start, :enable]
  end
end
