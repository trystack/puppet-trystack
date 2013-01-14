# This document serves as an example of how to deploy
# basic single and multi-node openstack environments.
#
# For complete installation example, please refer to:
#   http://edin.no-ip.com/blog/hswong3i/openstack-folsom-deploy-puppet-ubuntu-12-04-howto

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

    firewall { '001 controller incoming':
        proto    => 'tcp',
        dport    => ['3306', '5000', '5672', '9292'],
        action   => 'accept',
    }
}
