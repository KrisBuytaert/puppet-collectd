# Define: collectd::plugin
#
define collectd::plugin {
  file { "/etc/collectd.d/${name}.conf":
    ensure  => present,
    content => "LoadPlugin ${name}\n",
    group   => '0',
    mode    => '0644',
    notify  => Service['collectd'],
    owner   => '0',
  }
}

