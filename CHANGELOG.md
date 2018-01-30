# memcached Cookbook CHANGELOG

This file is used to list changes made in each version of the memcached cookbook.

## 5.1.0 (2018-01-30)

- Add 'binary-path' property to the resource
- Add 'no-restart' property to the resource

## 5.0.2 (2018-01-17)

- Use binary_path helper throughout code for consistency

## 5.0.1 (2018-01-10)

- Fix ulimit for runit based services
- Use Systemd User directive which is more secure
- Fix experimental_options to be properly spaced

## 5.0.0 (2017-09-06)

### Breaking changes

- Support for RHEL 5 has been removed. This removes the cookbook dependency on yum-epel as well
- Runit support has been marked as deprecated and will be removed in a future release of this cookbook. We highly recommend you utilize the native init system of your distro to have the best experience with memcached.

### Other fixes

- Fix using the resource to setup a sys-v init script on Fedora platforms
- Fix Amazon Linux support on Chef >= 13
- Don't delete the memcached init script if the instance name is 'memcached' and we're specifying the instance_name on the resource instead of using the resource's name
- Added new resource property for `log_level` and fixed logging setup in the resources
- Run failures with runit have been resolved
- Minor property cleanup in the resources
- Avoid an extra blank line in the command options
- Add Debian Sys-V script for Debian to allow for Debian 7 support
- Pull in systemd unit file security settings from upstream

## 4.1.0 (2017-05-06)

- Require Chef 12.7+ to workaround action_class bug

## 4.0.1 (2017-04-26)

- Update apache2 license string

## 4.0.0 (2017-03-13)

- Require 12.5 and remove dependency on compat_resource
- Let chef pick the best init system instead of hardcoding init systems per distro / version
- Avoid Chef 13 deprecation warnings
- Test with Local Delivery instead of Rake
- Add extra_cli_options for passing anything else you want in to the binary
- Use a consistent memcached path in the sysv script

## 3.0.3 (2017-01-19)

- Add missing `user` variable to template in instance_sysv_init resource
- Move testing to a test recipe and improve that testing
- Depend on the latest compat_resource
- Use :template_cookbook property for all template resources to fix specifying a different cookbook

## 3.0.2 (2016-06-28)

- Remove Chef 11 compatibility check in the metadata
- Better handle specifying non-standard init systems

## 3.0.1 (2016-06-23)

- Remove smartos from the supported platforms metadata as it's not longer supported
- Add opensuse and opensuseleap as supported platforms in the metadata
- Increase the compat_resource depdency from >= 12.9 to >= 12.10 to bring in important fixes
- Add requirement of Chef 12 to the metadata
- Restart the service on failure when running under systemd
- Disable FC023 in Foodcritic tests

## 3.0.0 (2016-05-24)

- The preferred method of use for this cookbook is now the custom resources via your own wrapper cookbook. The default recipe simply wraps the custom resource and allows you to set attributes instead of directly changing custom resource properties. To support this goal, the custom resource now uses the native init system of your OS by default (sys-v, upstart or systemd). The Runit provider is still present for backwards compatibility, but must be specified. See the readme for an example of how to do that with the custom resource. The default recipe does not support using runit and runit is no longer an init system we suggest users use.

- The ulimit attribute and custom resource property behavior have been changed. Ulimit now takes the actual ulimit value as a string or int. Previously a boolean value was passed and if true the connection max was set. This gives users additional control over the ulimit value.

- SmartOS support has been removed. SmartOS support was never properly implemented and didn't support the custom resource. We've chosen to remove it instead of leaving partially functional and untested code in place.

### Other CHANGES

- Testing has been improved with additional specs and integration tests that better match the capabilities of the cookbook
- Support has been added for platforms that lacked the Runit package, specifically opensuse -

## 2.1.0 (2016-03-16)

- Added a new property, disable_default_instance, to the instance custom resource for disabling the package installed memcached service. This prevents resource merging from resulting in a service that isn't disabled.
- Updated the custom resource to avoid potential namespace conflicts
- Require the latest custom_resource to avoid failures and extra warning messages
- Resolved nil attribute deprecation warnings
- Added maintainers files

## 2.0.3 (2016-02-16)

- Fix template whitespace location that resulted in bad command

## 2.0.2 (2015-11-20)

- Push new version to Supermarket to deal with bad artifact

## 2.0.1 (2015-11-19)

- Push new version to Supermarket to deal with bad artifact

## 2.0.0 (2015-11-10)

BREAKING CHANGES:

