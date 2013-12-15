class trystack::control::keystone_ts() {
    class {"keystone":
        admin_token => "$keystone_admin_token",
        sql_connection => "mysql://keystone_admin:$keystone_db_password@$private_ip/keystone",
        token_format => "PKI",
    }
    
    class {"keystone::roles::admin":
        email => "$admin_email",
        password => "$admin_password",
        admin_tenant => "admin"
    }
    
    class {"keystone::endpoint":
        public_address  => "$public_ip",
        admin_address  => "$private_ip",
        internal_address  => "$private_ip",
    }
    
    firewall { '001 keystone incoming':
        proto    => 'tcp',
        dport    => ['5000', '35357'],
        action   => 'accept',
    }
    
    
    class {"glance::keystone::auth":
        password          => "$glance_user_password",
        public_address    => "$public_ip",
        admin_address     => "$private_ip",
        internal_address  => "$private_ip",
    }
    
    
    class {"cinder::keystone::auth":
        password          => "$cinder_user_password",
        public_address    => "$public_ip",
        admin_address     => "$private_ip",
        internal_address  => "$private_ip",
    }
    
    
    class {"nova::keystone::auth":
        password => "$nova_user_password",
        public_address    => "$public_ip",
        admin_address     => "$private_ip",
        internal_address  => "$private_ip",
        cinder => true,
    }
    
    
    class {"neutron::keystone::auth":
        password          => "$neutron_user_password",
        public_address    => "8.21.28.4",
        admin_address     => "$neutron_ip",
        internal_address  => "$neutron_ip",
    }
    
    
    class { 'ceilometer::keystone::auth':
        password          => "$ceilometer_user_password",
        public_address    => "$public_ip",
        admin_address     => "$private_ip",
        internal_address  => "$private_ip",
    }

    class { 'swift::keystone::auth':
        password          => "$swift_admin_password",
        public_address    => "$public_ip",
        admin_address     => "$private_ip",
        internal_address  => "$private_ip",
    }
}
