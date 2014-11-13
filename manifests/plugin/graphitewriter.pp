# Class: collectd::plugin::graphitewriter (
#
class collectd::plugin::graphitewriter (
  $graphitehost,
  $graphiteport,
  $prefix = 'collectd.'
) {
  file { '/etc/collectd.d/graphite-writer.conf':
    ensure  => present,
    content => template('collectd/graphite-writer.conf.erb'),
    group   => '0',
    mode    => '0644',
    notify  => Service['collectd'],
    owner   => '0',
    require => Package['collectd'],
  }
}

