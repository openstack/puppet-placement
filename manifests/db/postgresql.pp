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
# [*encoding*]
#   (Optional) The charset to use for the database.
#   Default to undef.
#
# [*privileges*]
#   (Optional) Privileges given to the database user.
#   Default to 'ALL'
#
class placement::db::postgresql(
  $password,
  $dbname     = 'placement',
  $user       = 'placement',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include placement::deps

  openstacklib::db::postgresql { 'placement':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['placement::db::begin']
  ~> Class['placement::db::postgresql']
  ~> Anchor['placement::db::end']

}
