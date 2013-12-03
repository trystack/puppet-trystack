class trystack::control::glance() {

    class {"glance::api":
        auth_host => "$::ipaddress_em1",
        keystone_tenant => "services",
        keystone_user => "glance",
        keystone_password => "$glance_user_password",
        pipeline => 'keystone',
        sql_connection => "mysql://glance:$glance_db_password@$::ipaddress_em1/glance"
    }
    
    class { 'glance::backend::file': }
    
    class {"glance::registry":
        auth_host => "$::ipaddress_em1",
        keystone_tenant => "services",
        keystone_user => "glance",
        keystone_password => "$glance_user_password",
        sql_connection => "mysql://glance:$glance_db_password@$::ipaddress_em1/glance"
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
