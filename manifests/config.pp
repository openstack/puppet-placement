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
class placement::config (
  Hash $placement_config = {},
) {
  include placement::deps

  create_resources('placement_config', $placement_config)
}
