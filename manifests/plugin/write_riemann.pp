# Class: collectd::plugin::write_riemann
#
class collectd::plugin::write_riemann (
  $riemannhost = '127.0.0.1'
) {
  package { 'collectd-write_riemann':
    ensure => 'present',
  }

  file { '/etc/collectd.d/write_riemann.conf':
    ensure  => present,
    content => template('collectd/write_riemann.conf.erb');
    group   => '0',
    mode    => '0644',
    notify  => Service[$::collectd::params::service_name],
    owner   => '0',
    require => Package['collectd'],
  }
}

