class collectd::plugin::iostat
{

  if !defined(Package['sysstat']) {
    package { 'sysstat':
      ensure => present,
    }
  }

  file { '/usr/local/collectd-plugins/iostat.rb':
    ensure => 'file',
    group  => 'root',
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/iostat.rb',
  }

  file { '/etc/collectd.d/iostat.conf':
    ensure => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    source  => 'puppet:///modules/collectd/plugin/iostat.conf',
    require => [ Package['sysstat'], File['/usr/local/collectd-plugins/iostat.rb'] ],
    notify  => Service['collectd'],
  }

}
