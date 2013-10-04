require 'serverspec'
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe 'memcached::default' do
  it 'has memcached up and running' do
    memcached = service('memcached')
    expect(memcached).to be_running
  end
end
