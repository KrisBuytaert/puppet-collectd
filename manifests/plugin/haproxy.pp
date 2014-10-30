class collectd::plugin::haproxy {

  file_line { 'haproxyline':
  path => '/usr/share/collectd/types.db',
  line => 'haproxy_backend   stot:COUNTER:0:U, econ:COUNTER:0:U, eresp:COUNTER:0:U',
  match  => '^haproxy_backend\s+',
  }

  package {'socat':
    ensure => 'present',
  }

  file { '/usr/local/collectd-plugins/haproxy-stat.sh':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
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

}

