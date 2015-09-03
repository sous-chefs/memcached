require 'spec_helper'

describe service('memcached') do
  it { should be_enabled }
end
describe service('memcached-test') do
  it { should be_running }
end
