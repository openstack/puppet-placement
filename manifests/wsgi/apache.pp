#
# Copyright (C) 2015 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Class to serve Placement API service.

# Serving Placement API from apache is the recommended way to go for production
# because of limited performance for concurrent accesses.
#
# == Parameters
#
# [*servername*]
#   (Optional) The servername for the virtualhost.
#   Defaults to $::fqdn
#
# [*api_port*]
#   (Optional) The port for Placement API service.
#   Defaults to 8778
#
# [*bind_host*]
#   (Optional) The host/ip address Apache will listen on.
#   Defaults to undef (listen on all ip addresses).
#
# [*path*]
#   (Optional) The prefix for the endpoint.
#   Defaults to '/'
#
# [*ssl*]
#   (Optional) Use ssl ? (boolean)
#   Defaults to true
#
# [*workers*]
#   (Optional) Number of WSGI workers to spawn.
#   Defaults to $::os_workers
#
# [*priority*]
#   (Optional) The priority for the vhost.
#   Defaults to '10'
#
# [*threads*]
#   (Optional) The number of threads for the vhost.
#   Defaults to 1
#
# [*wsgi_process_display_name*]
#   (Optional) Name of the WSGI process display-name.
#   Defaults to undef
#
# [*ssl_cert*]
# [*ssl_key*]
# [*ssl_chain*]
# [*ssl_ca*]
# [*ssl_crl_path*]
# [*ssl_crl*]
# [*ssl_certs_dir*]
#   (Optional) apache::vhost ssl parameters.
#   Default to apache::vhost 'ssl_*' defaults.
#
# [*access_log_file*]
#   (Optional) The log file name for the virtualhost.
#   Defaults to false
#
# [*access_log_format*]
#   (Optional) The log format for the virtualhost.
#   Defaults to false
#
# [*error_log_file*]
#   (Optional) The error log file name for the virtualhost.
#   Defaults to undef
#
# [*vhost_custom_fragment*]
#   (optional) Passes a string of custom configuration
#   directives to be placed at the end of the vhost configuration.
#   Defaults to undef.
#
# DEPRECATED PARAMETERS
#
# [*ensure_package*]
#   (Optional) Control the ensure parameter for the Placement API package ressource.
#   Defaults to undef
#
# == Examples
#
#   include apache
#
#   class { 'placement::wsgi::apache': }
#
class placement::wsgi::apache (
  $servername                = $::fqdn,
  $api_port                  = 8778,
  $bind_host                 = undef,
  $path                      = '/',
  $ssl                       = undef,
  $workers                   = $::os_workers,
  $priority                  = '10',
  $threads                   = 1,
  $wsgi_process_display_name = undef,
  $ssl_cert                  = undef,
  $ssl_key                   = undef,
  $ssl_chain                 = undef,
  $ssl_ca                    = undef,
  $ssl_crl_path              = undef,
  $ssl_crl                   = undef,
  $ssl_certs_dir             = undef,
  $access_log_file           = false,
  $access_log_format         = false,
  $error_log_file            = undef,
  $vhost_custom_fragment     = undef,
  # DEPRECATED PARAMETERS
  $ensure_package            = undef,
) {

  if $ssl == undef {
    warning('Default of the ssl parameter will be changed in a future release')
  }
  $ssl_real = pick($ssl, true)

  include placement::params
  include apache
  include apache::mod::wsgi
  if $ssl_real {
    include apache::mod::ssl
  }

  if $ensure_package != undef {
    warning('The placement::wsgi::apache::ensure_package parameter is deprecated and has no effect')
  }

  file { $::placement::params::httpd_config_file:
    ensure  => present,
    content => "#
# This file has been cleaned by Puppet.
#
# OpenStack Placement API configuration has been moved to:
# - ${priority}-placement_wsgi.conf
#",
  }
  # Ubuntu requires placement-api to be installed before apache to find wsgi script
  Package<| title == 'placement-api'|> -> Package<| title == 'httpd'|>
  Package<| title == 'placement-api' |>
    -> File[$::placement::params::httpd_config_file]
    ~> Service['httpd']

  ::openstacklib::wsgi::apache { 'placement_wsgi':
    bind_host                 => $bind_host,
    bind_port                 => $api_port,
    group                     => 'placement',
    path                      => $path,
    priority                  => $priority,
    servername                => $servername,
    ssl                       => $ssl_real,
    ssl_ca                    => $ssl_ca,
    ssl_cert                  => $ssl_cert,
    ssl_certs_dir             => $ssl_certs_dir,
    ssl_chain                 => $ssl_chain,
    ssl_crl                   => $ssl_crl,
    ssl_crl_path              => $ssl_crl_path,
    ssl_key                   => $ssl_key,
    threads                   => $threads,
    user                      => 'placement',
    vhost_custom_fragment     => $vhost_custom_fragment,
    workers                   => $workers,
    wsgi_daemon_process       => 'placement-api',
    wsgi_process_display_name => $wsgi_process_display_name,
    wsgi_process_group        => 'placement-api',
    wsgi_script_dir           => $::placement::params::wsgi_script_path,
    wsgi_script_file          => 'placement-api',
    wsgi_script_source        => $::placement::params::wsgi_script_source,
    access_log_file           => $access_log_file,
    access_log_format         => $access_log_format,
    error_log_file            => $error_log_file,
  }

}
