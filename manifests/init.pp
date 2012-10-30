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

  package {'collectd':
    ensure => present,
    name   => $::operatingsystem ? {
      /(?i:centos|redhat|fedora)/ => "collectd.$::architecture",
      default                     => 'collectd',
    },
    alias  => 'collectd',
  }

  if (($::operatingsystem == 'RHEL' or $::operatingsystem == 'CentOS') and $::lsbmajdistrelease == '5') {

    # Required with a patch to include they Python LDLIB path as documented
    # on  https://github.com/indygreg/collectd-carbon
    file {
      '/etc/init.d/collectd':
        group  => '0',
        mode   => '0755',
        owner  => '0',
        source => 'puppet:///collectd/collectd',
        before => Service['collectd'];
    }
  }

  if ($::operatingsystem == 'Debian' or $::operatingsystem == 'Ubuntu') {
    # We need a config file that is actually including "/etc/collectd.d" files
    # This has been reported in debian, see Debian BTS #690668
    file {
      '/etc/collectd/collectd.conf':
        ensure  => present,
        group   => 'root',
        mode    => '0644',
        owner   => 'root',
        source  => 'puppet:///collectd/collectd.conf.Debian',
        before  => Service['collectd'],
        require => Package['collectd'],
    }
  }

  file{'/etc/collectd.d':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  service {'collectd':
    ensure  => running,
    require => Package['collectd'];
  }
}
