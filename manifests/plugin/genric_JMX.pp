class collectd::plugin::generic_jmx
{

  file { '/etc/collectd.d/generic_jmx.conf':
    ensure => 'file',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    source  => 'puppet:///modules/collectd/generic_jmx.conf',
    notify  => Service['collectd'],
  }:
 
  file_line { 
    'custom.types.db-errors':
      path    => '/usr/share/collectd/types.db',
      line    => 'errors		value:GAUGE:0:U', 
      require => Package['collectd'],
      notify  => Service['collectd'];
   'custom.types.db-timeouts':
      path    => '/usr/share/collectd/types.db',
      line    => 'timeouts		value:GAUGE:0:U', 
      require => Package['collectd'],
      notify  => Service['collectd'];
   'custom.types.db-hits':
      path    => '/usr/share/collectd/types.db',
      line    => 'hits		value:GAUGE:0:U', 
      require => Package['collectd'],
      notify  => Service['collectd'];
   'custom.types.db-hitratio':
      path    => '/usr/share/collectd/types.db',
      line    => 'hitratio		value:GAUGE:0:U', 
      require => Package['collectd'],
      notify  => Service['collectd'];
   'custom.types.db-evictions':
      path    => '/usr/share/collectd/types.db',
      line    => 'evictions		value:GAUGE:0:U', 
      require => Package['collectd'],
      notify  => Service['collectd'];
   'custom.types.db-lookups':
      path    => '/usr/share/collectd/types.db',
      line    => 'lookups		value:GAUGE:0:U', 
      require => Package['collectd'],
      notify  => Service['collectd'];
   'custom.types.db-insers':
      path    => '/usr/share/collectd/types.db',
      line    => 'inserts		value:GAUGE:0:U', 
      require => Package['collectd'],
      notify  => Service['collectd'];
   } 
 }
