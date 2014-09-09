# == Class: thrift::params
#
class thrift::params {
  $version = '0.9.1'
  $base_url = 'https://archive.apache.org/dist/thrift'
  $prefix = '/usr/local'

  $yum_pkgs = [
    'boost-devel',
    'boost-test',
    'boost-program-options',
    'libevent-devel',
    'automake',
    'libtool',
    'flex',
    'bison',
    'pkgconfig',
    'gcc-c++',
    'openssl-devel',
    'java-1.7.0-openjdk-devel',
  ]

  $apt_pkgs = [
    'libboost-dev',
    'libboost-test-dev',
    'libboost-program-options-dev',
    'libevent-dev',
    'automake',
    'libtool',
    'flex',
    'bison',
    'pkg-config',
    'g++',
    'libssl-dev',
    'openjdk-7-jdk',
    'libcommons-lang3-java',
  ]

  $macports_pkgs = [
    'boost',
    'libevent',
  ]

  case $::osfamily {
    'RedHat', 'Amazon': {
      $pkgs = $yum_pkgs
      $pkg_manager = 'yum'
    }

    'Debian': {
      $pkgs = $apt_pkgs
      $pkg_manager = 'apt'

    }

    'Darwin': {
      $pkgs = $macports_pkgs
      $pkg_manager = 'macports'
    }

    default: {
      fail("${::osfamily} not supported")
    }
  }
}