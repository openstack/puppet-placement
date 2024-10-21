# Parameters for puppet-placement
#
class placement::params {

  include placement::deps
  include openstacklib::defaults

  $user  = 'placement'
  $group = 'placement'

  case $facts['os']['family'] {
    'RedHat': {
      # package names
      $package_name        = 'openstack-placement-api'
      $common_package_name = 'openstack-placement-common'
      $python_package_name = 'python3-placement'
      $osc_package_name    = 'python3-osc-placement'
      $service_name        = undef
      $wsgi_script_source  = '/usr/bin/placement-api'
      $wsgi_script_path    = '/var/www/cgi-bin/placement'
    }
    'Debian': {
      $package_name        = 'placement-api'
      $common_package_name = 'placement-common'
      $python_package_name = 'python3-placement'
      $osc_package_name    = 'python3-osc-placement'
      case $facts['os']['name'] {
        'Debian': {
          $service_name    = 'placement-api'
        }
        default: {
          $service_name    = undef
        }
      }
      $wsgi_script_source  = '/usr/bin/placement-api'
      $wsgi_script_path    = '/usr/lib/cgi-bin/placement'
    }
    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}")
    }
  } # Case $facts['os']['family']
}
