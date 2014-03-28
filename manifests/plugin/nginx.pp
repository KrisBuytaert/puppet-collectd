class collectd::plugin::nginx(
  $statusurl = 'http://localhost/ngxinx_status',
)
{

  package {'collectd-nginx':
    ensure => 'present',
  }

  file { '/etc/collectd.d/nginx.conf':
    content => template('collectd/nginx.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
  }

}
