
# TODO
# refine iptable rules, their probably giving access to the public
#

class trystack::controller(){

    pacemaker::corosync { "trystack": }

    pacemaker::corosync::node { "10.100.0.2": }
    pacemaker::corosync::node { "10.100.0.3": }

    pacemaker::resources::ip { "8.21.28.222":
        address => "8.21.28.222",
    }
    pacemaker::resources::ip { "10.100.0.222":
        address => "10.100.0.222",
    }

    pacemaker::resources::lsb { "qpidd": }

    #pacemaker::stonith::ipmilan { "$ipmi_address":
    #    address  => "$ipmi_address",
    #    user     => "$ipmi_user",
    #    password => "$ipmi_pass",
    #    hostlist => "$ipmi_host_list",
    #}

    class {"openstack::db::mysql":
        mysql_root_password  => "$mysql_root_password",
        keystone_db_password => "$keystone_db_password",
        glance_db_password   => "$glance_db_password",
        nova_db_password     => "$nova_db_password",
        cinder_db_password   => "$cinder_db_password",
        quantum_db_password  => "",

        # MySQL
        mysql_bind_address     => '0.0.0.0',
        mysql_account_security => true,

        # Cinder
        cinder                 => true,

        # quantum
        quantum                => false,

        allowed_hosts          => "%",
        enabled                => true,
    }

    class {"qpid::server":
        auth => "no"
    }


    class {"openstack::keystone":
        db_host               => "${pacemaker_priv_floating_ip}",
        db_password           => "$keystone_db_password",
        admin_token           => "$keystone_admin_token",
        admin_email           => "$admin_email",
        admin_password        => "$admin_password",
        glance_user_password  => "$glance_user_password",
        nova_user_password    => "$nova_user_password",
        cinder_user_password  => "$cinder_user_password",
        quantum_user_password => "",
        public_address        => "${pacemaker_pub_floating_ip}",
        admin_address         => "${pacemaker_priv_floating_ip}",
        internal_address      => "${pacemaker_priv_floating_ip}",
        glance_public_address    => "${pacemaker_pub_floating_ip}",
        glance_internal_address  => "${pacemaker_priv_floating_ip}",
        glance_admin_address     => "${pacemaker_priv_floating_ip}",
        nova_public_address      => "${pacemaker_pub_floating_ip}",
        nova_internal_address    => "${pacemaker_priv_floating_ip}",
        nova_admin_address       => "${pacemaker_priv_floating_ip}",
        cinder_public_address    => "${pacemaker_pub_floating_ip}",
        cinder_internal_address  => "${pacemaker_priv_floating_ip}",
        cinder_admin_address     => "${pacemaker_priv_floating_ip}",

        quantum               => false,
        cinder                => true,
        enabled               => true,
        require               => Class["openstack::db::mysql"],
    }

    keystone_config {
    'signing/token_format':  value => "UUID";
    }


    class { 'swift::keystone::auth':
        password => $swift_admin_password,
        address  => "${pacemaker_priv_floating_ip}",
    }

    $glance_sql_connection = "mysql://glance:${glance_db_password}@${pacemaker_priv_floating_ip}/glance"

    # Install and configure glance-api
    class { 'glance::api':
      verbose           => $verbose,
      debug             => $verbose,
      auth_type         => 'keystone',
      auth_port         => '35357',
      auth_host         => $keystone_host,
      keystone_tenant   => 'services',
      keystone_user     => 'glance',
      keystone_password => $glance_user_password,
      sql_connection    => $glance_sql_connection,
      enabled           => $enabled,
      require           => Class["openstack::db::mysql"],
    }

    # Install and configure glance-registry
    class { 'glance::registry':
      verbose           => $verbose,
      debug             => $verbose,
      auth_host         => $keystone_host,
      auth_port         => '35357',
      auth_type         => 'keystone',
      keystone_tenant   => 'services',
      keystone_user     => 'glance',
      keystone_password => $glance_user_password,
      sql_connection    => $glance_sql_connection,
      enabled           => $enabled,
      require           => Class["openstack::db::mysql"],
    }

    # Configure glance storage backend
    class { 'glance::backend::swift':
      swift_store_auth_address => 'http://10.100.0.222:5000/v2.0/',
      swift_store_user => $glance_swift_store_user,
      swift_store_key => $glance_swift_store_key,
    }


    # Configure Nova
    class { 'nova':
        sql_connection       => "mysql://nova:${nova_db_password}@${pacemaker_priv_floating_ip}/nova",
        image_service        => 'nova.image.glance.GlanceImageService',
        glance_api_servers   => "http://${pacemaker_priv_floating_ip}:9292/v1",
        verbose              => $verbose,
        require               => Class["openstack::db::mysql", "qpid::server"],
        rpc_backend          => 'nova.openstack.common.rpc.impl_qpid',
        qpid_hostname        => "$pacemaker_priv_floating_ip",

    }

    class { 'nova::api':
        enabled           => true,
        admin_password    => "$nova_user_password",
        auth_host         => "${pacemaker_priv_floating_ip}",
    }

    nova_config {
        'DEFAULT/auto_assign_floating_ip': value => 'True';
        "DEFAULT/multi_host": value => "True";
        "DEFAULT/force_dhcp_release": value => "False";
        "DEFAULT/quota_volumes": value => 1;
        "DEFAULT/quota_gigabytes": value => 1;
        "DEFAULT/quota_instances": value => 1;
        "DEFAULT/quota_cores": value => 1;
        "DEFAULT/quota_ram": value => 512;
        "DEFAULT/quota_floating_ips": value => 1;
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
        keystone_host => "${pacemaker_priv_floating_ip}",
    }

    file {'/usr/lib/python2.6/site-packages/horizon/templates/splash.html':
        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/lib/python2.6/site-packages/horizon/templates/splash.html',
    }
    file {'/usr/lib/python2.6/site-packages/horizon/templates/auth/login.html':
        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/lib/python2.6/site-packages/horizon/templates/auth/login.html',
    }
    file {'/usr/lib/python2.6/site-packages/horizon/templates/auth/_login.html':
        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/lib/python2.6/site-packages/horizon/templates/auth/_login.html',
    }
    file {'/usr/share/openstack-dashboard/openstack_dashboard/settings.py':
        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/share/openstack-dashboard/openstack_dashboard/settings.py',
    }
    file {'/usr/share/openstack-dashboard/openstack_dashboard/urls.py':
        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/share/openstack-dashboard/openstack_dashboard/urls.py',
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
