class collectd::plugin::haproxy {

  file_line { 'haproxyline':
  path => '/usr/share/collectd/types.db',
  line => 'haproxy_backend   stot:COUNTER:0:U, econ:COUNTER:0:U, eresp:COUNTER:0:U',
  match  => '^haproxy_backend\s+',
  }

  file { '/usr/local/collectd-plugins/haproxy-stat.sh':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/haproxy-stat.sh',
  }

  file { '/etc/collectd.d/exec.conf':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/exec.conf',
  }

  file_line { 'createsock':    
    path => '/etc/haproxy/haproxy.cfg',
    line => 'stats socket /var/run/haproxy.sock mode 600 level admin user haproxy group haproxy',
  }
}

