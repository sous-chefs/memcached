# Limitations

## Package Availability

Memcached does not publish operating-system package repositories for this cookbook to configure.
The upstream project recommends using packages from the operating system package manager, or
building from source when a newer version or compile-time feature is required.

### APT (Debian/Ubuntu)

* Ubuntu 22.04 and 24.04 provide `memcached` in the distribution repositories.
* Debian 12 and 13 provide `memcached` in the distribution repositories.
* Debian 11 and Ubuntu 20.04 are not tested because their standard support has ended.

### DNF/YUM (RHEL family)

* RHEL-compatible platforms 8, 9, and 10 provide `memcached` through distribution repositories.
* Amazon Linux 2023 provides `memcached` through distribution repositories.
* Fedora provides current `memcached` builds in the Fedora package collection.

### Zypper (SUSE)

* openSUSE Leap 15.x is not tested because Leap 15.6 reached end of life on April 30, 2026.
* openSUSE Leap 16 is not in the current Dokken test matrix for this cookbook.

## Architecture Limitations

Package architecture availability is inherited from the operating system repository. Debian and
Ubuntu publish packages for common architectures including `amd64` and `arm64`; Fedora publishes
packages through its normal architecture build system. This cookbook only validates Linux x86_64
Dokken platforms locally and in CI.

## Source/Compiled Installation

This cookbook installs the distribution `memcached` package. It does not compile memcached from
source.

### Build Dependencies

| Platform Family | Packages |
|-----------------|----------|
| Debian          | `build-essential`, `libevent-dev` |
| RHEL/Fedora     | `gcc`, `make`, `libevent-devel` |

## Known Issues

* The built-in proxy requires compiling memcached from source with proxy support enabled.
* The `memcached_instance` resource assumes systemd-managed Linux services.

## Research Sources

* Memcached server guide: <https://docs.memcached.org/serverguide/>
* Memcached source dependencies: <https://github.com/memcached/memcached>
* Debian source package versions: <https://sources.debian.org/src/memcached/>
* Fedora package versions: <https://packages.fedoraproject.org/pkgs/memcached/memcached/>
* openSUSE Leap lifecycle: <https://endoflife.date/opensuse>
