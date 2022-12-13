name              'memcached'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs memcached and includes memcached_instance resource for setting up memcached instances'
source_url        'https://github.com/sous-chefs/memcached'
issues_url        'https://github.com/sous-chefs/memcached/issues'
chef_version      '>= 15.3'
version           '7.0.4'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end
