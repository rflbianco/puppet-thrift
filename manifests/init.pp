# Define: thrift
# ===========================
#
# Define that downloads, compiles and installs a given version of Apache Thrift compiler.
# As any define, allows multiple versions to be installed in a single system.
# On installation adds the 'thrift-$VERSION' to system $PATH.
# A symlink to a default version as 'thrift' (only) can be added to system $PATH passing the expected parameter.
#
# Parameters
# ----------
#
# * `prefix`
# Overrides the default folders where Thrift compiler is installed.
# The default is '/usr/local', installing thrift into:
#   - /usr/local/bin
#   - /usr/local/lib
#   - /usr/local/share/doc
#
# * `version`
# The Thrift compiler version to be is installed.
# The default is the latest (0.9.2)
#
# * `default`
# Whether this is the system's default version of Thrift compiler.
# It creates a symlink 'thrift-$VERSION -> thrift' into $PREFIX/bin.
# The default value is TRUE.
#
# Examples
#
# --------
#
# @example
#    thrift { '0.9.2':
#      prefix  => '/usr',
#      version => '0.9.2',
#      default => true
#    }
#
#    thrift { '0.8.0':
#      prefix  => '/usr',
#      version => '0.8.0',
#      default => false
#    }
#
# Authors
# -------
#
# Rafael Bianco <rafa.bianco@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2015 Rafael Bianco, unless otherwise noted.
#
define thrift (
  $prefix  = '/usr/local',
  $version = '0.9.2',
  $default = true
) {
  include thrift::config
  include thrift::params

  $bin_name       = "thrift-${version}"
  $onlyif         = "test ! -f \"\$(which ${bin_name})\""

  $installer_name = "thrift-${version}.tar.gz"
  $installer_url  = "http://archive.apache.org/dist/thrift/${version}/${installer_name}"
  $installer_path = "/tmp/thrift-${version}"

  exec{ "download-thrift-${version}":
    command => "wget ${installer_url} && tar -zxf ${installer_name}",
    path    => $thrift::params::path,
    cwd     => '/tmp',
    creates => $installer_path,
    onlyif  => $onlyif,
    require => [Class['thrift::config']]
  }

  exec{ "configure-thrift-${version}":
    command => "${installer_path}/configure --prefix=${prefix} --program-suffix=-${version}",
    path    => $thrift::params::path,
    cwd     => $installer_path,
    onlyif  => $onlyif,
    require => [Exec["download-thrift-${version}"]]
  }

  exec{ "make-thrift-${version}":
    command => "make",
    path    => $thrift::params::path,
    cwd     => $installer_path,
    onlyif  => $onlyif,
    require => [Exec["configure-thrift-${version}"]]
  }

  exec{ "install-thrift-${version}":
    command => "make install",
    path    => $thrift::params::path,
    cwd     => $installer_path,
    onlyif  => $onlyif,
    require => [Exec["make-thrift-${version}"]]
  }

  if $default {
    class { 'thrift::default':
      version => $version,
      prefix  => $prefix,
      require => [Exec["install-thrift-${version}"]]
    }
  }
}
