class collectd::plugin::apache(
  $statusurl = 'http://localhost/mod_status?auto',
  $managelocalvhost = 'no',
)
{


  # On debian boxen the http://localhost/server-status?auto is enabled
  # Needs additional changes to the http config if on other distro therefore
  # not including it by default

  if ($::osfamily == 'RedHat')
  {
    package {'collectd-apache':
      ensure => 'present',
    }
  }


  if ($managelocalvhost == 'true')
  {

    file { '/etc/httpd/conf.d/localhost.conf':
      source => 'puppet:///modules/collectd/plugin/localhost.conf',
      group  => '0',
      mode   => '0644',
      owner  => '0',
    }

  }

  file { '/etc/collectd.d/apache.conf':
    content => template('collectd/apache.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
  }




}
