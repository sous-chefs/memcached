# frozen_string_literal: true

provides :memcached_instance
unified_mode true
provides :memcached_instance_systemd # legacy name

include Memcached::Helpers

property :instance_name, String, name_property: true
property :package_name, String, default: 'memcached'
property :package_version, String
property :install, [true, false], default: true
property :memory, [Integer, String], default: 64
property :port, [Integer, String], default: 11_211
property :udp_port, [Integer, String], default: 11_211
property :listen, String, default: '0.0.0.0'
property :socket, String, default: ''
property :socket_mode, String, default: ''
property :maxconn, [Integer, String], default: 1024
property :user, String, default: lazy { service_user }
property :group, String
property :binary_path, String
property :threads, [Integer, String]
property :max_object_size, String, default: '1m'
property :experimental_options, Array, default: []
property :extra_cli_options, Array, default: []
property :ulimit, [Integer, String], default: 1024
property :log_dir, String, default: '/var/log/memcached'
property :run_dir, String, default: '/var/run/memcached'
property :disable_default_instance, [true, false], default: true
property :remove_default_config, [true, false], default: true
property :no_restart, [true, false], default: false
property :log_level, String, equal_to: %w(info debug trace none), default: 'info'

default_action :create

action :create do
  create_instance
end

action :delete do
  delete_instance
end

action :remove do
  delete_instance
end

action :start do
  create_instance

  service memcached_instance_name do
    action :start
  end
end

action :stop do
  service memcached_instance_name do
    action :stop
  end
end

action :restart do
  service memcached_instance_name do
    action :restart
  end
end

action :disable do
  service memcached_instance_name do
    action :disable
  end
end

action :enable do
  create_instance

  service memcached_instance_name do
    action :enable
  end
end

action_class do
  include Memcached::Helpers

  def create_instance
    install_memcached if new_resource.install && !new_resource.binary_path

    # Disable the default memcached service to avoid port conflicts + wasted memory
    disable_default_memcached_instance

    # cleanup default configs to avoid confusion
    remove_default_memcached_configs

    # RHEL7 and Centos 7 do not support those additional security flags
    security_flags_support =
      unless platform_family?('rhel')
        <<-EOF.gsub(/^\s+/, '')
        RestrictNamespaces=true
        RestrictRealtime=true
        ProtectControlGroups=true
        ProtectKernelTunables=true
        ProtectKernelModules=true
        MemoryDenyWriteExecute=true
        EOF
      end

    service memcached_instance_name do
      action :nothing
    end

    systemd_unit "#{memcached_instance_name}.service" do
      content <<-EOF.gsub(/^ {6}/, '')
      [Unit]
      Description=memcached instance #{memcached_instance_name}
      After=network.target

      [Service]
      User=#{new_resource.user}
      LimitNOFILE=#{new_resource.ulimit}
      ExecStart=#{binary_path} #{cli_options}
      Restart=on-failure

      # Various security configurations from:
      # https://github.com/memcached/memcached/blob/master/scripts/memcached.service
      PrivateTmp=true
      ProtectSystem=full
      NoNewPrivileges=true
      PrivateDevices=true
      CapabilityBoundingSet=CAP_SETGID CAP_SETUID CAP_SYS_RESOURCE
      RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX
      #{security_flags_support}

      [Install]
      WantedBy=multi-user.target
      EOF
      notifies :restart, "service[#{memcached_instance_name}]", :immediately unless new_resource.no_restart
      action :create
    end
  end

  def install_memcached
    memcached_install new_resource.package_name do
      package_version new_resource.package_version
      user new_resource.user
      group service_group_name
      log_dir new_resource.log_dir
      run_dir new_resource.run_dir
      action :create
    end
  end

  def delete_instance
    service memcached_instance_name do
      action [:stop, :disable]
    end

    systemd_unit "#{memcached_instance_name}.service" do
      action :delete
    end
  end
end
