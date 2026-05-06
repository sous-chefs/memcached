# memcached_instance

Creates and manages a systemd memcached instance.

## Actions

* `:create` - Installs dependencies when needed and creates the systemd unit. Default.
* `:delete` - Stops, disables, and deletes the systemd unit.
* `:remove` - Alias for `:delete`.
* `:start` - Creates and starts the instance.
* `:stop` - Stops the instance.
* `:restart` - Restarts the instance.
* `:enable` - Creates and enables the instance.
* `:disable` - Disables the instance.

## Properties

* `instance_name` - String, name property. Instance name.
* `package_name` - String, default `'memcached'`. Package installed before creating the instance.
* `package_version` - String, default `nil`. Package version to install.
* `install` - true or false, default `true`. Whether to install the package and shared directories.
* `memory` - Integer or String, default `64`. Memory allocated for the cache in MB.
* `port` - Integer or String, default `11211`. TCP port.
* `udp_port` - Integer or String, default `11211`. UDP port.
* `listen` - String, default `'0.0.0.0'`. Listen address.
* `socket` - String, default `''`. Unix socket path. Setting this disables TCP and UDP options.
* `socket_mode` - String, default `''`. Unix socket file mode.
* `maxconn` - Integer or String, default `1024`. Maximum connections.
* `user` - String, platform default. Service user.
* `group` - String, platform default. Group assigned to the managed instance user.
* `binary_path` - String, platform default. Memcached binary path. Setting this skips package installation.
* `threads` - Integer or String, default `nil`. Worker thread count.
* `max_object_size` - String, default `'1m'`. Maximum object size.
* `experimental_options` - Array, default `[]`. Comma-joined extended options passed with `-o`.
* `extra_cli_options` - Array, default `[]`. Additional CLI options appended to `ExecStart`.
* `ulimit` - Integer or String, default `1024`. `LimitNOFILE` for the systemd unit.
* `log_dir` - String, default `'/var/log/memcached'`. Log directory created by `memcached_install`.
* `run_dir` - String, default `'/var/run/memcached'`. Runtime directory created by `memcached_install`.
* `disable_default_instance` - true or false, default `true`. Stop and disable the package default service for non-default instances.
* `remove_default_config` - true or false, default `true`. Delete package default config files.
* `no_restart` - true or false, default `false`. Disable automatic service restart when the unit changes.
* `log_level` - String, default `'info'`. One of `info`, `debug`, `trace`, or `none`.

## Examples

### Default instance

```ruby
memcached_instance 'memcached' do
  action [:create, :enable, :start]
end
```

### Multiple instances

```ruby
memcached_instance 'web_cache' do
  port 11_212
  udp_port 11_212
  memory 128
  action [:create, :enable, :start]
end
```

### Socket instance

```ruby
memcached_instance 'socket' do
  socket '/var/run/memcached/socket'
  socket_mode '750'
  action [:create, :enable, :start]
end
```
