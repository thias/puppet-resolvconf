# Class: resolvconf::service
#
# This is an Ubuntu specific service which manages the configuration snippets.
#
class resolvconf::service (
  $ensure = 'running',
  $enable = true,
) {

  service { 'resolvconf':
    ensure    => $ensure,
    enable    => $enable,
    hasstatus => true,
  }

}

