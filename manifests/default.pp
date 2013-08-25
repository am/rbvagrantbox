$user = 'vagrant'

group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
  content => "Welcome to your'vagrant'built virtual machine!\nManaged by Puppet.\n"
}


Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

# -

include apt
include redis
include mysql

# rbenv
$rv = '1.9.3-p327'

rbenv::install{$user:}

# rbenv - ruby
rbenv::compile { $rv:
  user => $user,
  global => true
}

# rbenv - gems
rbenv::gem { "rails":
  user => $user,
  ruby => $rv,
}