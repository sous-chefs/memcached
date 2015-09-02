require 'spec_helper'

describe_recipe 'memcached::default' do
  cached(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  context 'with default attributes' do
    it 'converges successfully' do
      chef_run
    end
  end
end
