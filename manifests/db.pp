# == Class: placement::db
#
#  Configure the placement database
#
# === Parameters
#
# [*database_connection*]
#   (Optional) Url used to connect to database.
#   Defaults to 'sqlite:////var/lib/placement/placement.sqlite'.
#
class placement::db (
  $database_connection = 'sqlite:////var/lib/placement/placement.sqlite',
) {

  include ::placement::deps
  include ::placement::config

  validate_re($database_connection,
    '^(sqlite|mysql(\+pymysql)?|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

  placement_config {
    'placement_database/connection': value => $database_connection;
  }

}
