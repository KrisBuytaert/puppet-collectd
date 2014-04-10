class collectd::plugin::postgresql ($databases, $tables, $queries = {}){

  package {
    'collectd-postgresql':
      ensure  => installed,
      require => Package['collectd'],
  }

  file {
    '/etc/collectd.d/postgresql.conf':
      content => template('collectd/postgresql.conf.erb'),
      group   => '0',
      mode    => '0644',
      owner   => '0',
      notify  => Service['collectd'],
      require => Package['collectd-postgresql','collectd'],
  }

}

