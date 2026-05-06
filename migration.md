# Migration Guide

This release is a full migration from recipes and node attributes to custom resources.

## What Changed

The cookbook no longer ships `recipes/` or `attributes/`. The former `memcached::default`
recipe behavior is now expressed directly with the `memcached_instance` resource, and package
installation is available through `memcached_install`.

## Attribute Mapping

| Former node attribute | Resource property |
|-----------------------|-------------------|
| `node['memcached']['version']` | `package_version` |
| `node['memcached']['memory']` | `memory` |
| `node['memcached']['port']` | `port` |
| `node['memcached']['udp_port']` | `udp_port` |
| `node['memcached']['listen']` | `listen` |
| `node['memcached']['maxconn']` | `maxconn` |
| `node['memcached']['max_object_size']` | `max_object_size` |
| `node['memcached']['experimental_options']` | `experimental_options` |
| `node['memcached']['extra_cli_options']` | `extra_cli_options` |
| `node['memcached']['ulimit']` | `ulimit` |
| `node['memcached']['logfilepath']` | `log_dir` |

## Before

```ruby
run_list 'recipe[memcached::default]'

default['memcached']['memory'] = 128
default['memcached']['port'] = 11_212
```

## After

```ruby
memcached_instance 'memcached' do
  memory 128
  port 11_212
  udp_port 11_212
  action [:create, :enable, :start]
end
```

The test cookbook examples now live in `test/cookbooks/test/recipes/`.
