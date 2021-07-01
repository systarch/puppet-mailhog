# Class: mailhog
# ===========================
#
#
# Ian Kent did a wonderful job on developing MailHog 
# (https://github.com/mailhog/). 
#
# A nice little tool you could use to receive mail and show them in a smart
#  WebUI. 
# The advantage is MailHog doesn't care about domains and users. It just lists
# all received mails (no matter what source or destination) in its WebUI.
# So it's perfectly easy to check what mails are processed on the local system. 
#
# Mailhog sets up a small MTA like daemon to receive incoming mail. It defaults
# to port 1025 for incoming smtp traffic as the service is running as 
# non-root user.
# So make sure to send all mail to this port. To do this one could use a tool
# like nullmailer. If required one could release individual mails to a real
# world SMTP server for convenience. 
#
#
# This puppet module installs and configures MailHog on a linux system. 
# It provides a init.d script along with a configuration.
#
#
#
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#

class mailhog (
  $ensure                                 = present,
  # MailHog config values
  Stdlib::IP::Address $api_bind_ip        = $mailhog::params::api_bind_ip,
  Stdlib::Port $api_bind_port             = $mailhog::params::api_bind_port,
  Optional[Stdlib::Host] $api_bind_host   = $mailhog::params::api_bind_host,
  Optional[String] $cors_origin           = $mailhog::params::cors_origin,
  Stdlib::Host $hostname                  = $mailhog::params::hostname,
  Boolean $invite_jim                     = $mailhog::params::invite_jim,
  Numeric $jim_accept                     = $mailhog::params::jim_accept,
  Numeric $jim_disconnect                 = $mailhog::params::jim_disconnect,
  Numeric $jim_linkspeed_affect           = $mailhog::params::jim_linkspeed_affect,
  Numeric $jim_linkspeed_max              = $mailhog::params::jim_linkspeed_max,
  Numeric $jim_linkspeed_min              = $mailhog::params::jim_linkspeed_min,
  Numeric $jim_reject_auth                = $mailhog::params::jim_reject_auth,
  Numeric $jim_reject_recipient           = $mailhog::params::jim_reject_recipient,
  Numeric $jim_reject_sender              = $mailhog::params::jim_reject_sender,
  String $mongo_coll                      = $mailhog::params::mongo_coll,
  String $mongo_db                        = $mailhog::params::mongo_db,
  Stdlib::IP::Address $mongo_uri_ip       = $mailhog::params::mongo_uri_ip,
  Stdlib::Port $mongo_uri_port            = $mailhog::params::mongo_uri_port,
  Optional[Stdlib::Host] $outgoing_smtp   = $mailhog::params::outgoing_smtp,
  Stdlib::IP::Address $smtp_bind_addr_ip  = $mailhog::params::smtp_bind_addr_ip,
  Stdlib::Port $smtp_bind_addr_port       = $mailhog::params::smtp_bind_addr_port,
  String $storage                         = $mailhog::params::storage,
  Stdlib::IP::Address $ui_bind_addr_ip    = $mailhog::params::ui_bind_addr_ip,
  Stdlib::Port $ui_bind_addr_port         = $mailhog::params::ui_bind_addr_port,

  # Puppet module config values
  String $config_template                 = $mailhog::params::config_template,
  String $initd_template                  = $mailhog::params::initd_template,
  Stdlib::AbsolutePath $config            = $mailhog::params::config,
  Stdlib::AbsolutePath $initd             = $mailhog::params::initd,
  Boolean $service_manage                 = $mailhog::params::service_manage,
  Boolean $service_enable                 = $mailhog::params::service_enable,
  Stdlib::Ensure::Service $service_ensure = $mailhog::params::service_ensure,
  String $service_name                    = $mailhog::params::service_name,
  Stdlib::AbsolutePath $binary_path       = $mailhog::params::binary_path,
  Stdlib::AbsolutePath $binary_file       = $mailhog::params::binary_file,
  Stdlib::Filesource $source_file         = $mailhog::params::source_file,
  Stdlib::HTTPUrl $download_url           = $mailhog::params::download_url,
  String $user                            = $mailhog::params::user,
  String $mailhog_version                 = $mailhog::params::mailhog_version,
  Stdlib::AbsolutePath $user_home         = $mailhog::params::user_home,
  Boolean $download_mailhog               = $mailhog::params::download_mailhog,
  Boolean $manage_curl                    = true,
) inherits mailhog::params {

  contain mailhog::install
  contain mailhog::config
  contain mailhog::service

  if $ensure == present {
    Class['mailhog::install'] -> Class['mailhog::config'] ~> Class['mailhog::service']
  } else {
    Class['mailhog::service'] -> Class['mailhog::install'] -> Class['mailhog::config']
  }
}
