class collectd::plugin::ntpd(
  $host            = 'localhost',
  $port            = 123,
  $reverse_lookups = false,
  $include_unit_id = true,
)
{

  file { '/etc/collectd.d/ntpd.conf':
    content => template('collectd/plugin/ntpd.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
  }

}
