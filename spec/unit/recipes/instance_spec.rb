require 'spec_helper'

describe 'test::instance' do
  include_context 'memcached_stubs'

  context 'on rhel 7' do
    platform 'redhat', '7'
    step_into :memcached_instance, :memcached_instance_systemd

    it do
      is_expected.to start_memcached_instance('web_cache').with(
        memory: 64,
        port: 11212,
        udp_port: 11212,
        listen: '0.0.0.0',
        socket: '',
        socket_mode: '',
        maconn: nil,
        user: 'memcached',
        max_object_size: '1m',
        threads: nil,
        experimental_options: [],
        extra_cli_options: [],
        ulimit: 1024
      )
    end
    it do
      is_expected.to start_memcached_instance_systemd('backend_cache').with(
        memory: 64,
        port: 11213,
        udp_port: 11213,
        listen: '0.0.0.0',
        socket: '',
        socket_mode: '',
        maconn: nil,
        user: 'memcached_other_user',
        max_object_size: '1m',
        threads: 10,
        experimental_options: [],
        extra_cli_options: [],
        ulimit: 31337
      )
    end
    it do
      is_expected.to start_memcached_instance('painful_cache').with(
        memory: 64,
        port: 11214,
        udp_port: 11214,
        listen: '0.0.0.0',
        socket: '',
        socket_mode: '',
        maconn: nil,
        user: 'memcached_painful_cache',
        max_object_size: '1m',
        threads: 10,
        experimental_options: [],
        extra_cli_options: [],
        ulimit: 31337
      )
    end
    it do
      is_expected.to start_memcached_instance('socket').with(
        memory: 64,
        port: 11211,
        udp_port: 11211,
        listen: '0.0.0.0',
        socket: '/var/run/memcached/socket',
        socket_mode: '750',
        maconn: nil,
        user: 'memcached',
        max_object_size: '1m',
        threads: nil,
        experimental_options: [],
        extra_cli_options: [],
        ulimit: 1024
      )
    end
    it { is_expected.to enable_memcached_instance('web_cache') }
    it { is_expected.to enable_memcached_instance_systemd('backend_cache') }
    it { is_expected.to enable_memcached_instance('painful_cache') }
    it { is_expected.to enable_memcached_instance('socket') }
    it { is_expected.to stop_service('disable default memcached') }
    it { is_expected.to disable_service('disable default memcached') }
    it do
      is_expected.to create_systemd_unit('memcached_web_cache.service').with(
        content:
          %r{ExecStart=/usr/bin/memcached -m 64 -u memcached -c 1024 -I 1m -U 11212 -p 11212 -l 0.0.0.0 -v}
      )
    end
    it do
      is_expected.to create_systemd_unit('memcached_backend_cache.service').with(
        content:
          %r{/usr/bin/memcached -m 64 -u memcached_other_user -c 1024 -I 1m -U 11213 -p 11213 -l 0.0.0.0 -v -t 10}
      )
    end
    it do
      is_expected.to create_systemd_unit('memcached_painful_cache.service').with(
        content:
          %r{ExecStart=/usr/bin/memcached -m 64 -u memcached_painful_cache -c 1024 -I 1m -U 11214 -p 11214 -l 0.0.0.0 -v -t 10}
      )
    end
    it do
      is_expected.to create_systemd_unit('memcached_socket.service').with(
        content:
          %r{ExecStart=/usr/bin/memcached -m 64 -u memcached -c 1024 -I 1m -s /var/run/memcached/socket -a 750 -v}
      )
    end
  end

  context 'on ubuntu 18.04' do
    platform 'ubuntu', '18.04'
    step_into :memcached_instance, :memcached_instance_systemd

    it do
      is_expected.to start_memcached_instance('web_cache').with(
        memory: 64,
        port: 11212,
        udp_port: 11212,
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
    it do
      is_expected.to start_memcached_instance_systemd('backend_cache').with(
        memory: 64,
        port: 11213,
        udp_port: 11213,
        listen: '0.0.0.0',
        socket: '',
        socket_mode: '',
        maconn: nil,
        user: 'memcached_other_user',
        max_object_size: '1m',
        threads: 10,
        experimental_options: [],
        extra_cli_options: [],
        ulimit: 31337
      )
    end
    it do
      is_expected.to start_memcached_instance('painful_cache').with(
        memory: 64,
        port: 11214,
        udp_port: 11214,
        listen: '0.0.0.0',
        socket: '',
        socket_mode: '',
        maconn: nil,
        user: 'memcached_painful_cache',
        max_object_size: '1m',
        threads: 10,
        experimental_options: [],
        extra_cli_options: [],
        ulimit: 31337
      )
    end
    it do
      is_expected.to start_memcached_instance('socket').with(
        memory: 64,
        port: 11211,
        udp_port: 11211,
        listen: '0.0.0.0',
        socket: '/var/run/memcached/socket',
        socket_mode: '750',
        maconn: nil,
        user: 'memcache',
        max_object_size: '1m',
        threads: nil,
        experimental_options: [],
        extra_cli_options: [],
        ulimit: 1024
      )
    end
    it { is_expected.to enable_memcached_instance('web_cache') }
    it { is_expected.to enable_memcached_instance_systemd('backend_cache') }
    it { is_expected.to enable_memcached_instance('painful_cache') }
    it { is_expected.to enable_memcached_instance('socket') }
    it { is_expected.to stop_service('disable default memcached') }
    it { is_expected.to disable_service('disable default memcached') }
    it do
      is_expected.to create_systemd_unit('memcached_web_cache.service').with(
        content:
          %r{ExecStart=/usr/bin/memcached -m 64 -u memcache -c 1024 -I 1m -U 11212 -p 11212 -l 0.0.0.0 -v}
      )
    end
    it do
      is_expected.to create_systemd_unit('memcached_backend_cache.service').with(
        content:
          %r{/usr/bin/memcached -m 64 -u memcached_other_user -c 1024 -I 1m -U 11213 -p 11213 -l 0.0.0.0 -v -t 10}
      )
    end
    it do
      is_expected.to create_systemd_unit('memcached_painful_cache.service').with(
        content:
          %r{ExecStart=/usr/bin/memcached -m 64 -u memcached_painful_cache -c 1024 -I 1m -U 11214 -p 11214 -l 0.0.0.0 -v -t 10}
      )
    end
    it do
      is_expected.to create_systemd_unit('memcached_socket.service').with(
        content:
          %r{ExecStart=/usr/bin/memcached -m 64 -u memcache -c 1024 -I 1m -s /var/run/memcached/socket -a 750 -v}
      )
    end
  end
end
