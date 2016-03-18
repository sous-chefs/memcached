require 'spec_helper'

set :path, '$PATH:/sbin' if os[:family] == 'redhat' && os[:release].match(/^5\.\d+/)

describe package('memcached') do
  it { should be_installed }
end

describe port(11_211) do
  it { should be_listening.with('tcp') }
end
