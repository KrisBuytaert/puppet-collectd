class collectd::plugins::haproxy_py {
	
	file { '/etc/collectd.d/haproxy_py.conf':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/haproxy.conf',
    notify => Service['collectd'],
  }

  file { '/usr/local/collectd-plugins/haproxy.py':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/haproxy.py',
    notify => Service['collectd'],
  }

}