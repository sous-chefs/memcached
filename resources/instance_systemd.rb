provides :memcached_instance, platform: 'fedora'

provides :memcached_instance, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
  node['platform_version'].to_f >= 7.0
end

provides :memcached_instance, platform: 'debian' do |node|
  node['platform_version'].to_i >= 8
end

provides :memcached_instance, platform: 'ubuntu' do |node|
  node['platform_version'].to_f >= 15.10
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
property :remove_default_config, [TrueClass, FalseClass], default: true

action :start do
  create_init

  service memcached_instance_name do
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service memcached_instance_name do
    supports status: true
    action :stop
    only_if { ::File.exist?("/lib/systemd/system/#{memcached_instance_name}.service") }
  end
end

action :restart do
  action_stop
  action_start
end

action :disable do
  service memcached_instance_name do
    supports status: true
    action :disable
    only_if { ::File.exist?("/lib/systemd/system/#{memcached_instance_name}.service") }
  end
end

action :enable do
  create_init

  service memcached_instance_name do
    supports status: true
    action :enable
    only_if { ::File.exist?("/lib/systemd/system/#{memcached_instance_name}.service") }
  end
end

action_class.class_eval do
  def create_init
    include_recipe 'memcached::_package'

    # Disable the default memcached service to avoid port conflicts + wasted memory
    disable_default_memcached_instance

    # cleanup default configs to avoid confusion
    remove_default_memcached_configs

    template "/lib/systemd/system/#{memcached_instance_name}.service" do
      source 'init_systemd.erb'
      variables(
        instance: memcached_instance_name,
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
      cookbook 'memcached'
      notifies :restart, "service[#{memcached_instance_name}]", :immediately
      owner 'root'
      group 'root'
      mode '0644'
    end
  end
end
