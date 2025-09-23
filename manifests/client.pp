# == Class placement::client
#
# installs placement client
#
# === Parameters:
#
# [*ensure*]
#   (optional) The state for the placement client package
#   Defaults to 'present'
#
class placement::client (
  Stdlib::Ensure::Package $ensure = 'present'
) {
  include placement::deps
  include placement::params

  package { 'python-osc-placement':
    ensure => $ensure,
    name   => $placement::params::osc_package_name,
    tag    => ['openstack', 'openstackclient'],
  }

  include openstacklib::openstackclient
}
