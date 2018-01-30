def service_user
  value_for_platform_family(
    %w(suse fedora rhel amazon) => 'memcached',
    'debian' => 'memcache',
    'default' => 'nobody'
  )
end

def service_group
  value_for_platform_family(
    %w(suse fedora rhel amazon) => 'memcached',
    'debian' => 'memcache',
    'default' => 'nogroup'
  )
end

def binary_path
  new_resource.binary_path || value_for_platform_family(
    'suse' => '/usr/sbin/memcached',
    'default' => '/usr/bin/memcached'
  )
end

def lock_dir
  value_for_platform_family(
    %w(rhel fedora suse amazon) => '/var/lock/subsys',
    'default' => '/var/lock'
  )
end

# if the instance name is memcached don't spit out memcached_memcached
def memcached_instance_name
  new_resource.instance_name == 'memcached' ? 'memcached' : "memcached_#{new_resource.instance_name}"
end

def disable_default_memcached_instance
  return unless new_resource.disable_default_instance

  service 'disable default memcached' do
    service_name 'memcached'
    action [:stop, :disable]
    not_if { new_resource.instance_name == 'memcached' }
  end
end

def remove_default_memcached_configs
  return unless new_resource.remove_default_config

  %w(/etc/memcached.conf /etc/sysconfig/memcached /etc/default/memcached).each do |f|
    file f do
      action :delete
    end
  end
end

def cli_options
  options = "-m #{new_resource.memory} \
-U #{new_resource.udp_port} \
-p #{new_resource.port} \
-u #{new_resource.user} \
-l #{new_resource.listen} \
-c #{new_resource.maxconn} \
-I #{new_resource.max_object_size}"

  options << " -o #{new_resource.experimental_options.join(',')}" unless new_resource.experimental_options.empty?

  log_arg = ''
  case new_resource.log_level
  when 'info'
    log_arg = 'v'
  when 'debug'
    log_arg = 'vv'
  when 'trace'
    log_arg = 'vvv'
  end
  options << " -#{log_arg}"

  options << " -t #{new_resource.threads}" if new_resource.threads
  options << " #{new_resource.extra_cli_options.join(' ')}" unless new_resource.extra_cli_options.empty?
  options
end

def disable_legacy_runit_instance
  return unless ::File.exist?("/etc/sv/#{memcached_instance_name}/run")

  memcached_instance_runit memcached_instance_name do
    action :remove
  end
end

# choose the right platform init class
def platform_sysv_init_class
  value_for_platform_family(
    'debian' => Chef::Provider::Service::Init::Debian,
    'default' => Chef::Provider::Service::Init::Redhat
  )
end

def log_file_name
  File.join(node['memcached']['logfilepath'], "#{memcached_instance_name}.log")
end

def create_log_file
  file log_file_name do
    user service_user
    group service_group
    mode '0644'
  end
end
