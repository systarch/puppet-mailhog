# == Class mailhog::service
#
# This class is meant to be called from mailhog.
# It ensures the service is being deployed and is up & running.
#

class mailhog::service inherits mailhog {

  if ! ($mailhog::service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if $mailhog::service_manage == true {
    service { $mailhog::service_name:
      ensure     => ($mailhog::ensure == present) ? { true => $mailhog::service_ensure, default => stopped },
      enable     => ($mailhog::ensure == present) ? { true => $mailhog::service_enable, default => false },
      name       => $mailhog::service_name,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}
