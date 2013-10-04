require 'spec_helper'

describe 'memcached::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge(described_recipe) }

  it 'installs the libmemcache-dev package' do
    expect(chef_run).to install_package('libmemcache-dev')
  end

  context 'on rhel' do
    let(:chef_run) { ChefSpec::ChefRunner.new(platform: 'redhat', version: '6.3').converge(described_recipe) }
    let(:template) { chef_run.template('/etc/sysconfig/memcached') }

    it 'writes the /etc/sysconfig/memcached' do
      expect(template).to be
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
      expect(template.mode).to eq('0644')
    end

    it 'notifies the service to restart' do
      expect(template).to notify('service[memcached]', :restart)
    end
  end

  context 'on smartos' do
    let(:chef_run) { ChefSpec::ChefRunner.new(platform: 'smartos', version: 'joyent_20130111T180733Z').converge(described_recipe) }

    it 'enables the memcached service' do
      expect(chef_run).to set_service_to_start_on_boot('memcached')
    end
  end

  context 'on ubuntu' do
    let(:chef_run) { ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe) }
    let(:template) { chef_run.template('/etc/memcached.conf') }

    it 'writes the /etc/memcached.conf' do
      expect(template).to be
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
      expect(template.mode).to eq('0644')
    end

    it 'notifies the service to restart' do
      expect(template).to notify('service[memcached]', :restart)
    end
  end
end
