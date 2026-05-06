# frozen_string_literal: true

title 'Multiple memcached instances'

if %w(fedora redhat).include?(os.family)
  memcache_user = 'memcached'
  memcache_group = 'memcached'
else
  memcache_user = 'memcache'
  memcache_group = 'memcache'
end

control 'memcached-instance-01' do
  impact 1.0
  title 'Package is installed'

  describe package('memcached') do
    it { should be_installed }
  end
end

control 'memcached-instance-02' do
  impact 1.0
  title 'Configured services are enabled and running'

  %w(
    memcached_backend_cache
    memcached_web_cache
    memcached_painful_cache
    memcached_socket
  ).each do |memcached_srv|
    describe systemd_service(memcached_srv) do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end

control 'memcached-instance-03' do
  impact 1.0
  title 'Configured ports and socket are listening'

  describe port(11_211) do
    it { should_not be_listening }
  end

  [11_212, 11_213, 11_214].each do |memcached_port|
    describe port(memcached_port) do
      it { should be_listening }
    end
  end

  describe file('/var/run/memcached/socket') do
    its('type') { should eq :socket }
    its('mode') { should cmp '0750' }
    its('owner') { should eq memcache_user }
    its('group') { should eq memcache_group }
  end
end

control 'memcached-instance-04' do
  impact 0.8
  title 'Configured command lines match resource properties'

  commands = [
    "-m 64 -u #{memcache_user} -c 1024 -I 1m -U 11212 -p 11212 -l 0.0.0.0 -v",
    '-m 64 -u memcached_other_user -c 1024 -I 1m -U 11213 -p 11213 -l 0.0.0.0 -v -t 10',
    '-m 64 -u memcached_painful_cache -c 1024 -I 1m -U 11214 -p 11214 -l 0.0.0.0 -v -t 10',
    "-m 64 -u #{memcache_user} -c 1024 -I 1m -s /var/run/memcached/socket -a 750 -v",
  ]

  describe processes('/usr/bin/memcached') do
    commands.each do |cmd|
      its('commands') { should include "/usr/bin/memcached #{cmd}" }
    end
  end
end
