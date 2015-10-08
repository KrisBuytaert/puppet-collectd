class collectd::plugin::write_riemann($riemannhost = '127.0.0.1')
{

  package { 'collectd-write_riemann':
    ensure => 'present',
  }

  file {
    '/etc/collectd.d/write_riemann.conf':
      group   => '0',
      mode    => '0644',
      owner   => '0',
      require => Package['collectd'],
      notify  => Service[$::collectd::params::service_name],
      content => template('collectd/write_riemann.conf.erb');
  }

}

