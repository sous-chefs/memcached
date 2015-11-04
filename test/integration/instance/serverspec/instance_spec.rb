require 'spec_helper'

describe package('memcached') do
  it { should be_installed }
end

describe port(11_212) do
  it { should be_listening.with('tcp') }
end

# serverspec service checks don't work with runit on systemd systems
describe file('/etc/sv/super_custom_memcached/supervise/stat') do
  its(:content) { should match(/run/) }
end
