# == Define: thrift::instool
#
#
define thrift::install (
  $url,
  $version,
  $prefix,
  $default_version = true,
  $onlyif = undef,
) {
  include ant
  
  if $prefix {
    $prefix_opts = " --prefix=${prefix}"
    $bin_path = "${prefix}/bin"
    $src_path = "${prefix}/src" 
  } else {
    $prefix_opts = ''
    $bin_path = '/usr/local/bin'
    $src_path = '/usr/local/src'
  }

  $suffix = "-${version}"
  $app_name = "thrift${suffix}"
  $cwd_path = "${src_path}/${app_name}"

  archive { $url:
    ensure   => present,
    name     => $app_name,
    url      => $url,
    target   => $src_path,
    checksum => false,
  }

  exec { "configure-${app_name}":
    command  => "./configure --without-tests ${prefix_opts} --without-python --program-suffix=${suffix}",
    provider => shell,
    cwd      => $cwd_path,
    onlyif   => $onlyif,
    require  => Archive[$url],
  }

  exec { "make-${app_name}":
    command  => "make | tee /tmp/thrift-${version}.log",
    provider => shell,
    cwd      => $cwd_path,
    timeout  => 1800,
    onlyif   => $onlyif,
    require  => Exec["configure-${app_name}"]
  }

  exec { "make-install-${app_name}":
    command  => 'make install',
    provider => shell,
    cwd      => $cwd_path,
    onlyif   => $onlyif,
    require  => Exec["make-${app_name}"],
  }

  exec { "make-clean-${app_name}":
    command  => 'make clean',
    provider => shell,
    cwd      => $cwd_path,
    onlyif   => $onlyif,
    require  => Exec["make-install-${app_name}"]
  }
  
  if $default_version {
    exec { "symlink-defaul-${app_name}":
      command  => "ln -s ${app_name} thrift",
      cwd      => $bin_path,
      provider => shell,
      require  => Exec["make-clean-${app_name}"],
      onlyif   => [
        "test ! -x ${bin_path}/thrift"
      ]
    }
  } 
  notify {"install ${name} from ${url} to ${src_path}/${app_name}":}
}