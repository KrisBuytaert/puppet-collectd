class collectd::plugin::mongodb
{

  $mongod_bind_ip = hiera('mongod_bind_ip','127.0.0.1')
  $mongo_dbs      = hiera('mongod_dbs',['admin'])

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

#  file { '/usr/local/collectd-plugins':
#    ensure => 'directory',
#    group  => 'root',
#    mode   => '0644',
#    owner  => 'root',
#  }

  file { '/usr/local/collectd-plugins/mongodb.py':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    content => template('collectd/mongodb.py.erb'),
#   require => File['/usr/local/collectd-plugins'],
  }

  file_line { 'mongoline':
    ensure => present,
    line   => 'replication             value:GAUGE:U:U',
    match  => '^replication\s+',
    path   => '/usr/share/collectd/types.db',
  }


  file { '/etc/collectd.d/mongodb.conf':
    ensure => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('collectd/mongodb.conf.erb'),
    require => [ Package['pymongo'], File['/usr/local/collectd-plugins/mongodb.py'], File_line['mongoline'] ],
    notify  => Service['collectd'],
  }

}
