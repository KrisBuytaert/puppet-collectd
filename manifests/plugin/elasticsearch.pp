#class collectd::plugin::elasticsearch
class collectd::plugin::elasticsearch
{

  file { '/usr/local/collectd-plugins/elasticsearch.py':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
    source => 'puppet:///modules/collectd/plugin/elasticsearch.py',
  }

  file { '/etc/collectd.d/elasticsearch.conf':
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    source  => 'puppet:///modules/collectd/plugin/elasticsearch.conf',
    require => File['/usr/local/collectd-plugins/elasticsearch.py'],
    notify  => Service['collectd'],
  }

}
