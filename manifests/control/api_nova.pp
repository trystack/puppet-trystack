class trystack::control::api_nova() {

    require 'keystone::python'
    class {"nova::api":
        enabled => true,
        auth_host => "$::ipaddress_em1",
        admin_password => "$nova_user_password",
        neutron_metadata_proxy_shared_secret => "$neutron_metadata_shared_secret"
    }
    
    Package<| title == 'nova-common' |> -> Class['nova::api']
    
    firewall { '001 novaapi incoming':
        proto    => 'tcp',
        dport    => ['8773', '8774', '8775'],
        action   => 'accept',
    }
    
    
    # Ensure Firewall changes happen before nova services start
    # preventing a clash with rules being set by nova-compute and nova-network
    Firewall <| |> -> Class['nova']
    
    nova_config{
        "DEFAULT/metadata_host": value => "$::ipaddress_em1";
        "DEFAULT/sql_connection": value => "mysql://nova:$nova_db_password@$::ipaddress_em1/nova";
    }
    
    class {"nova":
        glance_api_servers => "${::ipaddress_em1}:9292",
        qpid_hostname => "$::ipaddress_em1",
        rpc_backend => 'nova.openstack.common.rpc.impl_qpid',
        verbose     => true,
        debug       => false,
    }
    
    
    class {"nova::network::neutron":
      neutron_admin_password => "$neutron_user_password",
      neutron_auth_strategy => "keystone",
      neutron_url => "http://${::ipaddress_em1}:9696",
      neutron_admin_tenant_name => "services",
      neutron_admin_auth_url => "http://${::ipaddress_em1}:35357/v2.0",
    }
    
    class {"nova::compute::neutron":
      libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver",
    }
}
