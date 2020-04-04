describe package('memcached') do
  it { should be_installed }
end

describe service('memcached') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(11_211) do
  it { should be_listening }
end

memcache_user =
  if os.family == 'redhat'
    'memcached'
  else
    'memcache'
  end

# Output of ps on RHEL 6/7 seems to exclude the 'm' in '-I 1m'
command =
  if os.family == 'redhat' && os.release.to_i < 8
    "-m 64 -u #{memcache_user} -c 1024 -I 1  -U 11211 -p 11211 -l 0.0.0.0 -v"
  else
    "-m 64 -u #{memcache_user} -c 1024 -I 1m -U 11211 -p 11211 -l 0.0.0.0 -v"
  end

describe processes '/usr/bin/memcached' do
  its('commands') { should include "/usr/bin/memcached #{command}" }
end
