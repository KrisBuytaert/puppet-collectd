class collectd::plugin::puppetdb(
  $listen_ip = hiera('collectd::plugin::puppetdb::listen_ip', $::ipaddress)
)
{
  file { '/etc/collectd.d/puppetdb.conf':
    content => template('collectd/plugin/puppetdb.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }
}
