memcached_instance 'test' do
  ##could either use node[:ipaddress] or one from the ohai attribute
  bind_ip "127.0.0.1"
  port "11211"
  max_connections 4096
  cachesize 4096
end
