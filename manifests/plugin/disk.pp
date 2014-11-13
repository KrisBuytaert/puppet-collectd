# Class: collectd::plugin::disk
#
class collectd::plugin::disk{
  file { '/etc/collectd.d/disk.conf':
    ensure => present,
    group  => '0',
    mode   => '0644',
    notify => Service['collectd'],
    owner  => '0',
    source => 'puppet:///modules/collectd/plugin/disk.conf',
  }
}

