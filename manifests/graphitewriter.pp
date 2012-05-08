# = Class: collectd::graphitewriter
#
# Description of collectd::graphitewriter
#
# == Parameters:
#
# $param::   description of parameter. default value if any.
#
# == Actions:
#
# Describe what this class does. What gets configured and how.
#
# == Requires:
#
# Requirements. This could be packages that should be made available.
#
# == Sample Usage:
#
# == Todo:
#
# * Update documentation
#
class collectd::graphitewriter (
  $graphitehost,
  $graphiteport
) {

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

  file { '/etc/collectd.d/graphite-writer.conf':
    group   => '0',
    mode    => '0644',
    owner   => '0',
    require => Package['collectd'],
    notify  => Service['collectd'],
    content => template('collectd/graphite-writer.conf.erb');
  }


}

