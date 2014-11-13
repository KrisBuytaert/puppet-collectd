# Class: collectd::plugin::postgresql
#
class collectd::plugin::postgresql (
  $databases,
  $queries = {},
  $tables,
) {
  package { 'collectd-postgresql':
    ensure  => present,
    require => Package['collectd'],
  }

  file { '/etc/collectd.d/postgresql.conf':
    ensure  => present,
    content => template('collectd/postgresql.conf.erb'),
    group   => '0',
    mode    => '0644',
    notify  => Service['collectd'],
    owner   => '0',
    require => Package['collectd-postgresql','collectd'],
  }
}

