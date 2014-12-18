class trystack::compute::neutron_ts () {

  # Remove DVR
  package { "openstack-neutron-ml2": ensure => absent, }


  if $private_ip == '' { fail('private_ip is empty') }
  if $neutron_ip == '' { fail('neutron_ip is empty') }
  if $mysql_ip == '' { fail('mysql_ip is empty') }
  if $amqp_ip == '' { fail('amqp_ip is empty') }
  if $neutron_user_password == '' { fail('neutron_user_password is empty') }
  if $neutron_db_password == '' { fail('neutron_db_password is empty') }

  $neutron_sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_ip}/ovs_neutron"

  neutron_config{
      "DEFAULT/nova_url": value => "http://${private_ip}:8774/v2";
      "DEFAULT/router_distributed": value => "False"; #DVR = True
  }

  class { 'neutron':
    rabbit_host        => "$amqp_ip",
    rabbit_port           => '5672',
    rabbit_user           => 'guest',
    rabbit_password       => 'guest',
    core_plugin           => 'neutron.plugins.ml2.plugin.Ml2Plugin',
    allow_overlapping_ips => true,
    service_plugins       => ['neutron.services.loadbalancer.plugin.LoadBalancerPlugin',
                              'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin',
                              'neutron.services.metering.metering_plugin.MeteringPlugin',
                              'neutron.services.firewall.fwaas_plugin.FirewallPlugin'],
    verbose               => true,
    debug                 => false,
  }

  packstack::firewall {'neutron_tunnel':
    host => 'ALL',
    service_name => 'neutron tunnel port',
    chain => 'INPUT',
    ports => '4789',
    proto => 'udp',
  }


  class { 'neutron::agents::ml2::ovs':
    bridge_mappings  => [],
    enable_tunneling => true,
    tunnel_types     => ['vxlan'],
    local_ip         => $::ipaddress_em1,
    vxlan_udp_port   => 4789,
    l2_population    => false,
  }

  file { 'ovs_neutron_plugin.ini':
    path    => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini',
    owner   => 'root',
    group   => 'neutron',
    before  => Service['ovs-cleanup-service'],
    #require => Package['neutron-plugin-ovs'],
    #require => Class['neutron::agents::ml2::ovs'],
  }

  #class { 'packstack::neutron::bridge': }

  class {"nova::network::neutron":
    neutron_admin_password => "$neutron_user_password",
    neutron_auth_strategy => "keystone",
    neutron_url => "http://$neutron_ip:9696",
    neutron_admin_tenant_name => "services",
    neutron_admin_auth_url => "http://$private_ip:35357/v2.0",
    #vif_plugging_is_fatal => false,
    #vif_plugging_timeout => '10',
  }

  class {"nova::compute::neutron":
    libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtGenericVIFDriver",
    #libvirt_vif_driver => "nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver",
  }
}
