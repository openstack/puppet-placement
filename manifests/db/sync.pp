#
# Class to execute placement-manage db sync
#
# ==Parameters
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class placement::db::sync(
  $db_sync_timeout = 300,
) {

  include placement::deps

  exec { 'placement-manage-db-sync':
    command     => 'placement-manage db sync',
    path        => ['/bin', '/usr/bin', '/usr/local/bin'],
    user        => 'placement',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['placement::install::end'],
      Anchor['placement::config::end'],
      Anchor['placement::db::end'],
      Anchor['placement::dbsync::begin']
    ],
    notify      => Anchor['placement::dbsync::end'],
    tag         => ['placement-exec', 'openstack-db']
  }
}
