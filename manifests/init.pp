# == Define: thrift
#
# Downloads, compiles and installs thrift
#
# === Parameters
#
# [*version*]
#   Sets the thrift version to be installed, defaults to the latest [0.9.1 for now]
# [*base_url*]
#   Url where to download thrift [default = 'https://archive.apache.org/dist/thrift']
# [*pkgs*]
#   Array with dependency packages to install before compile and install thrift. [dafault = dependent on platform]
# [*prefix*]
#   '--prefix' directive at '/configure' time. It allows to change default installation root folder for bin|lib|src|share. [default = /usr/local]
# [*default_version*]
#   Creates symlink as default version, i.e. 'thrift -> thrift-${version}'. [default = true].
#
# === Examples
#
# // installing the latest version
# thrift { 'latest': }
#
# // installing version 0.8.0
# thrift { '0.8.0': }
#
# // installing latest version alonside with version 0.8.0, and 'thrift' as a symlink to the latest version
# thrift { 'latest':
#   default_version => true
# }
# thrift { '0.8.0':
#   default_version => false
# }
#
# // installing in a different prefix [/usr], i.e. [/usr/bin, /usr/lib, /usr/share] instead of [/usr/local/bin, /usr/local/lib, /usr/local/share] (default).
# thrift { 'latest':
#   prefix => '/usr'
# }
#
# === Authors
#
# Sebastian Otaegui <feniix@gmail.com>
#
# === Copyright
#
# Copyright 2014 Sebastian Otaegui, unless otherwise noted.
#
define thrift (
  $version = undef,
  $base_url = undef,
  $pkgs = undef,
  $prefix = undef,
  $default_version = true,
) {
  include thrift::params

  if $version {
    $__version = $version
  } else {
    $__version = $thrift::params::version
  }
  notice("installing thrift version ${__version} [default_version: ${thrift::params::version}]")

  if $base_url {
    $__base_url = $base_url
  } else {
    $__base_url = $thrift::params::base_url
  }

  if $pkgs {
    $__pkgs = $pkgs
  } else {
    $__pkgs = $thrift::params::pkgs
  }

  if $prefix {
    $bin_path = "${prefix}/bin"
  } else {
    $bin_path = "${thrift::params::prefix}/bin"
  }
  
  validate_re($__version, '^\d+\.\d+\.\d+$')
  validate_array($__pkgs)

  case $::osfamily {
    'RedHat', 'Amazon', 'Debian', 'Darwin': {
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }

  $app_name = "thrift-${__version}"

  thrift::dependencies { $app_name:
    pkgs        => $__pkgs,
    pkg_manager => $thrift::params::pkg_manager
  }

  thrift::install { $app_name:
    default_version => $default_version,
    version         => $__version,
    url             => "${__base_url}/${__version}/${app_name}.tar.gz",
    prefix          => $prefix,
    require         => Thrift::Dependencies[$app_name],
    onlyif          => [
      "test ! -x ${bin_path}/${app_name}"
    ]
  }
}