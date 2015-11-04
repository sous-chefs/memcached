require 'spec_helper'

describe 'memcached::default' do
  before do
    stub_command('getent passwd memcached').and_return(false)
    stub_command('getent passwd nobody').and_return(false)
    stub_command('getent passwd memcache').and_return(false)
    stub_command('dpkg -s memcached').and_return(true)
  end

  context 'on rhel' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'redhat', version: '6.3').converge(described_recipe) }

    it 'creates memcached group' do
      expect(chef_run).to create_group('memcached')
    end

    let(:template) { chef_run.template('/etc/sysconfig/memcached') }

    it 'writes the /etc/sysconfig/memcached' do
      expect(template).to be
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
      expect(template.mode).to eq('0644')
    end

    it 'notifies the service to restart' do
      expect(template).to notify('service[memcached]').to(:restart)
    end
  end

  context 'on smartos' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'smartos', version: 'joyent_20130111T180733Z').converge(described_recipe) }

    it 'enables the memcached service' do
      expect(chef_run).to enable_service('memcached')
    end

    it 'creates nogroup group' do
      expect(chef_run).to create_group('nogroup')
    end
  end

  context 'on ubuntu' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe) }
    let(:template) { chef_run.template('/etc/memcached.conf') }

    it 'writes the /etc/memcached.conf' do
      expect(template).to be
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
      expect(template.mode).to eq('0644')
    end

    it 'notifies the service to restart' do
      expect(template).to notify('service[memcached]').to(:restart)
    end

    it 'creates memcache group' do
      expect(chef_run).to create_group('memcache')
    end
  end
end
