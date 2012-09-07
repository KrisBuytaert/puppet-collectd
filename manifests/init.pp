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
class collectd  {

  package {"collectd":
    ensure => present,
    name   => $::operatingsystem ? {
      /(?i:centos|redhat|fedora)/ => "collectd.$::architecture",
      default                     => 'collectd',
    },
    alias  => 'collectd',
  }

  if (($::opratingsystem == 'RHEL' or $::opratingsystem == 'CentOS') and $::lsbmajdistrelease == '5') {

    # Required with a patch to include they Python LDLIB path as documented
    # on  https://github.com/indygreg/collectd-carbon
    file {
      "/etc/init.d/collectd":
        group  => '0',
        mode   => '755',
        owner  => '0',
        source => "puppet:///collectd/collectd",
        before => Service['collectd'];
    }
  }



  service {"collectd":
    ensure  => running,
    require => Package['collectd'];
  }
}
