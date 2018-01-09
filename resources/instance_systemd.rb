#
# Cookbook:: memcached
# resource:: instance_systemd
#
# Author:: Tim Smith <tsmith@chef.io>
# Copyright:: 2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

provides :memcached_instance_systemd

provides :memcached_instance, os: 'linux' do |_node|
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
end

property :instance_name, String, name_property: true
property :memory, [Integer, String], default: 64
property :port, [Integer, String], default: 11_211
property :udp_port, [Integer, String], default: 11_211
property :listen, String, default: '0.0.0.0'
property :maxconn, [Integer, String], default: 1024
property :user, String, default: lazy { service_user }
property :binary_path, String
property :threads, [Integer, String]
property :max_object_size, String, default: '1m'
property :experimental_options, Array, default: []
property :extra_cli_options, Array, default: []
property :ulimit, [Integer, String], default: 1024
property :template_cookbook, String, default: 'memcached'
property :disable_default_instance, [true, false], default: true
property :remove_default_config, [true, false], default: true
property :no_restart, [true, false], default: false
property :log_level, String, default: 'info'

action :start do
  create_init

  service memcached_instance_name do
    provider Chef::Provider::Service::Systemd
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service memcached_instance_name do
    provider Chef::Provider::Service::Systemd
    supports status: true
    action :stop
    only_if { ::File.exist?("/etc/systemd/system/#{memcached_instance_name}.service") }
  end
end

action :restart do
  service memcached_instance_name do
    provider Chef::Provider::Service::Systemd
    supports restart: true, status: true
    action :restart
  end
end

action :disable do
  service memcached_instance_name do
    provider Chef::Provider::Service::Systemd
    supports status: true
    action :disable
    only_if { ::File.exist?("/etc/systemd/system/#{memcached_instance_name}.service") }
  end
end

action :enable do
  create_init

  service memcached_instance_name do
    provider Chef::Provider::Service::Systemd
    supports status: true
    action :enable
  end
end

action_class do
  def create_init
    include_recipe 'memcached::_package' unless new_resource.binary_path

    # remove any runit instances with the same name if they exist
    disable_legacy_runit_instance

    # Disable the default memcached service to avoid port conflicts + wasted memory
    disable_default_memcached_instance

    # cleanup default configs to avoid confusion
    remove_default_memcached_configs

    template "/etc/systemd/system/#{memcached_instance_name}.service" do
      source 'init_systemd.erb'
      variables(
        instance: memcached_instance_name,
        ulimit: new_resource.ulimit,
        user: new_resource.user,
        binary_path: binary_path,
        cli_options: cli_options
      )
      cookbook new_resource.template_cookbook
      notifies :run, 'execute[reload_unit_file]', :immediately
      notifies :restart, "service[#{memcached_instance_name}]", :immediately unless new_resource.no_restart
      owner 'root'
      group 'root'
      mode '0644'
    end

    # systemd is cool like this
    execute 'reload_unit_file' do
      command 'systemctl daemon-reload'
      action :nothing
    end
  end
end
