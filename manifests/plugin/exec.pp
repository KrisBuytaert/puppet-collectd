# Exec plugin for collectd
class collectd::plugin::exec (
  $commands = hiera_hash('collectd::plugin::exec::commands', {}),
  $ensure   = 'present',
  $globals  = false,
  $interval = undef,
) {
  include ::collectd

  $config_file = "${collectd::config_dir}/exec.conf"

  concat { $config_file:
    ensure         => $ensure,
    mode           => '0640',
    owner          => 'root',
    group          => 'root',
    notify         => Service['collectd'],
    ensure_newline => true,
  }

  concat::fragment { 'collectd_plugin_exec_conf_header':
    order   => '00',
    content => template('collectd/exec/header.conf.erb'),
    target  => $config_file,
  }

  concat::fragment { 'collectd_plugin_exec_conf_footer':
    order   => '99',
    content => template('collectd/exec/footer.conf.erb'),
    target  => $config_file,
  }

  create_resources(collectd::plugin::exec::command, $commands)
}
