# Class: collectd::plugin::nginx
#
class collectd::plugin::nginx(
  $statusurl = 'http://localhost/ngxinx_status',
) {
  package { 'collectd-nginx':
    ensure => 'present',
  }

  file { '/etc/collectd.d/nginx.conf':
    ensure  => present,
    content => template('collectd/nginx.conf.erb'),
    group   => '0',
    mode    => '0644',
    notify  => Service['collectd'],
    owner   => '0',
  }
}

