class collectd::plugin::ipmi {

  user { 'collectd':
    ensure => present,
    name   => 'collectd',
    shell  => '/sbin/nologin',
    system => true,
  }

  file { '/usr/local/collectd-plugins/ipmi-collectd':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/ipmi-collectd',
    notify => Service['collectd'],
  }

  file { '/usr/local/collectd-plugins/ipmi.sh':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/ipmi.sh',
    notify => Service['collectd'],
  }

  file { '/etc/collectd.d/ipmi.conf':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/ipmi.conf',
    notify => Service['collectd'],
  }

  sudo::conf{'ipmi_collectd':
    content => "Defaults:collectd !requiretty
    collectd ALL=(ALL) NOPASSWD:/usr/bin/collectd-ipmitool\n",
  }


}
