class trystack::control::mysql() {

    if $mysql_ip == '' { fail('mysql_ip is empty') }
    if $mysql_root_password == '' { fail('mysql_root_password is empty') }
    if $keystone_db_password == '' { fail('keystone_db_password is empty') }
    if $nova_db_password == '' { fail('nova_db_password is empty') }
    if $cinder_db_password == '' { fail('cinder_db_password is empty') }
    if $glance_db_password == '' { fail('glance_db_password is empty') }
    if $neutron_db_password == '' { fail('neutron_db_password is empty') }
    if $heat_db_password == '' { fail('heat_db_password is empty') }
    if $trystack_db_password == '' { fail('trystack_db_password is empty') }

    class {"mysql::server":
        package_name     => "mariadb-galera-server",
        service_manage   => true,
        restart          => true,
        root_password    => "$mysql_root_password",
        override_options => {
          'mysqld' => { bind_address => "0.0.0.0",
                        default_storage_engine => "InnoDB",
                        max_connections => "1024",
                        open_files_limit => '-1',
          }
        }
    }

    include packstack::innodb

    # deleting database users for security
    # this is done in mysql::server::account_security but has problems
    # when there is no fqdn, so we're defining a slightly different one here
    mysql_user { [ 'root@127.0.0.1', 'root@::1', '@localhost', '@%' ]:
        ensure  => 'absent', require => Class['mysql::server'],
    }
    if ($::fqdn != "" and $::fqdn != "localhost") {
        mysql_user { [ "root@${::fqdn}", "@${::fqdn}"]:
            ensure  => 'absent', require => Class['mysql::server'],
        }
    }
    if ($::fqdn != $::hostname and $::hostname != "localhost") {
        mysql_user { ["root@${::hostname}", "@${::hostname}"]:
            ensure  => 'absent', require => Class['mysql::server'],
        }
    }

    class {"keystone::db::mysql":
      user          => 'keystone_admin',
      password      => "$keystone_db_password",
      allowed_hosts => "%",
      charset       => "utf8",
      mysql_module  => '2.2',
    }

    class {"nova::db::mysql":
      password      => "$nova_db_password",
      host          => "%",
      allowed_hosts => "%",
      charset       => "utf8",
      mysql_module  => '2.2',
    }

    class {"cinder::db::mysql":
      password      => "$cinder_db_password",
      host          => "%",
      allowed_hosts => "%",
      charset       => "utf8",
      mysql_module  => '2.2',
    }

    class {"glance::db::mysql":
      password      => "$glance_db_password",
      host          => "%",
      allowed_hosts => "%",
      charset       => "utf8",
      mysql_module  => '2.2',
    }

    class {"neutron::db::mysql":
      password      => "$neutron_db_password",
      host          => "%",
      allowed_hosts => "%",
      dbname        => 'neutron',
      charset       => "utf8",
      mysql_module  => '2.2',
    }

    class {"heat::db::mysql":
      password      => "$heat_db_password",
      host          => "%",
      allowed_hosts => "%",
      charset       => "utf8",
      mysql_module  => '2.2',
    }

    #firewall { '001 mysql incoming':
    #    proto  => 'tcp',
    #    dport  => ['3306'],
    #    action => 'accept',
    #}
    packstack::firewall {'mysql':
      host => '10.1.254.0/24',
      service_name => 'mysql',
      chain => 'INPUT',
      ports => '3306',
      proto => 'tcp',
    }

##########################################
    # pacemaker will manage the service.
    #class {"mysql::server":
    #    manage_service => false,
    #    config_hash => {bind_address => "0.0.0.0",
    #                    root_password => "$mysql_root_password",
    #                    datadir => '/var/lib/mysql/data/',
    #                    default_engine => 'InnoDb',
    #                    }
    #}
    
    mysql::db { "trystack":
        user         => "trystack",
        password     => $trystack_db_password,
        host         => $mysql_ip,
    }
    # these are done in mysql::db
    #mysql_user { "trystack@%":
    #    password_hash => mysql_password($trystack_db_password),
    #    provider      => 'mysql',
    #    require       => Database["trystack"],
    #}
    #mysql_grant { "trystack@%/trystack":
    #    # TODO figure out which privileges to grant.
    #    table      => '.*',
    #    user       => 'trystack@%',
    #    privileges => 'all',
    #    provider   => 'mysql',
    #    require    => Mysql_user["trystack@%"]
    #}
    
}
