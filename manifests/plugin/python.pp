class collectd::plugin::python {

  package {'collectd-python':
    ensure => 'present',
  }

  file { '/etc/collectd.d/python.conf':
    source => 'puppet:///modules/collectd/python.conf',
    group  => '0',
    mode   => '0644',
    owner  => '0',
    notify => Service['collectd'],
  }

}
