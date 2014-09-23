class trystack::compute::nova_base() {

    package{'python-cinderclient':
        before => Class["nova"]
    }
    
    nova_config{
        "DEFAULT/volume_api_class": value => "nova.volume.cinder.API";
        "DEFAULT/cinder_catalog_info": value => "volume:cinder:internalURL";
    }
    
    class {"nova::compute":
        enabled => true,
        vncproxy_host => "$public_fqdn",
        vncserver_proxyclient_address => "$::ipaddress_em1",
    }
    
    # Note : remove this once we're installing a version of openstack that isn't
    #        supported on RHEL 6.3
    if $::is_virtual_packstack == "true" and $::osfamily == "RedHat" and
        $::operatingsystemrelease == "6.3"{
        file { "/usr/bin/qemu-system-x86_64":
            ensure => link,
            target => "/usr/libexec/qemu-kvm",
            notify => Service["nova-compute"],
        }
    }
    
    firewall { '001 nova compute incoming':
        proto    => 'tcp',
        dport    => '5900-5999',
        action   => 'accept',
    }
    
    
    ceilometer_config{
        'service_credentials/os_endpoint_type': value => 'internalUrl';
    }
    class { 'ceilometer':
        metering_secret => "$ceilometer_metering_secret",
        verbose         => false,
        debug           => false,
        rabbit_host           => "$qpid_ip",
        rabbit_port           => '5672',
        rabbit_userid         => 'guest',
        rabbit_password       => 'guest',
    }

    class { 'ceilometer::agent::auth':
        auth_url      => "http://${private_ip}:35357/v2.0",
        auth_password => "$ceilometer_user_password",
    }

    
    class { 'ceilometer::agent::compute': }
    
    # if fqdn is not set correctly we have to tell compute agent which host it should query
    if !$::fqdn or $::fqdn != $::hostname {
        ceilometer_config {
            'DEFAULT/host': value => $::hostname
        }
    }
    
    
    
    # Ensure Firewall changes happen before nova services start
    # preventing a clash with rules being set by nova-compute and nova-network
    Firewall <| |> -> Class['nova']
    
    nova_config{
        "DEFAULT/metadata_host": value => "$private_ip";
        "DEFAULT/sql_connection": value => "mysql://nova@$mysql_ip/nova";
    }
    
    class {"nova":
        glance_api_servers => "$private_ip:9292",
        verbose     => false,
        debug       => false,
        rabbit_host           => "$qpid_ip",
        rabbit_port           => '5672',
        rabbit_userid         => 'guest',
        rabbit_password       => 'guest',
    }
    
    
    class {"nova::network::neutron":
      neutron_admin_password => "$neutron_user_password",
      neutron_auth_strategy => "keystone",
      neutron_url => "http://$neutron_ip:9696",
      neutron_admin_tenant_name => "services",
      neutron_admin_auth_url => "http://$private_ip:35357/v2.0",
      vif_plugging_is_fatal => false,
      vif_plugging_timeout => '10',
    }
    
    class {"nova::compute::neutron":
      libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtGenericVIFDriver",
      #libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver",
    }
}
