group { 'puppet': ensure => 'present' }

class mysql_5 {
  
  exec { "update-package-list":
    command => "/usr/bin/sudo /usr/bin/apt-get update",
  }

  package { "mysql-server-5.1":
    ensure => present,
    require => Exec["update-package-list"],
  }
  
  service { "mysql":
    ensure => running, 
    require => Package["mysql-server-5.1"],
    notify => Exec['create-db-user']
  }

  exec { "create-db":
    command => "/usr/bin/mysql -uroot -p -e \"create database testapp;\"; true",
    require => Service["mysql"],
  }

  exec { "create-db-user":
    command => "/usr/bin/mysql -uroot -p -e \"create user dbuser@'%' identified by 'dbuser'; grant all on testapp.* to dbuser@'%'; flush privileges;\"; true",
    require => Exec["create-db"],
  }

  file { "/etc/mysql/my.cnf":
    owner => 'root',
    group => 'root',
    mode => 644,
    notify => Service['mysql'],
    source => '/vagrant/files/my.cnf',
    require => Package["mysql-server-5.1"],
  }

}

include mysql_5

