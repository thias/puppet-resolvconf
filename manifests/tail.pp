# Class: resolvconf::tail
#
# Manage /etc/resolvconf/resolv.conf.d/tail with puppet. See resolv.conf(5).
#
# This class is just a wrapper around resolvconf::file for the tail file.
#
# Sample Usage :
#  class { 'resolvconf::tail':
#    nameserver => [ '8.8.8.8', '8.8.4.4' ],
#    search     => [ 'example.lan', 'example.com' ],
#  }
#
class resolvconf::tail (
  $ensure     = undef,
  $header     = undef,
  $nameserver = undef,
  $domain     = undef,
  $search     = undef,
  $sortlist   = undef,
  $options    = undef,
) {

  # Ubuntu magic
  include '::resolvconf::service'
  Resolvconf::File { notify => Service['resolvconf'] }

  resolvconf::file { '/etc/resolvconf/resolv.conf.d/tail':
    ensure     => $ensure,
    header     => $header,
    nameserver => $nameserver,
    domain     => $domain,
    search     => $search,
    sortlist   => $sortlist,
    options    => $options,
  }

}

