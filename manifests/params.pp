class collectd::params (
  $pkgname        = $::operatingsystem ? {
    /(?i:centos|redhat|fedora)/ => "collectd.$::architecture",
    default                     => 'collectd',
  },
  $pkg_ensure     = 'installed',
  $config_file    = '/etc/collectd/collectd.conf',
  $config_dir     = '/etc/collectd.d',
  $purge          = true,
  $service_name   = 'collectd',
  $service_ensure = 'running',
  $service_enable = true,
) {
}
