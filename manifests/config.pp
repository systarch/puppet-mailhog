# == Class mailhog::config
#
# This class is called from mailhog to deploy the mailhog config.
#

class mailhog::config inherits mailhog {

  file { $mailhog::config:
    ensure  => ($mailhog::ensure == present) ? { true => file, default => absent },
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($mailhog::config_template),
  }

}
