memcached_instance 'web_cache' do
  port 11_212
  memory 128
  action [:start, :enable]
end

user 'memcached_other_user'

memcached_instance 'backend_cache' do
  port 11_213
  memory 128
  ulimit 31_337
  threads 10
  user 'memcached_other_user'
  action [:start, :enable]
end
