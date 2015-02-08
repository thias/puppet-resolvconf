# == Class: resolvconf
#
# Manage /etc/resolv.conf with puppet. See resolv.conf(5).
#
# This class is just a wrapper around resolvconf::file for the main file.
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
#   Specify an alternative user to own the new resolv.conf file.  Default: root
#
# [*owning_group*]
#   Specify an alternative group to own the new resolv.conf file.  Default: undef
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
# Josh Preston <JoshPreston@dswinc.com>
#
class resolvconf (
  $hiera_search    = false,  # Backwards compatibility
  $exclusive       = true,   # Backwards compatibility
  $header          = 'This file is managed by Puppet, do not edit',
  $nameservers     = [],
  $options         = [],
  $search          = [],
  $sortlist        = [],
  $nameserver      = [],     # Backwards compatibility
  $owning_user     = 'root',
  $owning_group,
  $domain,
  $config_template,
) {

  # Backwards compatibility
  if $nameservers == [] and $nameserver != [] {
    notify { "${module_name}: [nameserver] is deprecated, please adjust to nameservers.": }
    $_nameservers = $nameserver
  }

  # Change the ownership of the default file by OS
  if !$owning_group {
    case $::kernel {
      'AIX'   : { $owning_group = 'system' }
      default : { $owning_group = 'root' }
    }
  }

  # Create the new file
  resolvconf::file { '/etc/resolv.conf':
    hiera_search    => $hiera_search,
    exclusive       => $exclusive,
    owning_user     => $owning_user,
    owning_group    => $owning_group,
    header          => $header,
    nameservers     => $_nameservers,
    domain          => $domain,
    search          => $search,
    sortlist        => $sortlist,
    options         => $options,
    config_template => $config_template,
  }

}
