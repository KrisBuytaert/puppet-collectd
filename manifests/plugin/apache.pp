# Class: collectd::plugin::apache
#
class collectd::plugin::apache(
  $statusurl = 'http://localhost:8008/mod_status?auto',
  $managelocalvhost = 'no',
) {
  # On debian boxen the http://localhost/server-status?auto is enabled
  # Needs additional changes to the http config if on other distro therefore
  # not including it by default

  if ($::osfamily == 'RedHat') {
    package {'collectd-apache':
      ensure => 'present',
    }
  }

  if $managelocalvhost {
    file { '/etc/httpd/conf.d/status_8008.conf':
      ensure => present,
      group  => '0',
      mode   => '0644',
      owner  => '0',
      source => 'puppet:///modules/collectd/plugin/status_8008.conf',
    }
  }

  file { '/etc/collectd.d/apache.conf':
    ensure  => present,
    content => template('collectd/apache.conf.erb'),
    group   => '0',
    mode    => '0644',
    notify  => Service['collectd'],
    owner   => '0',
  }
}

