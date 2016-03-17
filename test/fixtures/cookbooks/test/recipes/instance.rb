memcached_instance 'web_cache' do
  port 11_212
  memory 128
end

memcached_instance 'backend_cache' do
  port 11_213
  memory 128
end
