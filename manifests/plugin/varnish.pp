class collectd::plugin::varnish (
  $version = 4,
  $collectCache       = true,
  $collectConnections = true,
  $collectBackend     = true,
  $collectSHM         = true,
  $collectESI         = false,
  $collectFetch       = false,
  $collectHCB         = false,
  $collectSMS         = false,
  $collectTotals      = false,
  $collectWorkers     = false,
  $collectObjects     = false,
  $collectSession     = false,
  $collectStruct      = false,
  $collectUptime      = false,
  $collectVCL         = false,
  $collectPurge       = false,
  $collectSMA         = false,
  $collectSM          = false,
  $collectBan         = false,
  $collectDirectorDNS = false,
) {

  package {'collectd-varnish':
    ensure => 'present',
  }

  file { '/etc/collectd.d/varnish.conf':
    content => template('collectd/varnish.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
  }

}
