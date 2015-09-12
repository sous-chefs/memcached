require 'spec_helper'

set :path, '$PATH:/sbin' if os[:family] == 'redhat' && os[:release].match(/^5\.\d+/)

describe package('memcached') do
  it { should be_installed }
end

describe service('memcached') do
  it { should be_running }
end

describe command('service memcached status') do
  its(:stdout) { should match(/^run: memcached/) }
end

describe port(11_212) do
  it { should be_listening.with('tcp') }
end
