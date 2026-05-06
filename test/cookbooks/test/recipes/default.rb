# frozen_string_literal: true

apt_update 'update' if platform_family?('debian')

memcached_instance 'memcached' do
  action [:create, :enable, :start]
end
