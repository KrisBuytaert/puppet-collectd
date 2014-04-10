class collectd::plugin::exec($execs){

  file { '/etc/collectd.d/exec.conf':
    content => template('collectd/exec.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
    require => Package['collectd'],

  }
}

