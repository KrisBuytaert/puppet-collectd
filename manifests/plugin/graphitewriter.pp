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

class collectd::plugin::graphitewriter ( $graphitehost, $graphiteport) {

  package { 'collectd-python':
    ensure => 'present',
  }

  file { '/usr/local/collectd-plugins/':
    ensure => 'directory',
    group  => '0',
    mode   => '0755',
    owner  => '0',
  }
  file { '/usr/local/collectd-plugins/carbon_writer.py':
    ensure => 'file',
    group  => '0',
    mode   => '0644',
    owner  => '0',
    source => 'puppet:///modules/collectd/collectd-carbon/carbon_writer.py'
  }



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



