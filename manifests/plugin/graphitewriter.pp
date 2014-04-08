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

class collectd::plugin::graphitewriter (
  $graphitehost,
  $graphiteport,
  $prefix = "collectd.")
{

  file {
    '/etc/collectd.d/graphite-writer.conf':
      group   => '0',
      mode    => '0644',
      owner   => '0',
      require => Package['collectd'],
      notify  => Service['collectd'],
      content => template('collectd/graphite-writer.conf.erb');
  }

}



