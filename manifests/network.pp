class trystack::network () {

    include '::ntp'

    $neutron_sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_ip}/ovs_neutron"
    
    class { 'neutron':
      rabbit_host           => "$qpid_ip",
      rabbit_port           => '5672',
      rabbit_user           => 'guest',
      rabbit_password       => 'guest',
      core_plugin => 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2',
      verbose => false,
      use_syslog => true,
    }
    
    class { 'neutron::server':
      connection      => $neutron_sql_connection,
      sql_connection      => $neutron_sql_connection,
      auth_password => $neutron_user_password,
      auth_host => "$private_ip",
      enabled => true,
    }
    
    neutron_config{
        "DEFAULT/nova_url": value => "http://${private_ip}:8774/v2";
        "quotas/quota_floatingip": value => "4";
    }

    neutron_plugin_ovs {
        "AGENT/veth_mtu": value => 1504;
    }

    firewall { '001 neutron incoming':
        proto    => 'tcp',
        dport    => ['9696'],
        action   => 'accept',
    }
    
    class { 'neutron::plugins::ovs':
      tenant_network_type => 'gre',
      tunnel_id_ranges => '1:1000',
      sql_connection      => $neutron_sql_connection,
    }
    
    class { 'neutron::agents::l3':
      interface_driver        => 'neutron.agent.linux.interface.OVSInterfaceDriver',
      external_network_bridge => 'br-ex',
    }
    
    sysctl::value { 'net.ipv4.ip_forward':
      value => '1'
    }
    
    
    vs_bridge { 'br-ex':
      ensure => present,
      require => Service['neutron-plugin-ovs-service']
    }
    
    
    class { 'neutron::agents::ovs':
      enable_tunneling => true,
      local_ip => $::ipaddress_em1,
    }
    
    
    neutron_dhcp_agent_config {
        "DEFAULT/dnsmasq_config_file":
            value => "/etc/neutron/dnsmasq-neutron.conf";
    }

    file {'/etc/neutron/dnsmasq-neutron.conf':
        content => "dhcp-option-force=26,1450",
        before => Class['neutron::agents::dhcp'],
    }
  
    class { 'neutron::agents::dhcp':
      interface_driver => 'neutron.agent.linux.interface.OVSInterfaceDriver',
    }
    
    
    class {'neutron::agents::metadata':
      auth_password => "$neutron_metadata_auth_password",
      auth_url      => "http://${private_ip}:35357/v2.0",
      shared_secret => "$neutron_metadata_shared_secret",
      metadata_ip   => "${private_ip}",
    }

    cron { "clean-metadata-logs":
      ensure  => present,
      command => "find /var/log/neutron/neutron-ns-metadata-proxy-* -mtime +5 -exec rm {} \;",
      user    => 'root',
      hour    => 0,
    }
}    
