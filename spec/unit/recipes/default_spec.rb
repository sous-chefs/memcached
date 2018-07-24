require 'spec_helper'

describe 'memcached::default' do
  before do
    stub_command('getent passwd memcached').and_return(false)
    stub_command('getent passwd nobody').and_return(false)
    stub_command('getent passwd memcache').and_return(false)
    stub_command('dpkg -s memcached').and_return(true)
  end

  context 'on rhel 6' do
    let(:chef_run) { ChefSpec::ServerRunner.new(step_into: ['memcached_instance'], platform: 'centos', version: '6.9').converge(described_recipe) }

    it 'installs redhat-lsb package' do
      expect(chef_run).to install_package('redhat-lsb-core')
    end

    it 'installs memcached package' do
      expect(chef_run).to install_package('memcached')
    end

    it 'creates memcached user' do
      expect(chef_run).to create_user('memcached')
    end

    it 'creates memcached group' do
      expect(chef_run).to create_group('memcached')
    end

    it 'templates /etc/init.d/memcached' do
      expect(chef_run).to create_template('/etc/init.d/memcached')
    end

    it 'creates log file' do
      expect(chef_run).to create_file('/var/log/memcached/memcached.log')
    end
  end

  context 'on ubuntu' do
    let(:chef_run) { ChefSpec::ServerRunner.new(step_into: ['memcached_instance'], platform: 'ubuntu', version: '14.04').converge(described_recipe) }

    it 'installs memcached package' do
      expect(chef_run).to install_package('memcached')
    end

    it 'creates memcache group' do
      expect(chef_run).to create_group('memcache')
    end

    it 'deletes /etc/default/memcached' do
      expect(chef_run).to delete_file('/etc/default/memcached')
    end

    it 'creates log file' do
      expect(chef_run).to create_file('/var/log/memcached/memcached.log')
    end
  end
end
