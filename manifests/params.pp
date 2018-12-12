# Parameters for puppet-placement
#
class placement::params {

  include ::placement::deps
  include ::openstacklib::defaults

  if ($::os_package_type == 'debian') or ($::operatingsystem == 'Fedora') {
    $pyvers = '3'
  } else {
    $pyvers = '2'
  }

  $group = 'placement'

  case $::osfamily {
    'RedHat': {
      # package names
      $package_name        = 'openstack-placement-api'
      $common_package_name = 'openstack-placement-common'
      $python_package_name = "python${pyvers}-placement"
      $service_name        = 'httpd'
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
      $python_package_name = "python${pyvers}-placement"
      $service_name        = 'placement-api'
      $public_url          = 'http://127.0.0.1'
      $internal_url        = 'http://127.0.0.1'
      $admin_url           = 'http://127.0.0.1'
      $wsgi_script_source  = '/usr/bin/placement-api'
      $wsgi_script_path    = '/var/www/cgi-bin/placement'
      $httpd_config_file   = '/etc/apache2/sites-available/nova-placement-api.conf'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }
  } # Case $::osfamily
}
