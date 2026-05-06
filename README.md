# memcached Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/memcached.svg)](https://supermarket.chef.io/cookbooks/memcached)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/memcached/master.svg)](https://circleci.com/gh/sous-chefs/memcached)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Provides custom resources for installing memcached and managing systemd memcached instances.

## Requirements

### Platforms

- AlmaLinux, Rocky Linux, Oracle Linux, RHEL, CentOS Stream, and Amazon Linux
- Debian and Ubuntu
- Fedora

### Chef Infra Client

- Chef Infra Client 15.3+

## Usage

This cookbook no longer ships recipes or attributes. Use the custom resources directly in your
wrapper cookbook. See [migration.md](migration.md) for the breaking migration from
`memcached::default` and node attributes.

See the resource documentation for complete usage and examples:

- [memcached_install](documentation/memcached_install.md)
- [memcached_instance](documentation/memcached_instance.md)

## Custom Resources

### memcached_install

Installs the memcached package and prepares shared local resources.

### memcached_instance

Adds or removes a memcached instance running under systemd.

#### Actions

- :create: Creates the systemd unit and installs memcached by default
- :delete: Stops, disables, and deletes the systemd unit
- :remove: Alias for `:delete`
- :start: Creates and starts an instance of memcached
- :stop: Stops an instance of memcached
- :enable: Creates and enables an instance of memcached to run at boot
- :disable: Disables an instance of memcached
- :restart: Restarts an instance of memcached

#### Properties

- :memory - the amount of memory allocated for the cache. default: 64
- :package_name - package to install. default: memcached
- :package_version - package version to install. default: nil
- :install - install package and shared directories before creating the instance. default: true
- :port - the TCP port to listen on. default: 11,211
- :udp_port - the UDP port to listen on. default: 11,211
- :listen - the IP to listen on. default: '0.0.0.0'
- :socket - the file patch to run memcached as a socket (this disables listening on a port by default)
- :socket_mode - the file mode for the socket (memcached defaults to 0700)
- :maxconn - the maximum number of connections to accept. default: 1024
- :user - the user to run as
- :group - group assigned to the managed instance user
- :binary_path - path of memcached binary, when set we assume memcached is already installed
- :threads - the number of threads to use
- :max_object_size - the largest object size to store
- :experimental_options - an array of experimental config options, such as: ['maxconns_fast', 'hashpower']
- :extra_cli_options - an array of additional config options, such as: ['-L']
- :ulimit - the ulimit setting to use for the service
- :log_dir - shared log directory to create. default: /var/log/memcached
- :run_dir - shared runtime directory to create. default: /var/run/memcached
- :disable_default_instance - disable the default 'memcached' service installed by the package. default: true
- :remove_default_config - remove package default config files. default: true
- :no_restart - disable the service restart on configuration change. default: false
- :log_level - The level at which we log, default to 'info'. Choose from: 'info', 'debug', 'trace', or 'none'.

#### Examples

Create a new memcached instance named super_custom_memcached:

```ruby
memcached_instance 'super_custom_memcached' do
  port 11_212
  memory 128
  action [:create, :enable, :start]
end
```

Stop and disable the super_custom_memcached instance:

```ruby
memcached_instance 'super_custom_memcached'  do
  action :delete
end
```

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
