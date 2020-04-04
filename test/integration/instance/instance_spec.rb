describe package('memcached') do
  it { should be_installed }
end

%w(
  memcached_backend_cache
  memcached_web_cache
  memcached_painful_cache
  memcached_socket
).each do |memcached_srv|
  describe service memcached_srv do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

describe command('ps aux | grep -q memcached_painful_cache') do
  its('exit_status') { should eq 0 }
end

describe port(11_211) do
  it { should_not be_listening }
end

%w(
  11_212
  11_213
  11_214
).each do |p|
  describe port p do
    it { should be_listening }
  end
end

if os.family == 'redhat'
  memcache_user = 'memcached'
  memcache_group = 'memcached'
else
  memcache_user = 'memcache'
  memcache_group = 'memcache'
end

# Output of ps on RHEL 6/7 seems to exclude the 'm' in '-I 1m'
commands = if os.family == 'redhat' && os.release.to_i < 8
             [
              "-m 64 -u #{memcache_user} -c 1024 -I 1  -U 11212 -p 11212 -l 0.0.0.0 -v",
              '-m 64 -u memcached_other_user -c 1024 -I 1  -U 11213 -p 11213 -l 0.0.0.0 -v -t 10',
              '-m 64 -u memcached_painful_cache -c 1024 -I 1  -U 11214 -p 11214 -l 0.0.0.0 -v -t 10',
              "-m 64 -u #{memcache_user} -c 1024 -I 1  -s /var/run/memcached/socket -a 750 -v",
             ]
           else
             [
              "-m 64 -u #{memcache_user} -c 1024 -I 1m -U 11212 -p 11212 -l 0.0.0.0 -v",
              '-m 64 -u memcached_other_user -c 1024 -I 1m -U 11213 -p 11213 -l 0.0.0.0 -v -t 10',
              '-m 64 -u memcached_painful_cache -c 1024 -I 1m -U 11214 -p 11214 -l 0.0.0.0 -v -t 10',
              "-m 64 -u #{memcache_user} -c 1024 -I 1m -s /var/run/memcached/socket -a 750 -v",
             ]
           end

describe file '/var/run/memcached/socket' do
  its('type') { should eq :socket }
  its('mode') { should cmp '0750' }
  its('owner') { should eq memcache_user }
  its('group') { should eq memcache_group }
end

describe processes '/usr/bin/memcached' do
  commands.each do |cmd|
    its('commands') { should include "/usr/bin/memcached #{cmd}" }
  end
end
