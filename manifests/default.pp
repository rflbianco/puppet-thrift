# === Class: thrift::default
#
# Sets a given version of thrift as the default one.
# It does it through a symlink '$PREFIX/bin/thrift -> thrift-$VERSION'

class thrift::default (
  $prefix,
  $version
) {
  $bin_name = "thrift-${version}"

  include thrift::params

  exec{ "set-thrift-default":
    command => "ln -s \"\$(which ${bin_name})\" thrift",
    path    => $thrift::params::path,
    cwd     => "${prefix}/bin",
    creates => "${prefix}/bin/thrift"
  }
}