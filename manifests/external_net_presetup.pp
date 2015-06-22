class trystack::external_net_presetup {

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

 if ($public_nic == '') or ($public_nic_ip == '') or ($public_nic == "br-ex") or ($public_nic == "br_ex") {
  notify {"Skipping augeas, public_nic ${public_nic}, public_nic_ip ${public_nic_ip}":} 

  exec {'ovs-vsctl -t 10 -- --may-exist add-br br-ex':
       path         => ["/usr/sbin/", "/usr/bin/"],
       unless       => 'ip addr show br-ex | grep "inet "',
       before       => Exec['restart-network-public-nic-ip'],
  }
  ~>
  exec {'systemctl restart network':
       path         => ["/usr/sbin/", "/usr/bin/"],
       refreshonly  => 'true',
  }

  exec {'restart-network-public-nic-ip':
       command      => 'systemctl restart network',
       path         => ["/usr/sbin/", "/usr/bin/"],
       onlyif       => 'ip addr show | grep $(ip addr show br-ex | grep -Eo "inet [\.0-9]+" | cut -d " " -f2) | grep -v br-ex',
  }

 } else {
  #reconfigure public interface to be ovsport
  augeas { "main-$public_nic":
        context => "/files/etc/sysconfig/network-scripts/ifcfg-$public_nic",
        changes => [
                "rm IPADDR",
                "rm NETMASK",
                "rm GATEWAY",
                "rm DNS1",
                "rm BOOTPROTO",
                "rm DEFROUTE",
                "rm IPV6_DEFROUTE",
                "rm IPV6_PEERDNS",
                "rm IPV6_PEERROUTES",
                "rm PEERROUTES",
                "set PEERDNS no",
                "set BOOTPROTO static",
                "set IPV6INIT no",
                "set IPV6_AUTOCONF no",
                "set ONBOOT yes",
                "set TYPE OVSPort",
                "set OVS_BRIDGE br-ex",
                "set PROMISC yes"

        ],
        before  => Class["quickstack::pacemaker::params"],
        require => Service["openvswitch"],
  }

  ->
  #create br-ex interface
  file { 'external_bridge':
        path => '/etc/sysconfig/network-scripts/ifcfg-br-ex',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('trystack/br_ex.erb'),
        before  => Class["quickstack::pacemaker::params"],
  }
  ->
  exec {'ovs-vsctl -t 10 -- --may-exist add-br br-ex':
       path         => ["/usr/sbin/", "/usr/bin/"],
  }
  ~>
  exec {'systemctl restart network':
       path         => ["/usr/sbin/", "/usr/bin/"],
       refreshonly  => 'true',
  }

 }
}
