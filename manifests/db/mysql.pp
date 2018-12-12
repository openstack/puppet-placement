# The placement::db::mysql class implements mysql backend for placement
#
# This class can be used to create tables, users and grant
# privilege for a mysql placement database.
#
# == parameters
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
# [*host*]
#   (Optional) The default source host user is allowed to connect from.
#   Defaults to '127.0.0.1'
#
# [*allowed_hosts*]
#   (Optional) Other hosts the user is allowed to connect from.
#   Defaults to 'undef'.
#
# [*charset*]
#   (Optional) The database charset.
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) The database collate.
#   Only used with mysql modules >= 2.2.
#   Defaults to 'utf8_general_ci'
#
class placement::db::mysql(
  $password,
  $dbname        = 'placement',
  $user          = 'placement',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef
) {

  include ::placement::deps

  validate_string($password)

  ::openstacklib::db::mysql { 'placement':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['placement::db::begin']
  ~> Class['placement::db::mysql']
  ~> Anchor['placement::db::end']

}
