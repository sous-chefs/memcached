require 'spec_helper'

describe package('memcached') do
  it { should be_installed }
end

describe port(11_212) do
  it { should be_listening.with('tcp') }
end

describe port(11_213) do
  it { should be_listening.with('tcp') }
end
