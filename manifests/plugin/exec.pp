# Class: collectd::plugin::exec
#
class collectd::plugin::exec($execs){
  file { '/etc/collectd.d/exec.conf':
    ensure  => present,
    content => template('collectd/exec.conf.erb'),
    group   => '0',
    mode    => '0644',
    notify  => Service['collectd'],
    owner   => '0',
    require => Package['collectd'],
  }
}

