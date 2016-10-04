apt_update 'update' if platform_family?('debian')

memcached_instance 'web_cache' do
  port 11_212
  udp_port 11_212
  memory 64
  action [:start, :enable]
end

user 'memcached_other_user'

memcached_instance 'backend_cache' do
  port 11_213
  udp_port 11_213
  memory 64
  ulimit 31_337
  threads 10
  user 'memcached_other_user'
  action [:start, :enable]
end

memcached_instance_sysv_init 'painful_cache' do
  port 11_214
  udp_port 11_214
  memory 64
  ulimit 31_337
  threads 10
  user 'memcached_other_user'
  action [:start, :enable]
end
