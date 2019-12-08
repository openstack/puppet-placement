# == Class: placement::config
#
# This class is used to manage arbitrary placement configurations.
#
# === Parameters
#
# [*placement_config*]
#   (Optional) Allow configuration of arbitrary Placement configurations.
#   The value is an hash of placement_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   placement_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
## DEPRECATED
#
# [*password*]
#   (Optional) Password for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to undef
#
# [*auth_type*]
#   (Optional) Name of the auth type to load.
#   Defaults to undef
#
# [*project_name*]
#   (Optional) Project name for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to undef
#
# [*project_domain_name*]
#   (Optional) Project Domain name for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to undef
#
# [*user_domain_name*]
#   (Optional) User Domain name for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to undef
#
# [*region_name*]
#   (Optional) Region name for connecting to Nova Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to undef
#
# [*valid_interfaces*]
#   (Optional) Interface names used for getting the keystone endpoint for
#   the placement API. Comma separated if multiple.
#   Defaults to undef
#
# [*username*]
#   (Optional) Username for connecting to Nova Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to undef
#
# [*auth_url*]
#   (Optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to undef
#
class placement::config(
  $placement_config    = {},
  # DEPRECATED
  $password            = undef,
  $auth_type           = undef,
  $auth_url            = undef,
  $region_name         = undef,
  $valid_interfaces    = undef,
  $project_domain_name = undef,
  $project_name        = undef,
  $user_domain_name    = undef,
  $username            = undef,
) {

  include placement::deps

  # TODO(tobias-urdin): Remove these deprecated ones in U release.
  $default_parameters = {
    'placement/auth_type'            => { ensure => 'absent' },
    'placement/auth_url'             => { ensure => 'absent' },
    'placement/password'             => { ensure => 'absent', secret => true },
    'placement/project_domain_name'  => { ensure => 'absent' },
    'placement/project_name'         => { ensure => 'absent' },
    'placement/user_domain_name'     => { ensure => 'absent' },
    'placement/username'             => { ensure => 'absent' },
    'placement/region_name'          => { ensure => 'absent' },
    'placement/valid_interfaces'     => { ensure => 'absent' },
  }

  validate_legacy(Hash, 'validate_hash', $default_parameters)
  validate_legacy(Hash, 'validate_hash', $placement_config)
  $placement_parameters = merge($default_parameters, $placement_config)

  create_resources('placement_config', $placement_parameters)
}
