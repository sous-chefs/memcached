apt_update 'update'

memcached_instance 'web_cache' do
  port 11_212
  udp_port 11_212
  memory 64
  action [:start, :enable]
end

user 'memcached_other_user'
user 'memcached_painful_cache'

memcached_instance_systemd 'backend_cache' do
  port 11_213
  udp_port 11_213
  memory 64
  ulimit 31_337
  threads 10
  user 'memcached_other_user'
  action [:start, :enable]
end

memcached_instance 'painful_cache' do
  port 11_214
  udp_port 11_214
  memory 64
  ulimit 31_337
  threads 10
  user 'memcached_painful_cache'
  action [:start, :enable]
end

memcached_instance 'socket' do
  socket '/var/run/memcached/socket'
  socket_mode '750'
  action [:start, :enable]
end
