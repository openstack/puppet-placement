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
# [*state_path*]
#   (optional) Directory for storing state.
#   Defaults to $facts['os_service_default']
#
# [*randomize_allocation_candidates*]
#   (Optional) Randomize the results of the returned
#   allocation candidates.
#   Defaults to $facts['os_service_default']
#
# [*allocation_conflict_retry_count*]
#   (Optional) The number of retries when confliction is detected in concurrent
#   allocations.
#   Defaults to $facts['os_service_default']
#
class placement(
  $ensure_package                  = 'present',
  $sync_db                         = true,
  $state_path                      = $facts['os_service_default'],
  $randomize_allocation_candidates = $facts['os_service_default'],
  $allocation_conflict_retry_count = $facts['os_service_default'],
) inherits placement::params {

  include placement::deps

  if $sync_db {
    include placement::db::sync
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
    'DEFAULT/state_path'                       : value => $state_path;
    'placement/randomize_allocation_candidates': value => $randomize_allocation_candidates;
    'placement/allocation_conflict_retry_count': value => $allocation_conflict_retry_count;
  }
}
