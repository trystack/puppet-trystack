class trystack::control::glance() {

    class {"glance::api":
        bind_host => $::ipaddress_em1,
        auth_host => "$private_ip",
        keystone_tenant => "services",
        keystone_user => "glance",
        keystone_password => "$glance_user_password",
        pipeline => 'keystone',
        sql_connection => "mysql://glance:$glance_db_password@$private_ip/glance"
    }
    
    class { 'glance::backend::file': }
    
    class {"glance::registry":
        bind_host => $::ipaddress_em1,
        auth_host => "$private_ip",
        keystone_tenant => "services",
        keystone_user => "glance",
        keystone_password => "$glance_user_password",
        sql_connection => "mysql://glance:$glance_db_password@$private_ip/glance"
    }
    
    firewall { '001 glance incoming':
        proto    => 'tcp',
        dport    => ['9292'],
        action   => 'accept',
    }
    
    glance_api_config {
        'DEFAULT/notifier_strategy': value => 'qpid'
    }
}
