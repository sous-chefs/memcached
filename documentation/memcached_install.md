# memcached_install

Installs the memcached package and prepares the shared user and runtime directories.

## Actions

* `:create` - Installs the package and creates shared local resources. Default.
* `:delete` - Removes the package and managed directories.

## Properties

* `package_name` - String, default `'memcached'`. Package to install.
* `package_version` - String, default `nil`. Package version to install.
* `user` - String, platform default. Service user.
* `group` - String, platform default. Service group.
* `log_dir` - String, default `'/var/log/memcached'`. Log directory to create.
* `run_dir` - String, default `'/var/run/memcached'`. Runtime directory to create.
* `manage_user` - true or false, default `true`. Whether to manage the service user and group.
* `manage_directories` - true or false, default `true`. Whether to manage log and runtime directories.

## Examples

### Basic install

```ruby
memcached_install 'memcached'
```

### Pin a package version

```ruby
memcached_install 'memcached' do
  package_version '1.6.24-1build3'
end
```
