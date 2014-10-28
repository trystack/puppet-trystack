class trystack::control::nova_ts() {


    if $memcache_ip == '' { fail('memcache_ip is empty') }
    if $mysql_ip == '' { fail('mysql_ip is empty') }
    if $amqp_ip == '' { fail('amqp_ip is empty') }
    if $neutron_ip == '' { fail('neutron_ip is empty') }
    if $private_ip == '' { fail('private_ip is empty') }
    if $nova_db_password == '' { fail('nova_db_password is empty') }
    if $neutron_user_password == '' { fail('neutron_user_password is empty') }
    if $neutron_metadata_shared_secret == '' { fail('neutron_metadata_shared_secret is empty') }
    
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
        #"DEFAULT/keystone_ec2_url": value => "http://$private_ip:5000/v2.0/ec2tokens";
        "DEFAULT/memcache_servers": value => "${memcache_ip}:11211";
        'keystone_authtoken/admin_version':        value => 'v2.0';
    }
    
    class {"nova::cert": enabled => true, }
    class {"nova::conductor": enabled => true, }
    class {"nova::scheduler": enabled => true, }
    class {"nova::vncproxy": enabled => true, }
    class {"nova::consoleauth": enabled => true, }
    
    firewall { '001 novncproxy incoming':
        proto    => 'tcp',
        dport    => ['6080'],
        action   => 'accept',
    }
    
    
    
    # Ensure Firewall changes happen before nova services start
    # preventing a clash with rules being set by nova-compute and nova-network
    Firewall <| |> -> Class['nova']
    
    class {"nova":
        rabbit_host        => "$amqp_ip",
        rabbit_port        => '5672',
        rabbit_userid      => 'guest',
        rabbit_password    => 'guest',
        glance_api_servers => "${private_ip}:9292",
        verbose     => false,
	debug       => false,
#    nova_public_key    => $public_key,
#    nova_private_key   => $private_key,
#    nova_shell => '/bin/bash',
    }

    class {"nova::network::neutron":
      neutron_admin_password => "$neutron_user_password",
      neutron_auth_strategy => "keystone",
      neutron_url => "http://${neutron_ip}:9696",
      neutron_admin_tenant_name => "services",
      neutron_admin_auth_url => "http://${private_ip}:35357/v2.0",
      #vif_plugging_is_fatal => false,
      #vif_plugging_timeout => '10',
    }
    
    class {"nova::compute::neutron":
      #libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver",
      libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtGenericVIFDriver",
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
    
    packstack::firewall {'nova_api':
      host => 'ALL',
      service_name => 'nova api',
      chain => 'INPUT',
      ports => ['8773', '8774', '8775'],
      proto => 'tcp',
    }
}
