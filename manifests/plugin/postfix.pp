# Class: collectd
#
# This module manages collectd
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]

class collectd::plugin::postfix {

  file { '/etc/collectd.d/postfix.conf':
    group   => '0',
    mode    => '0644',
    owner   => '0',
    require => [ Package['collectd'], File_line['postfixline'] ],
    notify  => Service['collectd'],
    source  => 'puppet:///modules/collectd/plugin/postfix.conf',
  }

  file_line { 'postfixline':
    ensure  => present,
    line    => 'mail_counter            value:COUNTER:0:65535',
    match   => '^mail_counter\s+',
    path    => '/usr/share/collectd/types.db',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }

}
