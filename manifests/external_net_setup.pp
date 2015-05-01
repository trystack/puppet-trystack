class trystack::external_net_setup {

  if $public_gateway == '' { fail('public_gateway is empty') }
  if $public_dns == '' { fail('public_dns is empty') }
  if $public_network == '' { fail('public_network is empty') }
  if $public_subnet == '' { fail('public_subnet is empty') }
  if $public_allocation_start == '' { fail('public_allocation_start is empty') }
  if $public_allocation_end == '' { fail('public_allocation_end is empty') }
  if !$controllers_hostnames_array { fail('controllers_hostnames_array is empty') }
  $controllers_hostnames_array_str = $controllers_hostnames_array
  $controllers_hostnames_array = split($controllers_hostnames_array, ',')

  #find public NIC
  $public_nic = get_nic_from_network("$public_network")
  $public_nic_ip = get_ip_from_nic("$public_nic")
  $public_nic_netmask = get_netmask_from_nic("$public_nic")

  #reconfigure public interface to be ovsport
  augeas { "main-$public_nic":
        context => "/files/etc/sysconfig/network-scripts/ifcfg-$public_nic",
        changes => [
                "rm IPADDR",
                "rm NETMASK",
                "rm GATEWAY",
                "rm DNS1",
                "rm BOOTPROTO",
                "set ONBOOT yes",
                "set TYPE OVSPort",
                "set OVS_BRIDGE br-ex",
                "set PROMISC yes"

        ],
        before  => Class["quickstack::pacemaker::params"],
        require => Package["openvswitch"],
  }

  ~>
  exec {"ifdown $public_nic":
        path         => "/usr/sbin",
        refreshonly  => true,
  }
  ~>
  exec {"ifup $public_nic":
        path         => "/usr/sbin",
        refreshonly  => true,
  }

  #create br-ex interface
  augeas { "main-br-ex ":
        context => '/files/etc/sysconfig/network-scripts/ifcfg-br-ex',
        changes => [
                "set DEVICE br-ex",
                "set DEVICETYPE ovs",
                "set IPADDR '$public_nic_ip'",
                "set NETMASK '$public_nic_netmask'",
                "set GATEWAY '$public_gateway'",
                "set DNS1 '$public_dns'",
                "set BOOTPROTO static",
                "set ONBOOT yes",
                "set TYPE OVSBridge",
                "set PROMISC yes"

        ],
        before  => Class["quickstack::pacemaker::params"],
        require => Package["openvswitch"]
  }

  ~>

  exec {'ifdown br-ex':
        path         => "/usr/sbin",
        refreshonly  => true,
  }
  ~>
  exec {'ifup br-ex':
        path         => "/usr/sbin",
        refreshonly  => true,
  }
  ~>
  exec {"ovs-vsctl add-port br-ex $public_nic":
        path         => "/usr/bin",
        refreshonly  => true,
        unless       => "ovs-vsctl list-ifaces br-ex | grep $public_nic"
  }


  Class["trystack::controller_networker"]
  ->
  #update bridge-mappings to physnet1
  file_line { 'ovs':
    ensure  => present,
    path    => '/etc/neutron/plugin.ini',
    line    => '[ovs]',
    require => Class["trystack::controller_networker"],
  }
  ->
  #update bridge-mappings to physnet1
  file_line { 'bridge_mapping':
    ensure  => present,
    path    => '/etc/neutron/plugin.ini',
    line    => 'bridge_mappings = physnet1:br-ex',
    require => Class["trystack::controller_networker"],
  }
  ~>
  Service['neutron-server']

##this way we only let controller1 create the neutron resources
##controller1 should be the active neutron-server at provisioining time

 if $hostname == $controllers_hostnames_array[0] {
  neutron_network { 'provider_network':
    ensure                    => present,
    name                      => 'provider_network',
    admin_state_up            => true,
    provider_network_type     => flat,
    provider_physical_network => 'physnet1',
    router_external           => true,
    tenant_name               => 'admin',
    require                   => Service['neutron-server'],
  }
  ->
  neutron_subnet { 'provider_subnet':
    ensure            => present,
    name              => provider_subnet,
    cidr              => $public_subnet,
    gateway_ip        => $public_gateway,
    allocation_pools  => [ "start=${public_allocation_start},end=${public_allocation_end}" ],
    dns_nameservers   => $public_dns,
    network_name      => 'provider_network',
    tenant_name       => 'admin',
  }
 }
}
