class collectd::plugin::mongodb
{

  $mongod_bind_ip = hiera('mongod_bind_ip','127.0.0.1')

  if !defined(Package['python-pip']) {
    package { 'python-pip':
      ensure => present,
    }
  }

  if !defined(Package['pymongo']) {
    package { 'pymongo':
      ensure => 'present',
      provider => 'pip',
      require => Package['python-pip'],
    }
  }

  file { '/usr/local/collectd-plugins/mongodb.py':
    ensure => 'file',
    group  => '0',
    mode   => '0644',
    owner  => '0',
    content => template('collectd/mongodb.py.erb'),
  }

  file { '/etc/collectd.d/mongodb.conf':
    ensure => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('collectd/mongodb.conf.erb'),
    require => [ Package['pymongo'], File['/usr/local/collectd-plugins/mongodb.py'] ],
    notify  => Service['collectd'],
  }

}
