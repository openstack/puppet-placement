# Parameters for puppet-placement
#
class placement::params {

  include placement::deps
  include openstacklib::defaults

  $pyvers = $::openstacklib::defaults::pyvers
  $pyvers_real = $pyvers ? {
    '' => '2',
    default => $pyvers
  }

  $group = 'placement'

  case $::osfamily {
    'RedHat': {
      # package names
      $package_name        = 'openstack-placement-api'
      $common_package_name = 'openstack-placement-common'
      $python_package_name = "python${pyvers_real}-placement"
      $osc_package_name    = "python${pyvers_real}-osc-placement"
      $service_name        = false
      $public_url          = 'http://127.0.0.1/placement'
      $internal_url        = 'http://127.0.0.1/placement'
      $admin_url           = 'http://127.0.0.1/placement'
      $wsgi_script_source  = '/usr/bin/placement-api'
      $wsgi_script_path    = '/var/www/cgi-bin/placement'
      $httpd_config_file   = '/etc/httpd/conf.d/00-placement-api.conf'
    }
    'Debian': {
      $package_name        = 'placement-api'
      $common_package_name = 'placement-common'
      $python_package_name = "python${pyvers_real}-placement"
      $osc_package_name    = "python${pyvers_real}-osc-placement"
      case $::os_package_type {
        'debian': {
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
      $httpd_config_file   = '/etc/apache2/sites-available/placement-api.conf'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }
  } # Case $::osfamily
}
