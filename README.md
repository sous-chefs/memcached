# memcached Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/memcached.svg)](https://supermarket.chef.io/cookbooks/memcached)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/memcached/master.svg)](https://circleci.com/gh/sous-chefs/memcached)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Provides a custom resource for installing instances of memcached. Also ships with a default recipe that uses attributes to configure a single memcached instance on a host.

## Requirements

### Platforms

- Debian / Ubuntu and derivatives
- RHEL and derivatives
- Fedora

### Chef Infra Client

- Chef Infra Client 15.3+

## Attributes

The following are node attributes are used to configure the command line options of memcached if using the default.rb recipe. They are not used if using the memcached_instance custom resource.

- `memcached['memory']` - maximum memory for memcached instances.
- `memcached['user']` - user to run memcached as.
- `memcached['port']` - TCP port for memcached to listen on.
- `memcached['udp_port']` - UDP port for memcached to listen on.
- `memcached['listen']` - IP address for memcache to listen on, defaults to **0.0.0.0** (world accessible).
- `memcached['maxconn']` - maximum number of connections to accept (defaults to 1024)
- `memcached['max_object_size']` - maximum size of an object to cache (defaults to 1MB)
- `memcached['logfilepath']` - path to directory where log file will be written.
- `memcached['logfilename']` - logfile to which memcached output will be redirected in $logfilepath/$logfilename.
- `memcached['threads']` - Number of threads to use to process incoming requests. The default is 4.
- `memcached['experimental_options']` - Comma separated list of extended or experimental options. (array)
- `memcached['extra_cli_options']` - Array of single item options suchas -L for large pages.
- `memcached['ulimit']` - maxfile limit to set (needs to be at least maxconn)

## Usage

This cookbook can be used to to setup a single memcached instance running under the system's init provider by including `memcached::default` on your runlist. The above documented attributes can be used to control the configuration of that service.

The cookbook can also within other cookbooks in your infrastructure with the `memcached_instance` custom resource. See the documentation below for the usage and examples of that custom resource.

## Custom Resources

### instance

Adds or removes an instance of memcached running under the system's native init system (sys-v, upstart, or systemd).

#### Actions

- :start: Starts (and installs) an instance of memcached
- :stop: Stops an instance of memcached
- :enable: Enabled (and installs) an instance of memcached to run at boot
- :restart: Restarts an instance of memcached

#### Properties

- :memory - the amount of memory allocated for the cache. default: 64
- :port - the TCP port to listen on. default: 11,211
- :udp_port - the UDP port to listen on. default: 11,211
- :listen - the IP to listen on. default: '0.0.0.0'
- :socket - the file patch to run memcached as a socket (this disables listening on a port by default)
- :socket_mode - the file mode for the socket (memcached defaults to 0700)
- :maxconn - the maximum number of connections to accept. default: 1024
- :user - the user to run as
- :binary_path - path of memcached binary, when set we assume memcached is already installed
- :threads - the number of threads to use
- :max_object_size - the largest object size to store
- :experimental_options - an array of experimental config options, such as: ['maxconns_fast', 'hashpower']
- :extra_cli_options - an array of additional config options, such as: ['-L']
- :ulimit - the ulimit setting to use for the service
- :disable_default_instance - disable the default 'memcached' service installed by the package. default: true
- :no_restart - disable the service restart on configuration change. default: false
- :log_level - The level at which we log, default to 'info'. Choose from: 'info', 'debug', 'trace' which map to '-v', '-vv' or '-vvv' arguments.

#### Examples

Create a new memcached instance named super_custom_memcached:

```ruby
memcached_instance 'super_custom_memcached' do
  port 11_212
  memory 128
end
```

Stop and disable the super_custom_memcached instance:

```ruby
memcached_instance 'super_custom_memcached'  do
  action :remove
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
