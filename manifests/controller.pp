
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
        public_address        => "127.0.0.1",
        quantum               => false,
        cinder                => false,
        enabled               => true,
        require               => Class["openstack::db::mysql"],
    }

    class {"openstack::glance":
        db_host               => "127.0.0.1",
        glance_user_password  => "$glance_user_password",
        glance_db_password    => "$glance_db_password",
        require               => Class["openstack::db::mysql"],
    }

    # Configure Nova
    class { 'nova':
        sql_connection       => "mysql://nova:${nova_db_password}@127.0.0.1/nova",
        image_service        => 'nova.image.glance.GlanceImageService',
        glance_api_servers   => "http://127.0.0.1:9292/v1",
        verbose              => $verbose,
        require               => Class["openstack::db::mysql", "qpid::server"],
    }

    class { 'nova::api':
        enabled           => true,
        admin_password    => "$nova_user_password",
        auth_host         => "127.0.0.1",
    }

    nova_config {
        'auto_assign_floating_ip': value => 'True';
        "rpc_backend": value => "nova.rpc.impl_qpid";
        "multi_host": value => "True";
        "force_dhcp_release": value => "False";
    }

    class { [ 'nova::scheduler', 'nova::cert', 'nova::consoleauth' ]:
        enabled => true,
    }

    class { 'nova::vncproxy':
        host    => "0.0.0.0",
        enabled => true,
    }


    package {"horizon-packages":
        name => ["python-memcached", "python-netaddr"],
        notify => Class["horizon"],
    }

    file {"/etc/httpd/conf.d/rootredirect.conf":
        ensure => present,
        content => 'RedirectMatch ^/$ /dashboard/',
        notify => File["/etc/httpd/conf.d/openstack-dashboard.conf"],
    }

    class {'horizon':
        secret_key => "$horizon_secret_key",
        keystone_host => '127.0.0.1',
    }

    class {'memcached':}

    class {'apache':}
    class {'apache::mod::wsgi':}
    file { '/etc/httpd/conf.d/openstack-dashboard.conf':}

    firewall { '001 controller incoming':
        proto    => 'tcp',
        # need to refine this list
        dport    => ['80', '3306', '5000', '35357', '5672', '8773', '8774', '8775', '8776', '9292', '6080'],
        action   => 'accept',
    }
}
