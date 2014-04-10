class collectd::plugin::virt {

  package{
    'collectd-virt':
      ensure  => installed,
      notify  => Service['collectd'],
      require => Package['collectd'],
  }


}



