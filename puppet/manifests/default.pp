$user = 'vagrant'

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
