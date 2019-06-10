# == Class: placement::config
#
# This class is used to manage arbitrary placement configurations.
#
# === Parameters
#
# [*password*]
#   (Required) Password for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#
# [*auth_type*]
#   (Optional) Name of the auth type to load.
#   Defaults to 'password'
#
# [*project_name*]
#   (Optional) Project name for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (Optional) Project Domain name for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*user_domain_name*]
#   (Optional) User Domain name for connecting to Nova Placement API service in
#   admin context through the OpenStack Identity service.
#   Defaults to 'Default'
#
# [*region_name*]
#   (Optional) Region name for connecting to Nova Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to 'RegionOne'
#
# [*valid_interfaces*]
#   (Optional) Interface names used for getting the keystone endpoint for
#   the placement API. Comma separated if multiple.
#   Defaults to $::os_service_default
#
# [*username*]
#   (Optional) Username for connecting to Nova Placement API service in admin context
#   through the OpenStack Identity service.
#   Defaults to 'placement'
#
# [*auth_url*]
#   (Optional) Points to the OpenStack Identity server IP and port.
#   This is the Identity (keystone) admin API server IP and port value,
#   and not the Identity service API IP and port.
#   Defaults to 'http://127.0.0.1:5000/v3'
#
# [*placement_config*]
#   (optional) Allow configuration of arbitrary Placement configurations.
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
class placement::config(
  $password            = false,
  $auth_type           = 'password',
  $auth_url            = 'http://127.0.0.1:5000/v3',
  $region_name         = 'RegionOne',
  $valid_interfaces    = $::os_service_default,
  $project_domain_name = 'Default',
  $project_name        = 'services',
  $user_domain_name    = 'Default',
  $username            = 'placement',
  $placement_config    = {},
) {

  include ::placement::deps

  $default_parameters = {
    'placement/auth_type'            => { value => $auth_type},
    'placement/auth_url'             => { value => $auth_url},
    'placement/password'             => { value => $password, secret => true},
    'placement/project_domain_name'  => { value => $project_domain_name},
    'placement/project_name'         => { value => $project_name},
    'placement/user_domain_name'     => { value => $user_domain_name},
    'placement/username'             => { value => $username},
    'placement/region_name'          => { value => $region_name},
    'placement/valid_interfaces'     => { value => $valid_interfaces},
  }

  validate_legacy(Hash, 'validate_hash', $default_parameters)
  validate_legacy(Hash, 'validate_hash', $placement_config)
  $placement_parameters = merge($default_parameters, $placement_config)

  create_resources('placement_config', $placement_parameters)

}
