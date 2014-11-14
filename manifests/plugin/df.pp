# Class: collectd::plugin::df
#
class collectd::plugin::df {
  file { '/etc/collectd.d/df.conf':
    ensure => present,
    group  => '0',
    mode   => '0644',
    notify => Service['collectd'],
    owner  => '0',
    source => 'puppet:///modules/collectd/plugin/df.conf',
  }
}

