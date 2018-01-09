#
# Cookbook:: memcached
# resource:: instance_sysv_init
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

provides :memcached_instance_sysv_init

provides :memcached_instance, os: 'linux'

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
    provider platform_sysv_init_class
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service memcached_instance_name do
    provider platform_sysv_init_class
    supports status: true
    action :stop
    only_if { ::File.exist?("/etc/init.d/#{memcached_instance_name}") }
  end
end

action :restart do
  service memcached_instance_name do
    provider platform_sysv_init_class
    supports restart: true, status: true
    action :restart
  end
end

action :enable do
  create_init

  service memcached_instance_name do
    provider platform_sysv_init_class
    supports status: true
    action :enable
    only_if { ::File.exist?("/etc/init.d/#{memcached_instance_name}") }
  end
end

action :disable do
  service memcached_instance_name do
    provider platform_sysv_init_class
    supports status: true
    action :disable
    only_if { ::File.exist?("/etc/init.d/#{memcached_instance_name}") }
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

    # the init script will not run without redhat-lsb packages
    package 'redhat-lsb-core' if platform_family?('fedora', 'rhel', 'amazon')

    # create the log file so we can write to it
    create_log_file

    # remove the debian defaults dir
    file '/etc/default/memcached' do
      action :delete
    end

    template "/etc/init.d/#{memcached_instance_name}" do
      mode '0755'
      source platform_family?('debian') ? 'init_sysv_debian.erb' : 'init_sysv.erb'
      cookbook new_resource.template_cookbook
      variables(
        lock_dir: lock_dir,
        instance: memcached_instance_name,
        ulimit: new_resource.ulimit,
        user: new_resource.user,
        binary_path: binary_path,
        cli_options: cli_options,
        log_file: log_file_name
      )
      notifies :restart, "service[#{memcached_instance_name}]", :immediately unless new_resource.no_restart
    end
  end
end
