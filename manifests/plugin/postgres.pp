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

class collectd::plugin::postgres (
  $dbname,
  $dbuser,
  $dbpass
){

  file { '/etc/collectd.d/postgres.conf':
    group   => '0',
    mode    => '0644',
    owner   => '0',
    require => [ Package['collectd'],Package['collectd-postgresql'] ],
    notify  => Service['collectd'],
    content =>  template('collectd/plugin/postgres.conf.erb'),
  }

  package {'collectd-postgresql': ensure =>present }

}
