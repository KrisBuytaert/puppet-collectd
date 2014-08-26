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
      require => Package['collectd'],
      notify  => Service['collectd'],
      source => 'puppet:///modules/collectd/plugin/postfix.conf'
  }

}
