# == Class: resolvconf::file
#
# Manage /etc/resolv.conf with puppet. See resolv.conf(5).
#
# This class creates a resolv.conf file for the main class.  Additionally, it
# can be used to generate resolv.conf files for other purposes.  Such as snippets
# for Ubuntu.
#
# === Parameters
#
# Document parameters here.
#
# [*nameservers*]
#   Array of nameservers. Default: empty
#
# [*nameserver*] -- deprecated only here for posterity
#   Array of nameservers. Default: empty
#
# [*domain*]
#   Domain name. Default: facter value for domain
#
# [*search*]
#   Array of search domains. Default: empty
#
# [*options*]
#   Array of options. Default: empty
#
# [*hiera_search*]
#   Boolean whether to do a Hiera lookup mashup to get all values.  Default: false
#
# [*exclusive*]
#   Boolean whether domain and search are mutually exclusive.  Default: false
#
# [*config_template*]
#   An alternative template to use for resolv.conf. Default: undefined
#
# [*owning_user*]
#   Specify an alternative user to own the new resolv.conf file
#
# [*owning_group*]
#   Specify an alternative group to own the new resolv.conf file
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*kernel*]
#   The kernel module is not required, but is utilized on Linux systems
#
# === Examples
#
# A simple example looks like:
#
#       class { 'resolvconf':
#         nameservers => [ '8.8.8.8', '8.8.4.4' ],
#         search      => [ 'example.lan', 'example.com' ],
#         options     => [ 'timeout:1', 'attempts:1' ],
#       }
#
# A full example looks like:
#
#       class { 'resolvconf':
#         hiera_search => true,
#         exclusive    => false,
#         config_template => "some_other_module/resolvconf.erb",
#         domain      => 'example.lan',
#         nameservers => [ '8.8.8.8', '8.8.4.4' ],
#         options     => [ 'timeout:1', 'attempts:1' ],
#         search      => [ 'example.lan', 'example.com' ],
#         sortlist    => [ '130.155.160.0/255.255.240.0', '130.155.0.0', ],
#       }
#
# === Authors
#
# Matthias Saou
# Josh Preston
#
define resolvconf::file (
  $owning_user,
  $owning_group,
  $config_template,
  $hiera_search    = false,
  $exclusive       = true,
  $ensure          = present,
  $header          = 'This file is managed by Puppet, do not edit',
  $nameservers     = [],
  $domain          = '',
  $search          = [],
  $sortlist        = [],
  $options         = [],
) {

  if $exclusive and $domain != '' and $search != [] {
    fail('The "domain" and "search" parameters are mutually exclusive.')
  }

  if $hiera_search {
    $_search = hiera_array("${module_name}::search")
  } else {
    $_search = $search
  }

  if $config_template {
    $_config_template = $config_template
  } else {
    $_config_template = "${module_name}/resolv.conf.erb"
  }

  if $nameservers != [] {
    file { $title:
      ensure  => $ensure,
      owner   => $owning_user,
      group   => $owning_group,
      mode    => '0644',
      content => template($_config_template),
    }
  }

}
