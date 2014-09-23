class trystack::control::glance() {

    class {"glance::config":
        api_config => { 'DEFAULT/container_format' =>  { value => 'ami,ari,aki,bare,ovf,ova,docker', }, },
    }

    class {"glance::api":
        bind_host => $::ipaddress_em1,
        auth_host => "$private_ip",
        auth_url => "http://$private_ip:5000/",
        registry_host => "$private_ip",
        keystone_tenant => "services",
        keystone_user => "glance",
        keystone_password => "$glance_user_password",
        pipeline => 'keystone',
        sql_connection => "mysql://glance:$glance_db_password@$mysql_ip/glance"
    }
    
    class { 'glance::backend::file': }
    
    class {"glance::registry":
        bind_host => $::ipaddress_em1,
        auth_host => "$private_ip",
        keystone_tenant => "services",
        keystone_user => "glance",
        keystone_password => "$glance_user_password",
        sql_connection => "mysql://glance:$glance_db_password@$mysql_ip/glance"
    }
    
    class { 'glance::notify::rabbitmq':
        rabbit_host      => "$qpid_ip",
        rabbit_port      => '5672',
        rabbit_use_ssl   => 'false',
        rabbit_userid    => 'guest',
        rabbit_password  => 'guest',
    }

    firewall { '001 glance incoming':
        proto    => 'tcp',
        dport    => ['9292'],
        action   => 'accept',
    }
    
}
