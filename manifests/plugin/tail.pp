# Class ::collectd:plugin::tail
#
# This class manages the tail plugin for collectd.
# It inherits params from the ::collectd::params class.
#
# Parameters:
#
# All the params have the same name as in the tail config with a 'tail_' prefix and in lowercase.
# Example:
#   In the tail.conf:
#   Regex "*"
#   In the puppet class definition:
#   tail_regex => '*',
#
# Sample uses:
#
# Counting how much outgoing ssh connections the jenkins users has.
#   class { '::collectd::plugin::tail':
#     tail_dstype        => 'CounterInc',
#     tail_file_path     => '/var/log/secure',
#     tail_instance      => 'auth',
#     tail_instance_name => 'ansible_ssh_amount',
#     tail_regex         => 'sudo:\s*jenkins,
#     tail_type          => 'counter',
#   }
#
# Emails recieved for local recients.
#   class { '::collectd::plugins::tail':
#     tail_dstype        => 'CounterInc',
#     tail_file_path     => '/var/log/exim4/mainlog',
#     tail_instance      => 'exim',
#     tail_instance_name => 'incomming',
#     tail_regex         => 'R=local_user',
#     tail_type          => 'email_type',
#   }
#
# More information on the tail plugin can be found at:
# https://collectd.org/wiki/index.php/Plugin:Tail
class collectd::plugin::tail (
  $tail_dstype        = undef,
  $tail_file_path     = undef,
  $tail_instance      = undef,
  $tail_instance_name = undef,
  $tail_regex         = undef,
  $tail_type          = undef,
) inherits ::collectd::params {

  file { "${config_dir}/tail.conf":
    group   => '0',
    owner   => '0',
    mode    => '0644',
    content => template('collectd/tail.conf.erb'),
    notify  => Service[$service_name],
  }
}
