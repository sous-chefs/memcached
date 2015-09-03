# Memcached Cookbook
[![Build Status](https://travis-ci.org/acaiafa/memcached-cookbook.svg?branch=master)](https://travis-ci.org/acaiafa/memcached-cookbook.svg?branch=master)
[Application cookbook][0] which installs and configures the [memcached][1].

## Usage
### Supports
- Ubuntu 
- RHEL

### Dependencies
| Name | Description |
|------|-------------|
| [poise][2] | [Library cookbook][4] built to aide in writing reusable cookbooks. |
| [poise-service][3] | [Library cookbook][4] built to abstract service management. |

### Attributes
All attributes are settings in which memcached supports out of the box. If there is anyting additional you would like to see please submit a PR. Thanks!

### Resources/Providers

#### memcached_instance
The most basic approach to get all of the default memcached settings is here:

```ruby
memcached_instance 'test'
```

You have the ability to tune everything and anything memcached. You simply have to pass the attribute name like so:

```ruby
memcached_instance instance_name do
    bind_ip node.ipaddress
    port 11212
    max_connections 2048
    cachesize 128
end
```

Authors
-----------------
- Author:: Anthony Caiafa (<2600.ac@gmail.com>)

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern#theapplicationcookbook
[1]: http://memcached.org/
[2]: https://github.com/poise/poise
[3]: https://github.com/poise/poise-service
[4]: http://blog.vialstudios.com/the-environment-cookbook-pattern#thelibrarycookbook
[5]: libraries/memcached_instance.rb
