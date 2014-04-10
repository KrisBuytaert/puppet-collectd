define collectd::plugin {

  file { "/etc/collectd.d/${name}.conf":
    content => "LoadPlugin ${name}\n",
    group  => '0',
    mode   => '0644',
    owner  => '0',
    notify => Service['collectd'],
  }

}

