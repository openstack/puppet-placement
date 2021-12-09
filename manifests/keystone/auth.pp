# == Class: placement::keystone::auth
#
# Configures placement user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for placement user.
#
# [*ensure*]
#   (Optional) Ensure state of keystone service identity.
#   Defaults to 'present'.
#
# [*auth_name*]
#   (Optional) Username for placement service.
#   Defaults to 'placement'.
#
# [*email*]
#   (Optional) Email for placement user.
#   Defaults to 'placement@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for placement user.
#   Defaults to 'services'.
#
# [*configure_endpoint*]
#   (Optional) Should placement endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to 'true'.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'placement'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of 'placement'.
#
# [*service_description*]
#   (Optional) Description of the service.
#   Defaults to 'OpenStack Placement Service'
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   Defaults to 'http://127.0.0.1:8778'
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   Defaults to 'http://127.0.0.1:8778'
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1:8778'
#
class placement::keystone::auth (
  $password,
  $ensure              = 'present',
  $auth_name           = 'placement',
  $email               = 'placement@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'placement',
  $service_description = 'OpenStack Placement Service',
  $service_type        = 'placement',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8778',
  $admin_url           = 'http://127.0.0.1:8778',
  $internal_url        = 'http://127.0.0.1:8778',
) {

  include placement::deps

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] -> Anchor['placement::service::end']
  }

  if $configure_endpoint {
    Keystone_endpoint["${region}/${service_name}::${service_type}"] -> Anchor['placement::service::end']
  }

  keystone::resource::service_identity { 'placement':
    ensure              => $ensure,
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
