class trystack::control::ceilometer_ts() {

    class { 'mongodb':
        enable_10gen => false,
        port         => '27017',
        before       => Class['ceilometer::db'],
        require      => Firewall['001 mongodb incoming localhost'],
    }
    
    firewall { '001 mongodb incoming localhost':
        proto       => 'tcp',
        dport       => ['27017'],
        iniface     => 'lo',
        #source      => 'localhost',
        #destination => 'localhost',
        action      => 'accept',
    }

   firewall { '001 ceilometer incoming':
      proto    => 'tcp',
      dport    => ['8777'],
      action   => 'accept',
    }

    
    class { 'ceilometer':
        metering_secret => "$ceilometer_metering_secret",
        qpid_hostname   => "$::ipaddress",
        rpc_backend     => 'ceilometer.openstack.common.rpc.impl_qpid',
        verbose         => true,
        debug           => false,
    }
    
    class { 'ceilometer::db':
        database_connection => 'mongodb://localhost:27017/ceilometer',
        require             => Class['mongodb'],
    }
    
    class { 'ceilometer::collector':
        require => Class['mongodb'],
    }
    
    class { 'ceilometer::agent::central':
        auth_url      => "http://${::ipaddress}:35357/v2.0",
        auth_password => "$ceilometer_user_password",
    }
    
    class { 'ceilometer::api':
        keystone_host     => "$::ipaddress",
        keystone_password => "$ceilometer_user_password",
        require           => Class['mongodb'],
    }

}
