# class collectd::plugin::mysql
class collectd::plugin::mysql(
  $host = '127.0.0.1',
  $user = 'root',
  $password = '',
){

  package { 'MySQL-python':
    ensure => present,
  }

  File{
    ensure => present,
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
  }

  file { '/usr/local/collectd-plugins/mysql.py':
    source => 'puppet:///modules/collectd/plugin/mysql.py',
  }

  file { '/etc/collectd.d/mysql.conf':
    content => template('collectd/mysql.conf.erb'),
    require => File['/usr/local/collectd-plugins/mysql.py'],
    notify  => Service['collectd'],
  }

}
