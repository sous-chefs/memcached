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
