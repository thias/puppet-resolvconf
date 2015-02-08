# puppet-resolvconf

## Overview

Manage /etc/resolv.conf with puppet.

* `resolvconf` : Main class.
* `resolvconf::file` : Definition to manage extra files.

The idea is to be able to globally include the `resolvconf` class on all nodes.
From there, use hiera with puppet 3.x which allows a quick start to managing the
`/etc/resolv.conf` file's content in a very flexible way.

## Examples

In `site.pp` :
```puppet
hiera_include('classes')
```

In `hieradata` somewhere :
```yaml
---
classes:
  - '::resolvconf'
resolvconf::header: ''
resolvconf::nameservers:
  - '198.51.100.1'
  - '198.51.100.2'
resolvconf::search:
  - 'foo.example.com'
  - 'bar.example.com'
  - 'example.com'
```

This way, only nodes where the Hiera values apply get their `/etc/resolv.conf`
file modified by Puppet.

Alternatively, You can also create arbitrary resolv.conf files using the
`resolvconf::file` class:
```puppet
resolvconf::file { '/etc/dnsmasq-resolv.conf':
    hiera_search => true,
    exclusive    => false,
    header       => 'This file is managed by Puppet for dnsmasq.',
    nameservers  => [ '8.8.8.8', '8.8.4.4' ],
    search       => [ 'foo.example.com', 'bar.example.com' ],
}
```

For example, Ubuntu allows for file snippets to be used:
```puppet
resolvconf::file { '/etc/resolvconf/resolv.conf.d/tail':
  nameserver => [ '198.51.100.1', '198.51.100.2' ],
}
```
