
# TODO
# refine iptable rules, their probably giving access to the public
#

class trystack::controller(){
    class {"openstack::db::mysql":
        mysql_root_password  => "$mysql_root_password",
        keystone_db_password => "$keystone_db_password",
        glance_db_password   => "$glance_db_password",
        nova_db_password     => "$nova_db_password",
        cinder_db_password   => "",
        quantum_db_password  => "",

        # MySQL
        mysql_bind_address     => '0.0.0.0',
        mysql_account_security => true,

        # Cinder
        cinder                 => false,

        # quantum
        quantum                => false,

        allowed_hosts          => "%",
        enabled                => true,
    }

    class {"qpid::server":
        auth => "no"
    }


    class {"openstack::keystone":
        db_host               => "127.0.0.1",
        db_password           => "$keystone_db_password",
        admin_token           => "$keystone_admin_token",
        admin_email           => "$admin_email",
        admin_password        => "$admin_password",
        glance_user_password  => "$glance_user_password",
        nova_user_password    => "$nova_user_password",
        cinder_user_password  => "",
        quantum_user_password => "",
        public_address        => "$controller_node_public",
        quantum               => false,
        cinder                => false,
        enabled               => true,
        require               => Class["openstack::db::mysql"],
    }

    class {"openstack::glance":
        db_host               => "127.0.0.1",
        glance_user_password  => "$glance_user_password",
        glance_db_password    => "$glance_db_password",
    }

    # Configure Nova
    class { 'nova':
        sql_connection       => "mysql://nova:${nova_db_password}@127.0.0.1/nova",
        image_service        => 'nova.image.glance.GlanceImageService',
        glance_api_servers   => "http://127.0.0.1:9292/v1",
        verbose              => $verbose,
    }

    class { 'nova::api':
        enabled           => true,
        admin_password    => "$nova_user_password",
        auth_host         => "127.0.0.1",
    }

    nova_config { 'auto_assign_floating_ip': value => 'True' }
    class { 'nova::network':
        private_interface => "$private_interface",
        public_interface  => "$public_interface",
        fixed_range       => "$fixed_network_range",
        floating_range    => "$floating_network_range",
        network_manager   => "nova.network.manager.FlatDHCPManager",
        config_overrides  => {},
        create_networks   => true,
        enabled           => true,
        install_service   => true,
    }

    class { [ 'nova::scheduler', 'nova::cert', 'nova::consoleauth' ]:
        enabled => true,
    }

    class { 'nova::vncproxy':
        host    => "0.0.0.0",
        enabled => true,
    }

    firewall { '001 controller incoming':
        proto    => 'tcp',
        dport    => ['3306', '5000', '5672', '8774', '9292'],
        action   => 'accept',
    }
}
