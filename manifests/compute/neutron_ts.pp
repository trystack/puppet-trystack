class trystack::compute::neutron_ts () {

    $neutron_sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_ip}/ovs_neutron"

    neutron_config{
        "DEFAULT/nova_url": value => "http://${private_ip}:8774/v2";
    }

    neutron_plugin_ovs {
        "AGENT/veth_mtu": value => 1500;
    }
    
    class { 'neutron':
      core_plugin => 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2',
      verbose => false,
      rabbit_host        => "$qpid_ip",
      rabbit_port        => '5672',
      #rabbit_userid      => 'guest',
      rabbit_password    => 'guest',
    }
    
    class { 'neutron::plugins::ovs':
      tenant_network_type => 'gre',
      tunnel_id_ranges => '1:1000',
      #network_vlan_ranges => 'physnet1:1000:2999',
      sql_connection      => $neutron_sql_connection
    }
    
    class { 'neutron::agents::ovs':
      enable_tunneling => true,
      local_ip => $::ipaddress_em1,
      #bridge_mappings => ['physnet1:br-em1'],
    }
    
    
    
    class { 'packstack::neutron::bridge': }
}
