define thrift::dependencies (
  $pkgs,
) {
  $pkgs.each |$pkg| {
    if ! defined(Package[$pkg]) {
      package { $pkg:
        ensure => installed,
      }
    }
  }
}