# Class: collectd::plugin::ping
#
class collectd::plugin::ping ($hosts) {
  package { 'collectd-ping':
    ensure  => installed,
    notify  => Service['collectd'],
    require => Package['collectd'],
  }

  file { '/etc/collectd.d/ping.conf':
    ensure  => present,
    content => template('collectd/ping.conf.erb'),
    group   => '0',
    mode    => '0644',
    notify  => Service['collectd'],
    owner   => '0',
    require => Package['collectd-ping'],
  }
}