- The user and group attributes have been removed and are instead handled by a helper that picks the appropriate user / group based on the platform
- The memcached_instance definition that used both passed values and node attributes for configuration has been rewritten as a 12.5 custom resource with compat_resource providing backwards compatibility to all Chef 12.X releases. This new custom resource handles the installation of memcached and all configuration is passed in via custom resource properties. See the readme for examples of how to use this new resource. This change should greatly improve the ability to use memcached_instance within wrapper cookbooks.

## 1.9.0 (2015-11-05)

NOTE: This will be the last version of this cookbook that supports Chef 11 and the traditional attribute / resource hybrid setup for memcached instances. After this release this cookbook will function with attributes for a simple install or Chef 12.5 custom resources for creating individual memcached instances. If you utilize memcached instances using the attributes to define the config you'll need to pin to ~1.0 and later update to the new format in ~2.0.

- Debian/Ubuntu switched the user that memcached runs under from nobody to memcache. Updated the cookbook to use this user on those platforms and create it in case we're on an older distro release that didn't yet have that user
- Removed use of shellout that was causing issues for users
- Improved the workaround on Debian/Ubuntu for not starting the service on package install so that it doesn't show up as a changed resource on every Chef run
- Updated Chefspec to 4.X and added additional specs
- Add oracle to the metadata
- Add issues_url and source_url to the metadata
- Add new contributing.md, maintainers.md, and testing.md docs
- Add travis and cookbook version badges to the readme
- Clarified Chef 11 is the minimum required chef release
- Updated platforms in the Kitchen config
- Added chefignore file
- Removed all hash rockets
- Added a .foodcritic file with exclusions
- Updated travis to use their container infrastructure, chef-dk for testing deps, and kitchen-docker for integration testing
- Added a Rakefile to simplify testing
- Removed yum as a dependency as it wasn't being used.
- Removed attributes from the metadata as they hadn't been updated

## v1.8.0 (2015-08-11)

- updated serverspec tests to pass (See 3c7b5c9)
- deconflict memcached_instance runit definition from default init (See b06d2d)

  - split `default.rb` into `install.rb` and `configure.rb` so that memcached_instance only starts the specified number of instances

- added attributes `logfilepath`, `version`, `threads`, `experimental_options`, and `ulimit`

- NOTE: if memcached_instance name is not specified or set to "memcached", the instance name will be "memcached". If anything else is specified, the instance name will be "memcached-${name}"

## v1.7.2 (2014-03-12)

- [COOK-4308] - Enable memcache on RHEL, Fedora, and Suse
- [COOK-4212] - Support max_object_size rhel and fedora

## v1.7.0

Updating for yum ~> 3.0\. Fixing up style issues for rubocop. Updating test-kitchen harness

## v1.6.6

fixing metadata version error. locking to 3.0

## v1.6.4

Locking yum dependency to '< 3'

## v1.6.2

[COOK-3741] UDP settings for memcached

## v1.6.0

### Bug

- **[COOK-3682](https://tickets.chef.io/browse/COOK-3682)** - Set user when using Debian packages

### Improvement

- **[COOK-3336](https://tickets.chef.io/browse/COOK-3336)** - Add an option to specify the logfile (fix)

## v1.5.0

### Improvement

- **[COOK-3336](https://tickets.chef.io/browse/COOK-3336)** - Add option to specify logfile
- **[COOK-3299](https://tickets.chef.io/browse/COOK-3299)** - Document that `memcached` is exposed by default

### Bug

- **[COOK-2990](https://tickets.chef.io/browse/COOK-2990)** - Include `listen`, `maxconn`, and `user` in the runit service

### New Feature

- **[COOK-2790](https://tickets.chef.io/browse/COOK-2790)** - Add support for defining max object size

## v1.4.0

### Improvement

- [COOK-2756]: add SUSE support to memcached cookbook
- [COOK-2791]: Remove the template for Karmic from the memcached cookbook

### Bug

- [COOK-2600]: support memcached on SmartOS

## v1.3.0

- [COOK-2386] - update `memcached_instance` definition for `runit_service` resource

## v1.2.0

- [COOK-1469] - include yum epel recipe on RHEL 5 (introduces yum cookbook dependency)
- [COOK-2202] - Fix typo in previous ticket/commits
- [COOK-2266] - pin runit dependency

## v1.1.2

- [COOK-990] - params insite runit_service isn't the same as outside

## v1.1.0

- [COOK-1764] - Add Max Connections to memcached.conf and fix typos

## v1.0.4

- [COOK-1192] - metadata doesn't include RH platforms (supported)
- [COOK-1354] - dev package changed name on centos6

## v1.0.2

- [COOK-1081] - support for centos/rhel

## v1.0.0

- [COOK-706] - Additional info in README
- [COOK-828] - Package for RHEL systems

## v0.10.4

- Current released version
