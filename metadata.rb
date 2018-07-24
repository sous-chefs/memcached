name              'memcached'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs memcached and includes memcached_instance resource for setting up memcached instances'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '5.1.1'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end

recipe 'memcached::default', 'Installs and configures memcached'

source_url 'https://github.com/chef-cookbooks/memcached'
issues_url 'https://github.com/chef-cookbooks/memcached/issues'
chef_version '>= 12.7'
