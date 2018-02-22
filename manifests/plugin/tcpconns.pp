# https://collectd.org/wiki/index.php/Plugin:TCPConns
class collectd::plugin::tcpconns (
  $localports  = undef,
  $remoteports = undef,
  $listening   = undef,
  $interval    = undef,
  $ensure      = present
) {

  if $localports {
    validate_array($localports)
  }

  if $remoteports {
    validate_array($remoteports)
  }

  file { '/etc/collectd.d/tcpconns.conf':
    content => template('collectd/plugin/tcpconns.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
  }
}
