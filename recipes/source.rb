#
# Author:: Matthias Endler (<matthias.endler@trivago.com>)
# Cookbook Name:: memcached
# Recipe:: source
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install the development package for libevent
case node['platform']
when "debian", "ubuntu"
  # Ubuntu: apt-get install libevent-dev
  package "libevent-dev" do
    action :install
  end
when "redhat", "centos", "fedora"
  # Redhat/Fedora: yum install libevent-devel
  package "libevent-devel" do
    action :install
  end
end

version = node['memcached']['version']

remote_file "#{Chef::Config[:file_cache_path]}/memcached-#{version}.tar.gz" do
  source "#{node['memcached']['url']}/memcached-#{version}.tar.gz"
  checksum node['memcached']['checksum']
  mode '0644'
  not_if "which #{node['memcached']['bin']}"
end

bash "Compile memcache" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf memcached-#{version}.tar.gz
    cd memcached-#{version}
    ./configure --prefix=#{node['memcached']['prefix']}
    make && make install
    cp scripts/memached-init /etc/init.d/memcached
    chmod 755 /etc/init.d/memcached
    mkdir -p /usr/share/memcached/scripts/
    cp scripts/start-memcached /usr/share/memcached/scripts
    chmod 755 /usr/share/memcached/scripts
  EOH
end

# memcached init.d Service
template "/etc/init.d/memcached" do
  source "memcached.init.erb"
  owner 'root'
  mode 0755
end
