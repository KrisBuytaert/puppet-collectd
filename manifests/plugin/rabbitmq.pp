# Class: collectd::plugin::rabbitmq
#
class collectd::plugin::rabbitmq {
  $collectd_rabbitmq_user     = hiera('collectd_rabbitmq_user')
  $collectd_rabbitmq_password = hiera('collectd_rabbitmq_password')

  package { 'collectd-perl':
    ensure => 'present',
  }

  file { '/usr/local/collectd-plugins/Collectd/':
    ensure  => 'directory',
    group   => '0',
    mode    => '0755',
    owner   => '0',
    require => File['/usr/local/collectd-plugins/'],
  }

  file { '/usr/local/collectd-plugins/Collectd/Plugins/':
    ensure  => 'directory',
    group   => '0',
    mode    => '0755',
    owner   => '0',
    require => File['/usr/local/collectd-plugins/Collectd'],
  }

  file { '/usr/local/collectd-plugins/Collectd/Plugins/RabbitMQ.pm':
    ensure  => present,
    mode    => '0644',
    require => File['/usr/local/collectd-plugins/Collectd/Plugins'],
    source  => 'puppet:///modules/collectd/RabbitMQ.pm',
  }

  file_line { 'cpusummaryline':
    ensure  => present,
    line    => 'cpusummary              user:COUNTER:U:U, nice:COUNTER:U:U, system:COUNTER:U:U, idle:COUNTER:U:U, iowait:COUNTER:U:U, irq:COUNTER:U:U, softirq:COUNTER:U:U, cpucount:GAUGE:U:U',
    match   => '^cpusummary\s+',
    notify  => Service['collectd'],
    path    => '/usr/share/collectd/types.db',
    require => Package['collectd'],
  }

  file_line { 'rabbitmqline':
    ensure  => present,
    line    => 'rabbitmq                messages:GAUGE:0:U, messages_rate:GAUGE:0:U, messages_unacknolwedged:GAUGE:0:U, messages_unacknowledged_rate:GAUGE:0:U, messages_ready:GAUGE:0:U, message_ready_rate:GAUGE:0:U, memory:GAUGE:0:U, consumers:GAUGE:0:U, publish:GAUGE:0:U, publish_rate:GAUGE:0:U, deliver_no_ack:GAUGE:0:U, deliver_no_ack_rate:GAUGE:0:U, deliver_get:GAUGE:0:U, deliver_get_rate:GAUGE:0:U',
    match   => '^rabbitmq\s+',
    notify  => Service['collectd'],
    path    => '/usr/share/collectd/types.db',
    require => Package['collectd'],
  }

  file { '/etc/collectd.d/RabbitMQ.conf':
    ensure  => present,
    content => template('collectd/RabbitMQ.conf.erb'),
    group   => '0',
    mode    => '0644',
    notify  => Service['collectd'],
    owner   => '0',
    require => Package['collectd'],
  }
}

