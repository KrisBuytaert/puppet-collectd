class collectd::plugin::vmem (
  $verbose = 'true',
) {
  file { '/etc/collectd.d/vmem.conf':
    content => template('collectd/plugin/vmem.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
  }
}
