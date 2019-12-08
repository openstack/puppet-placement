#
# Class to execute placement-manage db sync
#
class placement::db::sync {

  include placement::deps

  exec { 'placement-manage-db-sync':
    command     => 'placement-manage db sync',
    path        => ['/bin', '/usr/bin', '/usr/local/bin'],
    user        => 'placement',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
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
