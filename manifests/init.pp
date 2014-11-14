# Class: collectd
#
class collectd (
  $config_dir           = $::collectd::params::config_dir,
  $config_file          = $::collectd::params::config_file,
  $config_template_name = $::collectd::params::config_template_name,
  $pkgname              = $::collectd::params::pkgname,
  $purge                = $::collectd::params::purge,
  $service_enable       = $::collectd::params::service_enable,
  $service_ensure       = $::collectd::params::service_ensure,
  $service_name         = $::collectd::params::service_name,
) inherits ::collectd::params {
  package{$pkgname:
    ensure => 'present',
    alias  => 'collectd',
  }

  if (($::operatingsystem =~ /(?i:RHEL|CentOS)/ ) and $::lsbmajdistrelease == '5') {

    # Required with a patch to include they Python LDLIB path as documented
    # on  https://github.com/indygreg/collectd-carbon
    file{'/etc/init.d/collectd':
      group  => '0',
      mode   => '0755',
      owner  => '0',
      source => 'puppet:///modules/collectd/collectd',
      before => Service[$service_name],
    }
  }

  #if ($::operatingsystem =~ /(?i:Debian|Ubuntu)/ ) {
    # We need a config file that is actually including "/etc/collectd.d" files
    # This has been reported in debian, see Debian BTS #690668
    # Some CentOS packages e.g. 5.4.0 also has this problem
    file{$config_file:
      ensure  => present,
      group   => 'root',
      owner   => 'root',
      mode    => '0644',
      content => template($config_template_name),
      before  => Service[$service_name],
      require => Package[$pkgname],
    }
  #}

  file{$config_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => $purge,
    purge   => $purge,
  }

  service{$service_name:
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Package[$pkgname],
  }
}

