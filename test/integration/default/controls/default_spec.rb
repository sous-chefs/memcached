# frozen_string_literal: true

title 'Default memcached instance'

memcache_user =
  if os.family == 'redhat'
    'memcached'
  else
    'memcache'
  end

control 'memcached-default-01' do
  impact 1.0
  title 'Package and service are installed'

  describe package('memcached') do
    it { should be_installed }
  end

  describe systemd_service('memcached') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'memcached-default-02' do
  impact 1.0
  title 'Memcached listens on the default TCP port'

  describe port(11_211) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end
end

control 'memcached-default-03' do
  impact 0.8
  title 'Default command line matches resource defaults'

  describe processes('/usr/bin/memcached') do
    its('commands') { should include "/usr/bin/memcached -m 64 -u #{memcache_user} -c 1024 -I 1m -U 11211 -p 11211 -l 0.0.0.0 -v" }
  end
end
