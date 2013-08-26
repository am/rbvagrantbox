# Make sure apt-get -y update runs before anything else.
stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { '/usr/bin/apt-get -y update':
    user => 'root'
  }
}
class { 'apt_get_update':
  stage => preinstall
}

package { [ 'build-essential', 
            'zlib1g-dev', 
            'libssl-dev', 
            'libreadline-dev', 
            'libxml2', 
            'libxml2-dev', 
            'libxslt1-dev',
            'sqlite3',
            'libsqlite3-dev']:
  ensure => installed,
}


class install_mysql {
  class { 'mysql': }

  class { 'mysql::server':
    config_hash => { 'root_password' => '' }
  }

  package { 'libmysqlclient15-dev':
    ensure => installed
  }
}
class { 'install_mysql': }


# rbenv
$v_user = 'vagrant'
$rv = '1.9.3-p327'

rbenv::install{"${v_user}":}

# rbenv - ruby
rbenv::compile { "${rv}":
  user => "${v_user}",
  global => true
}

notice("The user is: ${v_user}")

# rbenv - gems
rbenv::gem { 'rails':
  user => "${v_user}",
  ruby => "${rv}",
}
