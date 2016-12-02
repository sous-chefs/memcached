#
# Cookbook:: memcached
# Library:: matchers
#
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Copyright:: 2016, Chef Software, Inc.
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

if defined?(ChefSpec)
  ChefSpec.define_matcher :memcached_instance

  def start_memcached_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance, :start, resource_name)
  end

  def enable_memcached_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance, :enable, resource_name)
  end

  def restart_memcached_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance, :restart, resource_name)
  end

  def stop_memcached_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance, :stop, resource_name)
  end

  def disable_memcached_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance, :disable, resource_name)
  end

  def start_memcached_instance_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance_runit, :start, resource_name)
  end

  def enable_memcached_instance_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance_runit, :enable, resource_name)
  end

  def restart_memcached_instance_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance_runit, :restart, resource_name)
  end

  def stop_memcached_instance_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance_runit, :stop, resource_name)
  end

  def disable_memcached_instance_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance_runit, :disable, resource_name)
  end

  def create_memcached_instance_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance_runit, :create, resource_name)
  end

  def remove_memcached_instance_runit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance_runit, :remove, resource_name)
  end
end
