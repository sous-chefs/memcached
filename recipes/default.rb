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

# this recipe simply uses the memcached_instance custom resource
# for additional customization you can use this resource in your own wrapper cookbook
# this recipe simply uses the memcached_instance custom resource
# for additional customization you can use this resource in your own wrapper cookbook
memcached_instance 'memcached' do
  memory node['memcached']['memory']
  port node['memcached']['port']
  udp_port node['memcached']['udp_port']
  listen node['memcached']['listen']
  maxconn node['memcached']['maxconn']
  user service_user
  max_object_size node['memcached']['max_object_size']
  threads node['memcached']['threads']
  experimental_options node['memcached']['experimental_options']
  extra_cli_options node['memcached']['extra_cli_options']
  ulimit node['memcached']['ulimit']
  action [:start, :enable]
end
