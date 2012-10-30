class collectd::plugin::apache{

  # On our debian boxen the http://localhost/server-status?auto is enabled
  # Needs additional changes to the http config if on other distro therefore
  # not including it by default

  if ($::operatingsystem == 'Debian' or $::operatingsystem == 'Ubuntu')
  {
    file { '/etc/collectd.d/apache.conf':
      content => template('collectd/apache.conf.erb'),
      group   => '0',
      mode    => '0644',
      owner   => '0',
      notify  => Service['collectd'],
    }
  }
}
