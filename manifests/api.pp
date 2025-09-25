# Installs & configure the placement API service
#
# == Parameters
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true
#
# [*manage_service*]
#   (optional) If Puppet should manage service startup / shutdown.
#   Defaults to true.
#
# [*api_service_name*]
#   (Optional) Name of the service that will be providing the
#   server functionality of placement-api.
#   If the value is 'httpd', this means placement-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'placement::wsgi::apache'...}
#   to make placement-api be a web app using apache mod_wsgi.
#   Defaults to $placement::params::service_name
#
# [*ensure_package*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*sync_db*]
#   (optional) Run placement-manage db sync on api nodes after installing the package.
#   Defaults to false
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $facts['os_service_default'].
#
# DEPRECATED PARAMETERS
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to undef
#
class placement::api (
  Boolean $enabled                        = true,
  Boolean $manage_service                 = true,
  $api_service_name                       = $placement::params::service_name,
  Stdlib::Ensure::Package $ensure_package = 'present',
  Boolean $sync_db                        = false,
  $enable_proxy_headers_parsing           = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  Optional[Stdlib::Ensure::Package] $package_ensure = undef,
) inherits placement::params {
  include placement::deps
  include placement::policy

  if $package_ensure {
    warning('The package_ensure parameter is deprecated. Use the ensure_package parameter instead.')
  }
  $ensure_package_real = $package_ensure ? {
    undef   => $ensure_package,
    default => $package_ensure,
  }

  if $manage_service {
    if $api_service_name == 'httpd' {
      # The following logic is currently required only in Debian, because
      # the other distributions don't provide an independent service for
      # placement
      if $placement::params::service_name {
        service { 'placement-api':
          ensure => 'stopped',
          name   => $placement::params::service_name,
          enable => false,
          tag    => ['placement-service'],
        }
        Service['placement-api'] -> Service[$api_service_name]
      }
      $api_service_name_real = false
      Service <| title == 'httpd' |> { tag +> 'placement-service' }
    } else {
      $api_service_name_real = $api_service_name

      # On any uwsgi config change, we must restart Placement API.
      Placement_api_uwsgi_config<||> ~> Service['placement-api']
    }
  } else {
    $api_service_name_real = $api_service_name
  }

  placement::generic_service { 'api':
    service_name   => $api_service_name_real,
    package_name   => $placement::params::package_name,
    manage_service => $manage_service,
    enabled        => $enabled,
    ensure_package => $ensure_package_real,
  }

  if $sync_db {
    include placement::db::sync
  }

  oslo::middleware { 'placement_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
  }
}
