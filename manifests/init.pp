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
#
# [*randomize_allocation_candidates*]
#   (Optional) Randomize the results of the returned
#   allocation candidates.
#   Defaults to $::os_service_default
#
class placement(
  $ensure_package                  = 'present',
  $sync_db                         = true,
  $randomize_allocation_candidates = $::os_service_default,
) inherits placement::params {

  include ::placement::deps

  if $sync_db {
    include ::placement::db::sync
  }

  package { 'python-placement':
    ensure => $ensure_package,
    name   => $::placement::params::python_package_name,
    tag    => ['openstack', 'placement-package'],
  }

  package { 'placement-common':
    ensure  => $ensure_package,
    name    => $::placement::params::common_package_name,
    require => Package['python-placement'],
    tag     => ['openstack', 'placement-package'],
  }

  placement_config {
    'placement/randomize_allocation_candidates': value => $randomize_allocation_candidates;
  }
}
