# Class: resolvconf
#
# Manage /etc/resolv.conf with puppet. See resolv.conf(5).
#
# Parameters:
#  $nameserver:
#    Array of nameservers. Default: empty
#  $domain:
#    Domain name. Default: empty
#  $search:
#    Array of search domains. Default: empty
#  $options:
#    Array of options. Default: empty
#
# Sample Usage :
#  class { 'resolvconf':
#    nameserver => [ '8.8.8.8', '8.8.4.4' ],
#    search     => [ 'example.lan', 'example.com' ],
#  }
#
define resolvconf::file (
  $header     = 'This file is managed by Puppet, do not edit',
  $nameserver = [],
  $domain     = '',
  $search     = [],
  $options    = [],
  $file       = $name,
) {

  if $domain != '' and $search != [] {
    fail('The "domain" and "search" parameters are mutually exclusive.')
  }

  if $nameserver != [] {
    file { $file:
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/resolv.conf.erb"),
    }
  }

}

class resolvconf (
  $header     = 'This file is managed by Puppet, do not edit',
  $nameserver = [],
  $domain     = '',
  $search     = [],
  $options    = [],
) {

  $file = '/etc/resolv.conf'

  resolvconf::file { $file:
    header     => $header,
    nameserver => $nameserver,
    domain     => $domain,
    search     => $search,
    options    => $options,
  }

}
