# == Class: placement::db
#
#  Configure the placement database
#
# === Parameters
#
# [*database_sqlite_synchronous*]
#   (Optional) If True, SQLite uses synchronous mode.
#   Defaults to $facts['os_service_default']
#
# [*database_connection*]
#   (Optional) Url used to connect to database.
#   Defaults to 'sqlite:////var/lib/placement/placement.sqlite'
#
# [*database_slave_connection*]
#   (Optional) Connection url to connect to placement slave database (read-only).
#   Defaults to $facts['os_service_default']
#
# [*database_connection_recycle_time*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to $facts['os_service_default']
#
# [*database_mysql_sql_mode*]
#   (Optional) The SQL mode to be used for MySQL sessions.
#   Defaults to $facts['os_service_default']
#
# [*database_max_pool_size*]
#   (Optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to $facts['os_service_default']
#
# [*database_max_retries*]
#   (Optional) Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   Defaults to $facts['os_service_default']
#
# [*database_retry_interval*]
#   (Optional) Interval between retries of opening a sql connection.
#   Defaults to $facts['os_service_default']
#
# [*database_max_overflow*]
#   (Optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to $facts['os_service_default']
#
# [*database_connection_debug*]
#   (Optional) Verbosity of SQL debugging information: 0=None, 100=Everything.
#   Defaults to $facts['os_service_default']
#
# [*database_connection_trace*]
#   (Optional) Boolean if we should add Python stack traces to SQL as comment strings.
#   Defaults to $facts['os_service_default']
#
# [*database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $facts['os_service_default']
#
# [*mysql_enable_ndb*]
#   (Optional) If True, transparently enables support for handling MySQL
#   Cluster (NDB).
#   Defaults to $facts['os_service_default']
#
class placement::db (
  $database_sqlite_synchronous      = $facts['os_service_default'],
  $database_connection              = 'sqlite:////var/lib/placement/placement.sqlite',
  $database_slave_connection        = $facts['os_service_default'],
  $database_connection_recycle_time = $facts['os_service_default'],
  $database_mysql_sql_mode          = $facts['os_service_default'],
  $database_max_pool_size           = $facts['os_service_default'],
  $database_max_retries             = $facts['os_service_default'],
  $database_retry_interval          = $facts['os_service_default'],
  $database_max_overflow            = $facts['os_service_default'],
  $database_connection_debug        = $facts['os_service_default'],
  $database_connection_trace        = $facts['os_service_default'],
  $database_pool_timeout            = $facts['os_service_default'],
  $mysql_enable_ndb                 = $facts['os_service_default'],
) {
  include placement::deps

  oslo::db { 'placement_config':
    config_group            => 'placement_database',
    sqlite_synchronous      => $database_sqlite_synchronous,
    connection              => $database_connection,
    slave_connection        => $database_slave_connection,
    connection_recycle_time => $database_connection_recycle_time,
    mysql_sql_mode          => $database_mysql_sql_mode,
    max_pool_size           => $database_max_pool_size,
    max_retries             => $database_max_retries,
    retry_interval          => $database_retry_interval,
    max_overflow            => $database_max_overflow,
    connection_debug        => $database_connection_debug,
    connection_trace        => $database_connection_trace,
    pool_timeout            => $database_pool_timeout,
    mysql_enable_ndb        => $mysql_enable_ndb,
  }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db['placement_config'] -> Anchor['placement::dbsync::begin']
}
