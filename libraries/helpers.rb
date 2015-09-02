module MemcachedCookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def config_dir
      case node.platform_family
      when 'rhel'
        '/etc/sysconfig'
      else
        '/etc'
      end
    end

    def file_name
      case node.platform_family
      when 'rhel'
        'memcached-'
      else
        'memcached_'
      end
    end
  end
end
