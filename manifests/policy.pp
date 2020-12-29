# == Class: placement::policy
#
# Configure the placement policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for placement
#   Example :
#     {
#       'placement-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'placement-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the nova policy.yaml file
#   Defaults to /etc/placement/policy.yaml
#
class placement::policy (
  $policies    = {},
  $policy_path = '/etc/placement/policy.yaml',
) {

  include placement::deps
  include placement::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::placement::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'placement_config': policy_file => $policy_path }

}
