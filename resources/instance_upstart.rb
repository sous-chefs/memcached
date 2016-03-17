provides :memcached_instance, platform: 'ubuntu' do |node|
  node['platform_version'].to_f < 15.10
end

property :instance_name, String, name_property: true
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
    only_if { ::File.exist?("/etc/init/memcached_#{new_resource.instance_name}.conf") }
  end
end

action :restart do
  action_stop
  action_start
end

action :enable do
  service "memcached_#{new_resource.instance_name}" do
    supports status: true
    action :enable
    only_if { ::File.exist?("/etc/init/memcached_#{new_resource.instance_name}.conf") }
  end
end

action :disable do
  service "memcached_#{new_resource.instance_name}" do
    supports status: true
    action :disable
    only_if { ::File.exist?("/etc/init/memcached_#{new_resource.instance_name}.conf") }
  end
end

action_class.class_eval do
  def create_init
    include_recipe 'memcached::_package'

    template "/etc/init/memcached_#{new_resource.instance_name}.conf" do
      source 'init_upstart.erb'
      variables(
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
      cookbook 'memcached'
      notifies :restart, "service[memcached_#{instance_name}]", :immediately
      owner 'root'
      group 'root'
      mode '0644'
    end
  end
end
