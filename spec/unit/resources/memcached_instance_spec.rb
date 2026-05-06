# frozen_string_literal: true

require 'spec_helper'

describe 'memcached_instance' do
  step_into :memcached_instance, :memcached_instance_systemd, :memcached_install

  context 'on ubuntu 24.04' do
    platform 'ubuntu', '24.04'
    include_context 'memcached_stubs'

    context 'with default properties' do
      recipe do
        memcached_instance 'memcached'
      end

      it { is_expected.to install_package('memcached') }
      it { is_expected.to create_directory('/var/log/memcached').with(user: 'memcache', group: 'memcache') }
      it { is_expected.to_not stop_service('disable default memcached') }
      it { is_expected.to_not disable_service('disable default memcached') }

      %w(/etc/memcached.conf /etc/sysconfig/memcached /etc/default/memcached).each do |config_file|
        it { is_expected.to delete_file(config_file) }
      end

      it do
        is_expected.to create_systemd_unit('memcached.service').with(
          content: %r{ExecStart=/usr/bin/memcached -m 64 -u memcache -c 1024 -I 1m -U 11211 -p 11211 -l 0.0.0.0 -v}
        )
      end
    end

    context 'with start and enable actions' do
      recipe do
        memcached_instance 'web_cache' do
          port 11_212
          udp_port 11_212
          action [:create, :enable, :start]
        end
      end

      it { is_expected.to stop_service('disable default memcached') }
      it { is_expected.to disable_service('disable default memcached') }
      it { is_expected.to enable_service('memcached_web_cache') }
      it { is_expected.to start_service('memcached_web_cache') }
      it do
        is_expected.to create_systemd_unit('memcached_web_cache.service').with(
          content: %r{ExecStart=/usr/bin/memcached -m 64 -u memcache -c 1024 -I 1m -U 11212 -p 11212 -l 0.0.0.0 -v}
        )
      end
    end

    context 'with a socket and custom user' do
      recipe do
        memcached_instance 'socket' do
          socket '/var/run/memcached/socket'
          socket_mode '750'
          user 'custom_memcached'
          group 'custom_memcached'
          action :create
        end
      end

      it { is_expected.to create_group('custom_memcached') }
      it { is_expected.to create_user('custom_memcached').with(gid: 'custom_memcached') }
      it { is_expected.to create_directory('/var/log/memcached').with(user: 'memcache', group: 'memcache') }
      it { is_expected.to create_directory('/var/run/memcached').with(user: 'memcache', group: 'memcache') }
      it do
        is_expected.to create_systemd_unit('memcached_socket.service').with(
          content: %r{ExecStart=/usr/bin/memcached -m 64 -u custom_memcached -c 1024 -I 1m -s /var/run/memcached/socket -a 750 -v}
        )
      end
    end

    context 'with action delete' do
      recipe do
        memcached_instance 'web_cache' do
          action :delete
        end
      end

      it { is_expected.to stop_service('memcached_web_cache') }
      it { is_expected.to disable_service('memcached_web_cache') }
      it { is_expected.to delete_systemd_unit('memcached_web_cache.service') }
    end

    context 'with legacy systemd resource name' do
      recipe do
        memcached_instance_systemd 'backend_cache' do
          port 11_213
          udp_port 11_213
          threads 10
          ulimit 31_337
          action [:create, :enable, :start]
        end
      end

      it { is_expected.to enable_service('memcached_backend_cache') }
      it { is_expected.to start_service('memcached_backend_cache') }
      it do
        is_expected.to create_systemd_unit('memcached_backend_cache.service').with(
          content: %r{/usr/bin/memcached -m 64 -u memcache -c 1024 -I 1m -U 11213 -p 11213 -l 0.0.0.0 -v -t 10}
        )
      end
    end
  end

  context 'on almalinux 9' do
    platform 'almalinux', '9'
    include_context 'memcached_stubs'

    recipe do
      memcached_instance 'memcached'
    end

    it { is_expected.to create_user('memcached').with(gid: 'memcached') }
    it do
      is_expected.to create_systemd_unit('memcached.service').with(
        content: %r{ExecStart=/usr/bin/memcached -m 64 -u memcached -c 1024 -I 1m -U 11211 -p 11211 -l 0.0.0.0 -v}
      )
    end
  end
end
