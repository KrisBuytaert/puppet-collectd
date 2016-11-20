# Exec command
define collectd::plugin::exec::command (
  $user,
  $group,
  $exec   = [],
  $ensure = 'present',
) {
  include ::collectd
  include ::collectd::plugin::exec

  $conf_dir = $collectd::plugin_conf_dir

  concat::fragment { "collectd_plugin_exec_conf_${title}":
    order   => '40',
    target  => $collectd::plugin::exec::config_file,
    content => template('collectd/exec/command.conf.erb'),
  }
}
