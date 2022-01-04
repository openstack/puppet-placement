# Parameters for puppet-placement
#
class placement::params {

  include placement::deps
  include openstacklib::defaults

  $group = 'placement'

  case $::osfamily {
    'RedHat': {
      # package names
      $package_name        = 'openstack-placement-api'
      $common_package_name = 'openstack-placement-common'
      $python_package_name = 'python3-placement'
      $osc_package_name    = 'python3-osc-placement'
      $service_name        = false
      $public_url          = 'http://127.0.0.1/placement'
      $internal_url        = 'http://127.0.0.1/placement'
      $admin_url           = 'http://127.0.0.1/placement'
      $wsgi_script_source  = '/usr/bin/placement-api'
      $wsgi_script_path    = '/var/www/cgi-bin/placement'
    }
    'Debian': {
      $package_name        = 'placement-api'
      $common_package_name = 'placement-common'
      $python_package_name = 'python3-placement'
      $osc_package_name    = 'python3-osc-placement'
      case $::operatingsystem {
        'Debian': {
          $service_name    = 'placement-api'
        }
        default: {
          $service_name    = false
        }
      }
      $public_url          = 'http://127.0.0.1'
      $internal_url        = 'http://127.0.0.1'
      $admin_url           = 'http://127.0.0.1'
      $wsgi_script_source  = '/usr/bin/placement-api'
      $wsgi_script_path    = '/usr/lib/cgi-bin/placement'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }
  } # Case $::osfamily
}
