# frozen_string_literal: true

require 'spec_helper'

describe 'memcached_install' do
  step_into :memcached_install

  context 'on ubuntu 24.04' do
    platform 'ubuntu', '24.04'
    include_context 'memcached_stubs'

    context 'with default properties' do
      recipe do
        memcached_install 'memcached'
      end

      it { is_expected.to install_package('memcached') }
      it { is_expected.to create_group('memcache').with(system: true) }
      it { is_expected.to create_user('memcache').with(system: true, manage_home: false, gid: 'memcache') }
      it { is_expected.to lock_user('memcache') }
      it { is_expected.to create_directory('/var/log/memcached').with(user: 'memcache', group: 'memcache', mode: '0755') }
      it { is_expected.to create_directory('/var/run/memcached').with(user: 'memcache', group: 'memcache', mode: '0755') }
    end

    context 'with a package version' do
      recipe do
        memcached_install 'memcached' do
          package_version '1.6.24-1build3'
        end
      end

      it { is_expected.to install_package('memcached').with(version: '1.6.24-1build3') }
    end

    context 'with action delete' do
      recipe do
        memcached_install 'memcached' do
          action :delete
        end
      end

      it { is_expected.to delete_directory('/var/run/memcached') }
      it { is_expected.to delete_directory('/var/log/memcached') }
      it { is_expected.to remove_package('memcached') }
    end
  end
end
