class collectd::plugin::apache(
  $statusurl = 'http://localhost:8008/mod_status?auto',
  $managelocalvhost = false,
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


  if $managelocalvhost
  {
    $webservice = $::osfamily {
      'RedHat' => 'httpd',
      'Debian' => 'apache2',
    }

    file { '/etc/httpd/conf.d/status_8008.conf':
      source => 'puppet:///modules/collectd/plugin/status_8008.conf',
      group  => '0',
      mode   => '0644',
      owner  => '0',
      notify => Service[$webservice],
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
