# == Class: placement
#
# Full description of class placement here.
#
# === Parameters
#
# [*ensure_package*]
#   (Optional) The state of nova packages
#   Defaults to 'present'
#
# [*sync_db*]
#   (Optional) Run db sync on the node.
#   Defaults to true

class placement(
  $ensure_package = 'present',
  $sync_db        = true,
) inherits placement::params {

  include ::placement::deps

  if $sync_db {
    include ::placement::db::sync
  }

  package { 'python-placement':
    ensure  => $ensure_package,
    name    => $::placement::params::python_package_name,
    tag     => ['openstack', 'placement-package'],
  }

  package { 'placement-common':
    ensure  => $ensure_package,
    name    => $::placement::params::common_package_name,
    require => Package['python-placement'],
    tag     => ['openstack', 'placement-package'],
  }

}
