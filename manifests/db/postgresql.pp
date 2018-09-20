# == Class: placement::db::postgresql
#
# Class that configures postgresql for placement
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'placement'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'placement'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
# == Dependencies
#
# == Examples
#
# == Authors
#
# == Copyright
#
class placement::db::postgresql(
  $password,
  $dbname     = 'placement',
  $user       = 'placement',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ::placement::deps

  Class['placement::db::postgresql'] -> Service<| title == 'placement' |>

  ::openstacklib::db::postgresql { 'placement':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['placement::db::begin']
  ~> Class['placement::db::postgresql']
  ~> Anchor['placement::db::end']

}
