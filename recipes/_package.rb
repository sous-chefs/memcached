#
# Cookbook:: memcached
# Recipe:: default
#
# Copyright:: 2009-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['platform_family'] == 'debian'
  # dpkg, imma let you finish but don't start services automatically
  # https://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/
  file '/usr/sbin/policy-rc.d with exit 101' do
    path '/usr/sbin/policy-rc.d'
    content 'exit 101'
    mode '0755'
    not_if 'dpkg -s memcached'
  end

  package 'memcached' do
    version node['memcached']['version']
    action :install
  end

  file '/usr/sbin/policy-rc.d with exit 0' do
    path '/usr/sbin/policy-rc.d'
    content 'exit 0'
    mode '0755'
  end
else
  package 'memcached' do
    version node['memcached']['version']
    action :install
  end
end

group service_group do
  system true
  not_if "getent passwd #{service_user}"
end

user service_user do
  system true
  manage_home false
  gid service_group
  home '/nonexistent'
  comment 'Memcached'
  shell '/bin/false'
  action [:create, :lock]
end

directory node['memcached']['logfilepath'] do
  user service_user
  group service_group
  mode '0755'
end

directory '/var/run/memcached' do
  user service_user
  group service_group
  mode '0755'
end
