class collectd::plugin::memcached {

  file { '/etc/collectd.d/memcached.conf':
    content => template('collectd/memcached.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
  }

}