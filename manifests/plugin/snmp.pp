# Class: collectd::plugin::snmp
#
class collectd::plugin::snmp{
  package { 'collectd-snmp':
    ensure => 'present',
  }
}

