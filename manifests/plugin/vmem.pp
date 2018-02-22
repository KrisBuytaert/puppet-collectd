class collectd::plugin::vmem (
  $verbose = 'false',
) {
  file { '/etc/collectd.d/vmem.conf':
    source => 'puppet:///modules/collectd/plugin/vmem.conf',
    group  => '0',
    mode   => '0644',
    owner  => '0',
    notify => Service['collectd'],
  }
}
