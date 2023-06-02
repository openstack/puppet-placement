# == Define: placement::generic_service
#
# This defined type implements basic placement services.
# It is introduced to attempt to consolidate
# common code.
#
# It also allows users to specify ad-hoc services
# as needed
#
# This define creates a service resource with title placement-${name} and
# conditionally creates a package resource with title placement-${name}
#
# === Parameters:
#
# [*package_name*]
#   (Required) The package name (for the generic_service)
#
# [*service_name*]
#   (Required) The service name (for the generic_service)
#
# [*enabled*]
#   (Optional) Define if the service must be enabled or not
#   Defaults to false.
#
# [*manage_service*]
#   (Optional) Manage or not the service (if a service_name is provided).
#   Defaults to true.
#
# [*ensure_package*]
#   (Optional) Control the ensure parameter for the package resource.
#   Defaults to 'present'.
#
define placement::generic_service(
  $package_name,
  $service_name,
  Boolean $enabled        = true,
  Boolean $manage_service = true,
  $ensure_package         = 'present'
) {

  include placement::deps
  include placement::params

  $placement_title = "placement-${name}"

  # I need to mark that ths package should be
  # installed before placement_config
  if ($package_name) {
    if !defined(Package[$placement_title]) and !defined(Package[$package_name]) {
      package { $placement_title:
        ensure => $ensure_package,
        name   => $package_name,
        tag    => ['openstack', 'placement-package'],
      }
    }
  }

  if $service_name {
    if $manage_service {
      if $enabled {
        $service_ensure = 'running'
      } else {
        $service_ensure = 'stopped'
      }

      service { $placement_title:
        ensure    => $service_ensure,
        name      => $service_name,
        enable    => $enabled,
        hasstatus => true,
        tag       => 'placement-service',
      }
    }
  }
}
