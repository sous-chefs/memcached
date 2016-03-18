require 'spec_helper'

describe 'memcached::default' do
  before do
    stub_command('getent passwd memcached').and_return(false)
    stub_command('getent passwd nobody').and_return(false)
    stub_command('getent passwd memcache').and_return(false)
    stub_command('dpkg -s memcached').and_return(true)
  end

  context 'on rhel' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'centos', version: '6.7').converge(described_recipe) }

    it 'creates memcached group' do
      expect(chef_run).to create_group('memcached')
    end

    let(:template) { chef_run.template('/etc/sysconfig/memcached') }

    it 'notifies the service to restart' do
      expect(template).to notify('service[memcached]').to(:restart)
    end
  end

  context 'on ubuntu' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe) }
    let(:template) { chef_run.template('/etc/memcached.conf') }

    it 'notifies the service to restart' do
      expect(template).to notify('service[memcached]').to(:restart)
    end

    it 'creates memcache group' do
      expect(chef_run).to create_group('memcache')
    end
  end
end
