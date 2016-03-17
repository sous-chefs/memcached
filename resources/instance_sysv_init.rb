provides :memcached_instance, platform_family: 'suse'
provides :memcached_instance, platform: 'amazon'

provides :memcached_instance, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
  node['platform_version'].to_f < 7.0
end

provides :memcached_instance, platform: 'debian' do |node|
  node['platform_version'].to_i < 8
end

property :instance_name, String, name_attribute: true
property :memory, [Integer, String], default: 64
property :port, [Integer, String], default: 11_211
property :udp_port, [Integer, String], default: 11_211
property :listen, String, default: '0.0.0.0'
property :maxconn, [Integer, String], default: 1024
property :user, String
property :threads, [Integer, String]
property :max_object_size, String, default: '1m'
property :experimental_options, Array, default: []
property :ulimit, [Integer, String]
property :template_cookbook, String, default: 'memcached'
property :disable_default_instance, [TrueClass, FalseClass], default: true

action :start do
  create_init

  service "memcached_#{new_resource.instance_name}" do
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service "memcached_#{new_resource.instance_name}" do
    supports status: true
    action :stop
    only_if { ::File.exist?("/etc/init.d/memcached_#{new_resource.instance_name}") }
  end
end

action :restart do
  action_stop
  action_start
end

action :enable do
  create_init

  service "memcached_#{instance_name}" do
    supports status: true
    action :enable
    only_if { ::File.exist?("/etc/init.d/memcached_#{new_resource.instance_name}") }
  end
end

action :disable do
  service "memcached_#{new_resource.instance_name}" do
    supports status: true
    action :disable
    only_if { ::File.exist?("/etc/init.d/memcached_#{new_resource.instance_name}") }
  end
end

action_class.class_eval do
  def create_init
    include_recipe 'memcached::package'

    # define the lock dir for RHEL vs. debian
    platform_lock_dir = value_for_platform_family(
      %w(rhel fedora suse) => '/var/lock/subsys',
      'debian' => '/var/lock',
      'default' => '/var/lock'
    )

    # the init script will not run without redhat-lsb packages
    if platform_family?('rhel')
      if node['platform_version'].to_i < 6.0
        package 'redhat-lsb'
      else
        package 'redhat-lsb-core'
      end
    end

    template "/etc/init.d/memcached_#{new_resource.instance_name}" do
      mode '0755'
      source 'init_sysv.erb'
      cookbook 'memcached'
      variables(
        lock_dir: platform_lock_dir,
        instance: new_resource.instance_name,
        memory:  new_resource.memory,
        port: new_resource.port,
        udp_port: new_resource.udp_port,
        listen: new_resource.listen,
        maxconn: new_resource.maxconn,
        user: service_user,
        threads: new_resource.threads,
        max_object_size: new_resource.max_object_size,
        experimental_options: new_resource.experimental_options,
        ulimit: new_resource.ulimit
      )
      notifies :restart, "service[memcached_#{instance_name}]", :immediately
    end
  end
end
