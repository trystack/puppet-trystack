class trystack::control::mysql() {

    # pacemaker will manage the service.
    class {"mysql::server":
        manage_service => false,
        config_hash => {bind_address => "0.0.0.0",
                        root_password => "$mysql_root_password",
                        datadir => '/var/lib/mysql/data', }
    }
    
    # deleting database users for security
    # this is done in mysql::server::account_security but has problems
    # when there is no fqdn, so we're defining a slightly different one here
    database_user { [ 'root@127.0.0.1', 'root@::1', '@localhost', '@%' ]:
        ensure  => 'absent', require => Class['mysql::config'],
    }
    if ($::fqdn != "" and $::fqdn != "localhost") {
        database_user { [ "root@${::fqdn}", "@${::fqdn}"]:
            ensure  => 'absent', require => Class['mysql::config'],
        }
    }
    if ($::fqdn != $::hostname and $::hostname != "localhost") {
        database_user { ["root@${::hostname}", "@${::hostname}"]:
            ensure  => 'absent', require => Class['mysql::config'],
        }
    }
    
    firewall { '001 mysql incoming':
        proto  => 'tcp',
        dport  => ['3306'],
        action => 'accept',
    }
    
    class {"keystone::db::mysql":
        password      => "$keystone_db_password",
        allowed_hosts => "%",
    }
    
    class {"nova::db::mysql":
        password      => "$nova_db_password",
        allowed_hosts => "%",
    }
    
    class {"cinder::db::mysql":
        password      => "$cinder_db_password",
        allowed_hosts => "%",
    }
    
    class {"glance::db::mysql":
        password      => "$glance_db_password",
        allowed_hosts => "%",
    }
    
    class {"neutron::db::mysql":
        password      => "$neutron_db_password",
        allowed_hosts => "%",
        dbname        => 'ovs_neutron',
    }

    mysql::db { "trystack":
        user         => "trystack",
        password     => $trystack_db_password,
        host         => '127.0.0.1',
        charset      => 'latin1',
        require      => Class['mysql::config'],
    }
    database_user { "trystack@%":
        password_hash => mysql_password($trystack_db_password),
        provider      => 'mysql',
        require       => Database["trystack"],
    }
    database_grant { "trystack@%/trystack":
        # TODO figure out which privileges to grant.
        privileges => 'all',
        provider   => 'mysql',
        require    => Database_user["trystack@%"]
    }
    
}
