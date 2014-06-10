class trystack::compute::nova_ts() {

    # Ensure Firewall changes happen before libvirt service start
    # preventing a clash with rules being set by libvirt
    Firewall <| |> -> Class['nova::compute::libvirt']
    
    if $::is_virtual_packstack == "true" {
        $libvirt_type = "qemu"
        nova_config{
            "DEFAULT/libvirt_cpu_mode": value => "none";
        }
    }else{
        $libvirt_type = "kvm"
    }
    
    package{'python-cinderclient':
        before => Class["nova"]
    }
    
    nova_config{
        "DEFAULT/libvirt_inject_partition": value => "-1";
        "DEFAULT/volume_api_class": value => "nova.volume.cinder.API";
        "DEFAULT/cinder_catalog_info": value => "volume:cinder:internalURL";
    }
    
    class {"nova::compute":
        enabled => true,
        vncproxy_host => "$public_fqdn",
        vncserver_proxyclient_address => "$::ipaddress_em1",
    }
    
    package { 'qemu-kvm':
        ensure => "installed",
        require => Class['nova::compute::libvirt']
    }
    
    class { 'nova::compute::libvirt':
      libvirt_type                => "$libvirt_type",
      vncserver_listen            => "$::ipaddress_em1",
    }
    
    exec {'load_kvm':
        user => 'root',
        command => '/bin/sh /etc/sysconfig/modules/kvm.modules',
        unless => '/usr/bin/test -e /etc/sysconfig/modules/kvm.modules',
    }
    
    Class['nova::compute']-> Exec["load_kvm"]
    
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
    
    
    # Tune the host with a virtual hosts profile
    package {'tuned':
        ensure => present,
    }
    
    service {'tuned':
        ensure => running,
        require => Package['tuned'],
    }
    
    exec {'tuned-virtual-host':
        unless => '/usr/sbin/tuned-adm active | /bin/grep virtual-host',
        command => '/usr/sbin/tuned-adm profile virtual-host',
        require => Service['tuned'],
    }
    
    file_line { 'libvirt-guests':
        path  => '/etc/sysconfig/libvirt-guests',
        line  => 'ON_BOOT=ignore',
        match => '^[\s#]*ON_BOOT=.*',
        require => Class['nova::compute::libvirt']
    }
    
    # Remove libvirt's default network (usually virbr0) as it's unnecessary and can be confusing
    exec {'virsh-net-destroy-default':
        onlyif  => '/usr/bin/virsh net-list | grep default',
        command => '/usr/bin/virsh net-destroy default',
        require => Package['libvirt'],
    }
    
    exec {'virsh-net-undefine-default':
        onlyif  => '/usr/bin/virsh net-list --inactive | grep default',
        command => '/usr/bin/virsh net-undefine default',
        require => Exec['virsh-net-destroy-default'],
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
        "DEFAULT/vif_plugging_is_fatal": value => false;
        "DEFAULT/vif_plugging_timeout": value => 0;
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
      vif_plugging_timeout => '300',
    }
    
    class {"nova::compute::neutron":
      libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtGenericVIFDriver",
      #libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver",
    }
}
