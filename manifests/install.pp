# == Class mailhog::install
#
# This class is called from mailhog for install.
#

class mailhog::install inherits mailhog {

  # Add user to run mailhog with lower privileges
  user { $mailhog::user:
    ensure => 'present',
    home   => $mailhog::user_home,
    system => true,
    shell  => '/usr/sbin/nologin',
  }

  package { 'daemon':
    ensure => present,
  }

  # Download Mailhog binary
  if $mailhog::download_mailhog {

    file { $mailhog::user_home:
      ensure => directory,
      mode   => '0755',
      owner  => mailhog,
      group  => root,
    }

    file { $mailhog::binary_path:
      ensure  => directory,
      mode    => '0755',
      owner   => root,
      group   => root,
      require => File[$mailhog::user_home],
    }
    $mailhog_version_file = "${mailhog::binary_path}/mailhog-${mailhog::mailhog_version}"

    exec { "Download MailHog ${mailhog::mailhog_version}":
      command => "/usr/bin/curl -o '${mailhog_version_file}' -L '${mailhog::download_url}'",
      require => [
        Package['curl'],
        File[ $mailhog::binary_path ],
      ],
      creates => $mailhog_version_file,
      notify  => File[$mailhog_version_file],
    }

    # assert the versioned binary is owned by root
    file { $mailhog_version_file:
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0755',
      require => Exec["Download MailHog ${mailhog::mailhog_version}"],
      notify  => File[$mailhog::binary_file],
    }

    file { $mailhog::binary_file:
      ensure => link,
      force  => true,
      target => $mailhog_version_file,
    }

    if ! defined(Package['curl']) {
      package { 'curl':
        ensure => installed,
      }
    }
  }

  # else use binary files located on puppet master.
  else {
    file { $mailhog::binary_file:
      ensure => file,
      mode   => '0755',
      owner  => root,
      group  => root,
      force  => true,
      source => $mailhog::source_file,
    }
  }

  # Deploy mailhog init script
  file { $mailhog::initd:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template($mailhog::initd_template),
  }

}
