def service_user
  value_for_platform_family(
    %w(suse fedora rhel) => 'memcached',
    'debian' => 'memcache',
    'default' => 'nobody'
  )
end

def service_group
  value_for_platform_family(
    %w(suse fedora rhel) => 'memcached',
    'debian' => 'memcache',
    'default' => 'nogroup'
  )
end

# if the instance name is memcached don't spit out memcached_memcached
def memcached_instance_name
  new_resource.instance_name == 'memcached' ? 'memcached' : "memcached_#{new_resource.instance_name}"
end

def disable_default_memcached_instance
  service 'disable default memcached' do
    service_name 'memcached'
    action [:stop, :disable]
    only_if { new_resource.disable_default_instance && !new_resource.instance_name == 'memcached' }
  end
end

def remove_default_memcached_configs
  if new_resource.disable_default_instance
    file '/etc/memcached.conf' do
      action :delete
    end

    file '/etc/sysconfig/memcached' do
      action :delete
    end

    file '/etc/default/memcached' do
      action :delete
    end
  end
end
