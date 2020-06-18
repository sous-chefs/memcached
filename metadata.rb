name              'memcached'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs memcached and includes memcached_instance resource for setting up memcached instances'
source_url        'https://github.com/sous-chefs/memcached'
issues_url        'https://github.com/sous-chefs/memcached/issues'
chef_version      '>= 13.0'
version           '6.1.0'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end
