include_recipe 'memcached::default'

# m = resources('service[memcached]')
# m.action :stop

memcached_instance 'myproj' do
  port   11_212
  memory 128
end
