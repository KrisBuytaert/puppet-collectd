# Class: collectd::plugin::virt
#
class collectd::plugin::virt {
  package { 'collectd-virt':
    ensure  => present,
    notify  => Service['collectd'],
    require => Package['collectd'],
  }
}

