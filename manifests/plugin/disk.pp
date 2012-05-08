class collectd::plugin::disk{


  file { '/etc/collectd.d/disk.conf':
    source => 'puppet:///modules/collectd/plugin/disk.conf',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],

  }
}

