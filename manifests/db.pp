# == Class: placement::db
#
#  Configure the placement database
#
# === Parameters
#
# [*database_sqlite_synchronous*]
#   (Optional) If True, SQLite uses synchronous mode.
#   Defaults to $::os_service_default
#
# [*database_connection*]
#   (Optional) Url used to connect to database.
#   Defaults to 'sqlite:////var/lib/placement/placement.sqlite'
#
# [*database_slave_connection*]
#   (Optional) Connection url to connect to placement slave database (read-only).
#   Defaults to $::os_service_default
#
# [*database_mysql_sql_mode*]
#   (Optional) The SQL mode to be used for MySQL sessions.
#   Defaults to $::os_service_default
#
# [*database_max_pool_size*]
#   (Optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to $::os_service_default
#
# [*database_max_retries*]
#   (Optional) Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   Defaults to $::os_service_default
#
# [*database_retry_interval*]
#   (Optional) Interval between retries of opening a sql connection.
#   Defaults to $::os_service_default
#
# [*database_max_overflow*]
#   (Optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to $::os_service_default
#
# [*database_connection_debug*]
#   (Optional) Verbosity of SQL debugging information: 0=None, 100=Everything.
#   Defaults to $::os_service_default
#
# [*database_connection_trace*]
#   (Optional) Boolean if we should add Python stack traces to SQL as comment strings.
#   Defaults to $::os_service_default
#
# [*database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $::os_service_default
#
class placement::db (
  $database_sqlite_synchronous = $::os_service_default,
  $database_connection         = 'sqlite:////var/lib/placement/placement.sqlite',
  $database_slave_connection   = $::os_service_default,
  $database_mysql_sql_mode     = $::os_service_default,
  $database_max_pool_size      = $::os_service_default,
  $database_max_retries        = $::os_service_default,
  $database_retry_interval     = $::os_service_default,
  $database_max_overflow       = $::os_service_default,
  $database_connection_debug   = $::os_service_default,
  $database_connection_trace   = $::os_service_default,
  $database_pool_timeout       = $::os_service_default,
) {

  include ::placement::deps
  include ::placement::config

  validate_legacy(Oslo::Dbconn, 'validate_re', $database_connection,
    ['^(sqlite|mysql(\+pymysql)?|postgresql):\/\/(\S+:\S+@\S+\/\S+)?'])

  oslo::db { 'placement_config':
    config_group       => 'placement_database',
    sqlite_synchronous => $database_sqlite_synchronous,
    connection         => $database_connection,
    slave_connection   => $database_slave_connection,
    mysql_sql_mode     => $database_mysql_sql_mode,
    max_pool_size      => $database_max_pool_size,
    max_retries        => $database_max_retries,
    retry_interval     => $database_retry_interval,
    max_overflow       => $database_max_overflow,
    connection_debug   => $database_connection_debug,
    connection_trace   => $database_connection_trace,
    pool_timeout       => $database_pool_timeout,
  }
}
