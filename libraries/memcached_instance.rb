#
## Cookbook: memcached-cookbook
## License: Apache 2.0
#

require 'poise_service/service_mixin'
require_relative 'helpers'

module MemcachedCookbook
  module Resource
    class MemcachedInstance < Chef::Resource
      include Poise
      provides(:memcached_instance)
      include PoiseService::ServiceMixin

      # @!attribute config_name
      # @return [String]
      attribute(:instance, kind_of: String, name_attribute: true)

      attribute(:log_file, kind_of: String, default: '/var/log/memcached.log')
      attribute(:verbose, equal_to: %{1 2})
      attribute(:bind_ip, kind_of: String, default: '127.0.0.1')
      attribute(:port, kind_of: String, default: '11211')
      attribute(:udp_port, kind_of: [String, NilClass], default: nil)
      attribute(:max_connections, kind_of: Integer, default: 1024)
      attribute(:max_memory, kind_of: Integer, default: 64)
      attribute(:max_object_size, kind_of: Integer)
      attribute(:threads, kind_of: Integer)
      attribute(:service_user, kind_of: String, default: 'memcache')
      attribute(:enabled, equal_to: %w{yes no}, default: 'yes')
      attribute(:options, kind_of: [String, NilClass], default: nil)
      attribute(:experimental_options, kind_of: [String, NilClass], default: nil)
    end
  end

  module Provider
    class MemcachedInstance < Chef::Provider
      include Poise
      provides(:memcached_instance)
      include PoiseService::ServiceMixin
      include MemcachedCookbook::Helpers

      def action_enable
        notifying_block do
          if node.platform_family == 'debian'
            execute 'disable auto-start' do
              command 'echo exit 101 > /usr/sbin/policy-rc.d ; chmod +x /usr/sbin/policy-rc.d'
            end
          end

          # Install memcached package
          package 'memcached' do
            action :install
          end

          if node.platform_family == 'debian'
            execute 'undo service disable hack' do
              command 'echo exit 0 > /usr/sbin/policy-rc.d'
            end
          end

          %w{/etc/memcached.conf /etc/init.d/memcached}.each do |c|
            file c do
              action :delete
            end
          end

          template "#{new_resource.instance} :create #{config_dir}/#{file_name}#{new_resource.instance}.conf" do
            path "#{config_dir}/#{file_name}#{new_resource.instance}.conf"
            source "memcached-config-#{node.platform_family}.erb"
            user 'root'
            group 'root'
            variables(config: new_resource)
            cookbook 'memcached'
          end
        end
        super
      end

      def action_disable
        super
        notifying_block do
          directory "#{config_dir}/#{file_name}#{new_resource.instance}.conf" do
            action :delete
          end
        end
      end

      def start_command
        start = "/usr/bin/memcached -m #{new_resource.max_memory} -p #{new_resource.port} -u #{new_resource.service_user} -l #{new_resource.bind_ip} -c #{new_resource.max_connections} -P /var/run/memcached.pid"
        if new_resource.options.nil?
          "#{start}"
        else
          "#{start} #{new_resource.options}"
        end
      end

      def service_options(service)
        service.service_name("memcached-#{new_resource.instance}")
        service.command("#{start_command}")
        service.directory('/var/run')
        service.user(new_resource.service_user)
        service.restart_on_update(true)
        service.options :sysvinit, template: 'memcached:memcached-init.erb'
        service.options :upstart, template: 'memcached:memcached-upstart.erb'
      end
    end
  end
end
