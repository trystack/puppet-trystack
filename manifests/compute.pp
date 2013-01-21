
# Common trystack configurations
class trystack::compute(){
    # Configure Nova
    nova_config{
        "network_host": value => "${controller_node_public}";
        "libvirt_inject_partition": value => "-1";
        "metadata_host": value => "$controller_node_public";
        "qpid_hostname": value => "$controller_node_public";
        "rpc_backend": value => "nova.rpc.impl_qpid";
    }

    class { 'nova':
        sql_connection       => "mysql://nova:${nova_db_password}@${controller_node_public}/nova",
        image_service        => 'nova.image.glance.GlanceImageService',
        glance_api_servers   => "http://$controller_node_public:9292/v1",
        verbose              => $verbose,
    }

    # uncomment if on a vm
    #file { "/usr/bin/qemu-system-x86_64":
    #    ensure => link,
    #    target => "/usr/libexec/qemu-kvm",
    #    notify => Service["nova-compute"],
    #}
    #nova_config{
    #    "libvirt_cpu_mode": value => "none";
    #}

    class { 'nova::compute::libvirt':
        #libvirt_type                => "qemu",  # uncomment if on a vm
        vncserver_listen            => "$::ipaddress",
    }

    class {"nova::compute":
        enabled => true,
        vncproxy_host => "$controller_node_public",
        vncserver_proxyclient_address => "$ipaddress",
    }


    firewall { '001 nove compute incoming':
        proto    => 'tcp',
        dport    => '5900-5999',
        action   => 'accept',
    }


}
