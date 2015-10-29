# class collectd::plugin::haproxy
class collectd::plugin::haproxy {

  file_line { 'haproxyline':
    path  => '/usr/share/collectd/types.db',
    line  => 'haproxy_backend   stot:COUNTER:0:U, econ:COUNTER:0:U, eresp:COUNTER:0:U',
    match => '^haproxy_backend\s+',
  }

  # right permissions are configured in haproxy profile as default
  # file_line { 'socket':
  #   path => '/etc/haproxy/haproxy.cfg',
  #   line => '  stats  socket /var/lib/haproxy/stats mode 600 level admin user haproxy group haproxy',
  #   match  => '^  stats  socket',
  # }

  package {'socat':
    ensure => 'present',
  }

  file { '/usr/local/collectd-plugins/haproxy-stat.sh':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/haproxy-stat.sh',
    notify => Service['collectd'],
  }

  file { '/etc/collectd.d/exec.conf':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/exec.conf',
    notify => Service['collectd'],
  }
}
