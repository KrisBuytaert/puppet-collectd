# class collectd::plugin::redis
class collectd::plugin::redis {

  $script = '/usr/local/collectd-plugins/redis-stat.sh'

  file { $script:
    ensure => 'file',
    group  => 'redis',
    mode   => '0755',
    owner  => 'redis',
    source => 'puppet:///modules/collectd/plugin/redis-stat.sh',
    notify => Service['collectd'],
  }

  file { '/etc/collectd.d/redis.conf':
    ensure  => 'file',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    source  => 'puppet:///modules/collectd/plugin/redis.conf',
    notify  => Service['collectd'],
    require => File[$script],
  }

}
