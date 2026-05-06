# Migration Guide

This release is a full migration from recipes and node attributes to custom resources.

## What Changed

The cookbook no longer ships `recipes/` or `attributes/`. The former `memcached::default`
recipe behavior is now expressed directly with the `memcached_instance` resource, and package
installation is available through `memcached_install`.

## Attribute Mapping

* `node['memcached']['version']` maps to `package_version`.
* `node['memcached']['memory']` maps to `memory`.
* `node['memcached']['port']` maps to `port`.
* `node['memcached']['udp_port']` maps to `udp_port`.
* `node['memcached']['listen']` maps to `listen`.
* `node['memcached']['maxconn']` maps to `maxconn`.
* `node['memcached']['max_object_size']` maps to `max_object_size`.
* `node['memcached']['experimental_options']` maps to `experimental_options`.
* `node['memcached']['extra_cli_options']` maps to `extra_cli_options`.
* `node['memcached']['ulimit']` maps to `ulimit`.
* `node['memcached']['logfilepath']` maps to `log_dir`.

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
