class collectd::plugin::ping($hosts){

  package{
    'collectd-ping':
      ensure  => installed,
      notify  => Service['collectd'],
      require => Package['collectd'],
  }

  file { '/etc/collectd.d/ping.conf':
    content => template('collectd/ping.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
    require => Package['collectd-ping'],

  }
}

