class collectd::plugin::df (
  $fs_types = ['ext3', 'ext4', 'xfs', 'nfs', 'nfs4'],
  $ignore_selected = false,
) {
  file { '/etc/collectd.d/df.conf':
    content => template('collectd/plugin/df.conf.erb'),
    group   => '0',
    mode    => '0644',
    owner   => '0',
    notify  => Service['collectd'],
  }
}
