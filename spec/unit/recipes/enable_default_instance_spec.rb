require 'spec_helper'

describe 'test::enable_default_instance' do
  platform 'ubuntu'
  step_into :memcached_instance
  include_context 'memcached_stubs'

  it { is_expected.to_not stop_service('disable default memcached') }
  it { is_expected.to_not disable_service('disable default memcached') }
end
