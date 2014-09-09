define thrift::dependencies (
  $pkgs,
  $pkg_manager,
) {
  $pkgs.each |$pkg| {
    if ! defined(Package[$pkg]) {
      package { $pkg:
        ensure      => installed,
        pkg_manager => $pkg_manager,
      }
    }
  }
}