class trystack::control::nova_ts() {


    class {"nova::cert":
        enabled => true,
    }
    
    class {"nova::conductor":
        enabled => true,
    }
    
    nova_config{
        # OpenStack doesn't include the CoreFilter (= CPU Filter) by default
        "DEFAULT/scheduler_default_filters":
            value => "RetryFilter,AvailabilityZoneFilter,RamFilter,ComputeFilter,ComputeCapabilitiesFilter,ImagePropertiesFilter,CoreFilter";
        "DEFAULT/cpu_allocation_ratio": value => "16.0";
        "DEFAULT/ram_allocation_ratio": value => "1.5";
        "DEFAULT/quota_instances": value => "3";
        "DEFAULT/quota_cores": value => "6";
        "DEFAULT/quota_ram": value => "12288";
        "DEFAULT/metadata_host": value => "$::ipaddress_em1";
        "DEFAULT/sql_connection": value => "mysql://nova:$nova_db_password@$mysql_ip/nova";
        "DEFAULT/keystone_ec2_url": value => "http://$private_ip:5000/v2.0/ec2tokens";
        "DEFAULT/memcache_servers": value => "10.100.0.3:11211";
        'keystone_authtoken/admin_version':        value => 'v2.0';

    }
    
    class {"nova::scheduler":
        enabled => true,
    }
    
    class {"nova::vncproxy":
        enabled => true,
    }
    
    class {"nova::consoleauth":
        enabled => true,
    }
    
    firewall { '001 novncproxy incoming':
        proto    => 'tcp',
        dport    => ['6080'],
        action   => 'accept',
    }
    
    
    
    # Ensure Firewall changes happen before nova services start
    # preventing a clash with rules being set by nova-compute and nova-network
    Firewall <| |> -> Class['nova']
    
    class {"nova":
        rabbit_host        => "$qpid_ip",
        rabbit_port        => '5672',
        rabbit_userid      => 'guest',
        rabbit_password    => 'guest',
        glance_api_servers => "${private_ip}:9292",
        verbose     => false,
	debug       => false,
    }
    
    
    class {"nova::network::neutron":
      neutron_admin_password => "$neutron_user_password",
      neutron_auth_strategy => "keystone",
      neutron_url => "http://${neutron_ip}:9696",
      neutron_admin_tenant_name => "services",
      neutron_admin_auth_url => "http://${private_ip}:35357/v2.0",
      vif_plugging_is_fatal => false,
      vif_plugging_timeout => '10',
    }
    
    class {"nova::compute::neutron":
      libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver",
    }



#### Start nova api ####
    require 'keystone::python'
    class {"nova::api":
        api_bind_address => $::ipaddress_em1,
        metadata_listen => $::ipaddress_em1,
        enabled => true,
        auth_host => "$private_ip",
        admin_password => "$nova_user_password",
        neutron_metadata_proxy_shared_secret => "$neutron_metadata_shared_secret"
    }
    
    Package<| title == 'nova-common' |> -> Class['nova::api']
    
    firewall { '001 novaapi incoming':
        proto    => 'tcp',
        dport    => ['8773', '8774', '8775'],
        action   => 'accept',
    }
    
    
}
