# == Class: placement::deps
#
# placement anchors and dependency management
#
class placement::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'placement::install::begin': }
  -> Package<| tag == 'placement-package'|>
  ~> anchor { 'placement::install::end': }
  -> anchor { 'placement::config::begin': }
  -> Placement_config<||>
  ~> anchor { 'placement::config::end': }
  -> anchor { 'placement::db::begin': }
  -> anchor { 'placement::db::end': }
  ~> anchor { 'placement::dbsync::begin': }
  -> anchor { 'placement::dbsync::end': }
  ~> anchor { 'placement::service::begin': }
  ~> Service<| tag == 'placement-service' |>
  ~> anchor { 'placement::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['placement::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['placement::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['placement::config::end']

  # Installation or config changes will always restart services.
  Anchor['placement::install::end'] ~> Anchor['placement::service::begin']
  Anchor['placement::config::end']  ~> Anchor['placement::service::begin']

}
