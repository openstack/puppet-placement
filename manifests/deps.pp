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

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the placement-package tag and the placement-support-package
  # tag.  Note: the package resources here will have a 'before' relationship on
  # the placement::install::end anchor.  The line between placement-support-package
  # and placement-package should be whether or not placement services would
  # need to be restarted if the package state was changed.
  Anchor['placement::install::begin']
  -> Package<| tag == 'placement-support-package'|>
  -> Anchor['placement::install::end']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['placement::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['placement::config::begin']
  -> Openstacklib::Policy<| tag == 'placement' |>
  -> Anchor['placement::config::end']

  # On any uwsgi config change, we must restart Placement.
  Anchor['placement::config::begin']
  -> Placement_api_uwsgi_config<||>
  ~> Anchor['placement::config::end']

  # Installation or config changes will always restart services.
  Anchor['placement::install::end'] ~> Anchor['placement::service::begin']
  Anchor['placement::config::end']  ~> Anchor['placement::service::begin']

}
