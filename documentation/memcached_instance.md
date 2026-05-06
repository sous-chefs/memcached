# memcached_instance

Creates and manages a systemd memcached instance.

## Actions

| Action     | Description |
|------------|-------------|
| `:create`  | Installs dependencies when needed and creates the systemd unit. Default. |
| `:delete`  | Stops, disables, and deletes the systemd unit. |
| `:remove`  | Alias for `:delete`. |
| `:start`   | Creates and starts the instance. |
| `:stop`    | Stops the instance. |
| `:restart` | Restarts the instance. |
| `:enable`  | Creates and enables the instance. |
| `:disable` | Disables the instance. |

## Properties

| Property                   | Type             | Default | Description |
|----------------------------|------------------|---------|-------------|
| `instance_name`            | String           | name property | Instance name. |
| `package_name`             | String           | `'memcached'` | Package installed before creating the instance. |
| `package_version`          | String           | `nil` | Package version to install. |
| `install`                  | true, false      | `true` | Whether to install the package and shared directories. |
| `memory`                   | Integer, String  | `64` | Memory allocated for the cache in MB. |
| `port`                     | Integer, String  | `11211` | TCP port. |
| `udp_port`                 | Integer, String  | `11211` | UDP port. |
| `listen`                   | String           | `'0.0.0.0'` | Listen address. |
| `socket`                   | String           | `''` | Unix socket path. Setting this disables TCP and UDP options. |
| `socket_mode`              | String           | `''` | Unix socket file mode. |
| `maxconn`                  | Integer, String  | `1024` | Maximum connections. |
| `user`                     | String           | platform default | Service user. |
| `group`                    | String           | platform default | Service group used during install. |
| `binary_path`              | String           | platform default | Memcached binary path. Setting this skips package installation. |
| `threads`                  | Integer, String  | `nil` | Worker thread count. |
| `max_object_size`          | String           | `'1m'` | Maximum object size. |
| `experimental_options`     | Array            | `[]` | Comma-joined extended options passed with `-o`. |
| `extra_cli_options`        | Array            | `[]` | Additional CLI options appended to `ExecStart`. |
| `ulimit`                   | Integer, String  | `1024` | `LimitNOFILE` for the systemd unit. |
| `log_dir`                  | String           | `'/var/log/memcached'` | Log directory created by `memcached_install`. |
| `run_dir`                  | String           | `'/var/run/memcached'` | Runtime directory created by `memcached_install`. |
| `disable_default_instance` | true, false      | `true` | Stop and disable the package default service for non-default instances. |
| `remove_default_config`    | true, false      | `true` | Delete package default config files. |
| `no_restart`               | true, false      | `false` | Disable automatic service restart when the unit changes. |
| `log_level`                | String           | `'info'` | One of `info`, `debug`, `trace`, or `none`. |

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
