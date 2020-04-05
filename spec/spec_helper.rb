require 'chefspec'
require 'chefspec/berkshelf'

shared_context 'memcached_stubs' do
  before do
    stub_command('getent passwd memcached').and_return(false)
    stub_command('getent passwd nobody').and_return(false)
    stub_command('getent passwd memcache').and_return(false)
    stub_command('dpkg -s memcached').and_return(true)
  end
end

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.log_level = :error         # Avoid deprecation notice SPAM
end
