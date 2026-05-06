# frozen_string_literal: true

provides :memcached_install
unified_mode true

include Memcached::Helpers

property :package_name, String, default: 'memcached'
property :package_version, String
property :user, String, default: lazy { service_user }
property :group, String, default: lazy { service_group }
property :log_dir, String, default: '/var/log/memcached'
property :run_dir, String, default: '/var/run/memcached'
property :manage_user, [true, false], default: true
property :manage_directories, [true, false], default: true

default_action :create

action :create do
  package new_resource.package_name do
    version new_resource.package_version if new_resource.package_version
    action :install
  end

  group new_resource.group do
    system true
    not_if "getent passwd #{new_resource.user}"
    only_if { new_resource.manage_user }
  end

  user new_resource.user do
    system true
    manage_home false
    gid new_resource.group
    home '/nonexistent'
    comment 'Memcached'
    shell '/bin/false'
    action [:create, :lock]
    only_if { new_resource.manage_user }
  end

  [new_resource.log_dir, new_resource.run_dir].each do |dir|
    directory dir do
      user new_resource.user
      group new_resource.group
      mode '0755'
      only_if { new_resource.manage_directories }
    end
  end
end

action :delete do
  [new_resource.run_dir, new_resource.log_dir].each do |dir|
    directory dir do
      recursive true
      action :delete
      only_if { new_resource.manage_directories }
    end
  end

  package new_resource.package_name do
    action :remove
  end
end
