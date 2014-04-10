class collectd::plugin::df{


  file { '/etc/collectd.d/df.conf':
    source => 'puppet:///modules/collectd/plugin/df.conf',
    group  => '0',
    mode   => '0644',
    owner  => '0',
    notify => Service['collectd'],

  }
}

