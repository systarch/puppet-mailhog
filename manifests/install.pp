# == Class mailhog::install
#
# This class is called from mailhog for install.
#

class mailhog::install inherits mailhog {

  # Add user to run mailhog with lower privileges
  user { $mailhog::user:
    ensure => $mailhog::ensure,
    home   => $mailhog::user_home,
    system => true,
    shell  => '/usr/sbin/nologin',
  }

  package { 'daemon':
    ensure => $mailhog::ensure,
  }

  # Download Mailhog binary
  if $mailhog::download_mailhog {

    file { $mailhog::user_home:
      ensure => ($mailhog::ensure == present) ? { true => directory, default => absent },
      mode   => '0755',
      owner  => mailhog,
      group  => root,
      force  => ($mailhog::ensure != present),
    }

    file { $mailhog::binary_path:
      ensure  => ($mailhog::ensure == present) ? { true => directory, default => absent },
      mode    => '0755',
      owner   => root,
      group   => root,
      require => File[$mailhog::user_home],
    }
    $mailhog_version_file = "${mailhog::binary_path}/mailhog-${mailhog::mailhog_version}"

    if $mailhog::ensure == present {
      exec { "Download MailHog ${mailhog::mailhog_version}":
        command => "/usr/bin/curl -o '${mailhog_version_file}' -L '${mailhog::download_url}'",
        creates => $mailhog_version_file,
        notify  => File[$mailhog_version_file],
        require => [
          Package['curl'],
          File[ $mailhog::binary_path ],
        ],
      }
    }

    # assert the versioned binary is owned by root
    file { $mailhog_version_file:
      ensure => ($mailhog::ensure == present) ? { true => file, default => absent },
      owner  => root,
      group  => root,
      mode   => '0755',
      notify => File[$mailhog::binary_file],
    }

    file { $mailhog::binary_file:
      ensure => ($mailhog::ensure == present) ? { true => link, default => absent },
      force  => true,
      target => $mailhog_version_file,
    }

    if ! defined(Package['curl']) {
      package { 'curl':
        ensure => ($mailhog::ensure == present) ? { true => installed, default => absent },
      }
    }
  }

  # else use binary files located on puppet master.
  else {
    file { $mailhog::binary_file:
      ensure => ($mailhog::ensure == present) ? { true => file, default => absent },
      mode   => '0755',
      owner  => root,
      group  => root,
      force  => true,
      source => $mailhog::source_file,
    }
  }

  # Deploy mailhog init script
  file { $mailhog::initd:
    ensure  => ($mailhog::ensure == present) ? { true => file, default => absent },
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template($mailhog::initd_template),
  }

}
