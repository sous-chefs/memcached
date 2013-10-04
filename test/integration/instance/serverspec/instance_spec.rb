require 'serverspec'
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe 'memcached_instance definition' do
  it 'is running with the correct attributes' do
    expect(service('memcached')).to be_running
    expect(port(11_211)).to be_listening
  end
end
