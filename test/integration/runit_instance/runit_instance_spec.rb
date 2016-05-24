
describe package('memcached') do
  it { should be_installed }
end

describe port(11_212) do
  it { should be_listening }
end

describe port(11_213) do
  it { should be_listening }
end
