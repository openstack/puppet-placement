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
#   Defaults to $::placement::params::service_name
#
# [*host*]
#   (optional) The placement api bind address.
#   Defaults to '0.0.0.0'
#
# [*port*]
#   (optional) Th e placement api port.
#   Defaults to '8778'
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*sync_db*]
#   (optional) Run placement-manage db sync on api nodes after installing the package.
#   Defaults to false
#
class placement::api (
  $enabled                        = true,
  $manage_service                 = true,
  $api_service_name               = $::placement::params::service_name,
  $host                           = '0.0.0.0',
  $port                           = '8778',
  $package_ensure                 = 'present',
  $sync_db                        = false,
) inherits placement::params {

  include ::placement::deps

  package { 'placement-api':
    ensure => $package_ensure,
    name   => $::placement::params::api_package_name,
    tag    => ['openstack', 'placement-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
    if $api_service_name == $::placement::params::service_name {
      service { 'placement-api':
        ensure     => $service_ensure,
        name       => $::placement::params::service_name,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => ['placement-service', 'placement-db-sync-service'],
      }
    } elsif $api_service_name == 'httpd' {
      include ::apache::params
      service { 'placement-api':
        ensure => 'stopped',
        name   => $::placement::params::service_name,
        enable => false,
        tag    => ['placement-service', 'placement-db-sync-service'],
      }
      Service['placement-api'] -> Service[$api_service_name]
      Service<| title == 'httpd' |> { tag +> ['placement-service', 'placement-db-sync-service'] }
    }
  }
  if $sync_db {
    include ::placement::db::sync
  }
}
