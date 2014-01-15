class trystack::compute::neutron_ts () {

    $neutron_sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_ip}/ovs_neutron"
    
    class { 'neutron':
      rpc_backend => 'neutron.openstack.common.rpc.impl_qpid',
      qpid_hostname => "$qpid_ip",
      core_plugin => 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2',
      verbose => true,
    }
    
    class { 'neutron::plugins::ovs':
      tenant_network_type => 'gre',
      tunnel_id_ranges => '1:1000',
      sql_connection      => $neutron_sql_connection
    }
    
    class { 'neutron::agents::ovs':
      enable_tunneling => true,
      local_ip => $::ipaddress_em1,
    }
    
    
    
    class { 'packstack::neutron::bridge': }
}
