# Class: collectd::plugin::sensors
#
class collectd::plugin::sensors{
  package { 'collectd-sensors':
    ensure  => 'absent',
    notify  => Service['collectd'],
    require => Package['collectd'],
  }
}

