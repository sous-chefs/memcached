require 'spec_helper'

describe 'memcached::default' do
  include_context 'memcached_stubs'

  context 'on rhel 7' do
    platform 'redhat', '7'
    step_into :memcached_instance

    it do
      is_expected.to start_memcached_instance('memcached').with(
        memory: 64,
        port: 11211,
        udp_port: 11211,
        listen: '0.0.0.0',
        maconn: nil,
        user: 'memcached',
        max_object_size: '1m',
        threads: nil,
        experimental_options: [],
        extra_cli_options: [],
        ulimit: 1024
      )
    end
    it { is_expected.to enable_memcached_instance('memcached') }
    it { is_expected.to start_service('memcached') }
    it { is_expected.to enable_service('memcached') }
    it { is_expected.to_not stop_service('disable default memcached') }
    it { is_expected.to_not disable_service('disable default memcached') }
    %w(/etc/memcached.conf /etc/sysconfig/memcached /etc/default/memcached).each do |f|
      it { is_expected.to delete_file f }
    end
    it { is_expected.to install_package('memcached').with(version: nil) }
    it { expect(chef_run).to create_group('memcached') }
    it do
      is_expected.to create_user('memcached').with(
        system: true,
        manage_home: false,
        gid: 'memcached',
        home: '/nonexistent',
        comment: 'Memcached',
        shell: '/bin/false'
      )
    end
    it { is_expected.to lock_user('memcached') }
    it do
      is_expected.to create_directory('/var/log/memcached').with(
        user: 'memcached',
        group: 'memcached',
        mode: '0755'
      )
    end
    it do
      is_expected.to create_directory('/var/run/memcached').with(
        user: 'memcached',
        group: 'memcached',
        mode: '0755'
      )
    end
    it do
      is_expected.to create_systemd_unit('memcached.service').with(
        content: <<-EOF.gsub(/^ {8}/, '')
        [Unit]
        Description=memcached instance memcached
        After=network.target

        [Service]
        User=memcached
        LimitNOFILE=1024
        ExecStart=/usr/bin/memcached -m 64 -u memcached -c 1024 -I 1m -U 11211 -p 11211 -l 0.0.0.0 -v
        Restart=on-failure

        # Various security configurations from:
        # https://github.com/memcached/memcached/blob/master/scripts/memcached.service
        PrivateTmp=true
        ProtectSystem=full
        NoNewPrivileges=true
        PrivateDevices=true
        CapabilityBoundingSet=CAP_SETGID CAP_SETUID CAP_SYS_RESOURCE
        RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX


        [Install]
        WantedBy=multi-user.target
        EOF
      )
    end
    it { expect(chef_run.systemd_unit('memcached.service')).to notify('service[memcached]').to(:restart).immediately }
  end

  context 'on ubuntu 18.04' do
    platform 'ubuntu', '18.04'
    step_into :memcached_instance

    it do
      is_expected.to start_memcached_instance('memcached').with(
        memory: 64,
        port: 11211,
        udp_port: 11211,
        listen: '0.0.0.0',
        maconn: nil,
        user: 'memcache',
        max_object_size: '1m',
        threads: nil,
        experimental_options: [],
        extra_cli_options: [],
        ulimit: 1024
      )
    end
    it { is_expected.to enable_memcached_instance('memcached') }
    it { is_expected.to start_service('memcached') }
    it { is_expected.to enable_service('memcached') }
    it { is_expected.to_not stop_service('disable default memcached') }
    it { is_expected.to_not disable_service('disable default memcached') }
    %w(/etc/memcached.conf /etc/sysconfig/memcached /etc/default/memcached).each do |f|
      it { is_expected.to delete_file f }
    end
    it { is_expected.to install_package('memcached').with(version: nil) }
    it { expect(chef_run).to create_group('memcache') }
    it do
      is_expected.to create_user('memcache').with(
        system: true,
        manage_home: false,
        gid: 'memcache',
        home: '/nonexistent',
        comment: 'Memcached',
        shell: '/bin/false'
      )
    end
    it { is_expected.to lock_user('memcache') }
    it do
      is_expected.to create_directory('/var/log/memcached').with(
        user: 'memcache',
        group: 'memcache',
        mode: '0755'
      )
    end
    it do
      is_expected.to create_directory('/var/run/memcached').with(
        user: 'memcache',
        group: 'memcache',
        mode: '0755'
      )
    end
    it do
      is_expected.to create_systemd_unit('memcached.service').with(
        content: <<-EOF.gsub(/^ {8}/, '')
        [Unit]
        Description=memcached instance memcached
        After=network.target

        [Service]
        User=memcache
        LimitNOFILE=1024
        ExecStart=/usr/bin/memcached -m 64 -u memcache -c 1024 -I 1m -U 11211 -p 11211 -l 0.0.0.0 -v
        Restart=on-failure

        # Various security configurations from:
        # https://github.com/memcached/memcached/blob/master/scripts/memcached.service
        PrivateTmp=true
        ProtectSystem=full
        NoNewPrivileges=true
        PrivateDevices=true
        CapabilityBoundingSet=CAP_SETGID CAP_SETUID CAP_SYS_RESOURCE
        RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX
        RestrictNamespaces=true
        RestrictRealtime=true
        ProtectControlGroups=true
        ProtectKernelTunables=true
        ProtectKernelModules=true
        MemoryDenyWriteExecute=true


        [Install]
        WantedBy=multi-user.target
        EOF
      )
    end
    it { expect(chef_run.systemd_unit('memcached.service')).to notify('service[memcached]').to(:restart).immediately }
  end
end
