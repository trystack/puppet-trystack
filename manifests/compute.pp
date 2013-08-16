
# Common trystack configurations
class trystack::compute(){

class {"nova::conductor":
    enabled => true,
}

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
    "DEFAULT/network_host": value => "$::ipaddress";
    "DEFAULT/libvirt_inject_partition": value => "-1";
    "DEFAULT/volume_api_class": value => "nova.volume.cinder.API";
        "DEFAULT/multi_host": value => "True";
}

class {"nova::compute":
    enabled => true,
    vncproxy_host => "$vncproxy_host",
    vncserver_proxyclient_address => "$em1_static",
}

class { 'nova::compute::libvirt':
  libvirt_type                => "$libvirt_type",
  vncserver_listen            => "$em1_static",
}

exec {'load_kvm':
    user => 'root',
    command => '/bin/sh /etc/sysconfig/modules/kvm.modules'
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

# Need to start dbus for libvirt
if($::operatingsystem == 'Fedora') {
    service { 'messagebus':
        name     => 'dbus',
        ensure   => running,
        enable   => true,
    }
} else {
   service { 'messagebus':
        ensure   => running,
        enable   => true,
    }
}
Package['libvirt'] -> Service['messagebus'] -> Service['libvirt']


nova_config{
    "DEFAULT/default_floating_pool": value => 'nova';
    "DEFAULT/auto_assign_floating_ip": value => 'True';
}

class { 'nova::network':
    private_interface => "$private_interface",
    public_interface  => "$public_interface",
    fixed_range       => "$fixed_network_range",
    floating_range    => "$floating_network_range",
network_size => '1024',
    network_manager   => "nova.network.manager.FlatDHCPManager",
    config_overrides  => {"force_dhcp_release" => false},
    create_networks   => true,
    enabled           => true,
    install_service   => true,
}



package { 'dnsmasq': ensure => present }

nova_config{
    # OpenStack doesn't include the CoreFilter (= CPU Filter) by default
    "DEFAULT/scheduler_default_filters":
        value => "RetryFilter,AvailabilityZoneFilter,RamFilter,ComputeFilter,ComputeCapabilitiesFilter,ImagePropertiesFilter,CoreFilter";
    "DEFAULT/cpu_allocation_ratio":
        value => "16.0";
    "DEFAULT/ram_allocation_ratio":
        value => "1.5";
}

# Ensure Firewall changes happen before nova services start
# preventing a clash with rules being set by nova-compute and nova-network
Firewall <| |> -> Class['nova']

nova_config{
    "DEFAULT/metadata_host": value => "$::ipaddress";
}

class { 'nova':
    sql_connection       => "mysql://nova:${nova_db_password}@${pacemaker_priv_floating_ip}/nova",
    image_service        => 'nova.image.glance.GlanceImageService',
    glance_api_servers   => "$pacemaker_priv_floating_ip:9292",
    verbose              => $verbose,
    rpc_backend          => 'nova.openstack.common.rpc.impl_qpid',
    qpid_hostname        => "$pacemaker_priv_floating_ip",
}
}
