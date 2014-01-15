class trystack::nagios::services {

    nagios_service {'dashboard-login-page':
          check_command	        => 'check_http!-S -H x86.trystack.org -u http://x68.trystack.org/dashboard/',
          host_name             => "$public_fqdn",
          normal_check_interval	=> 5,
          service_description   => 'load dashboard login',
          use	                => 'generic-service',
    }

    nagios_service {'keystone-user-list':
          check_command	        => 'keystone-user-list',
          host_name             => "$private_ip",
          normal_check_interval	=> 5,
          service_description   => 'number of keystone users',
          use	                => 'generic-service',
    }

    nagios_service {'glance-index':
          check_command	        => 'glance-index',
          host_name             => "$private_ip",
          normal_check_interval	=> 5,
          service_description   => 'number of glance images',
          use	                => 'generic-service',
    }

    nagios_service {'nova-list':
          check_command	        => 'nova-list',
          host_name             => "$private_ip",
          normal_check_interval	=> 5,
          service_description   => 'number of nova instances',
          use	                => 'generic-service',
    }

    nagios_service {'cinder-list':
          check_command	        => 'cinder-list',
          host_name             => "$private_ip",
          normal_check_interval	=> 5,
          service_description   => 'number of cinder volumes',
          use	                => 'generic-service',
    }

    nagios_service {'neutron-floatingip-list':
          check_command	        => 'neutron-floatingip-list',
          host_name             => "$neutron_ip",
          normal_check_interval	=> 5,
          service_description   => 'number of neutron floatingips',
          use	                => 'generic-service',
    }

    nagios_service {'swift-list':
          check_command	        => 'swift-list',
          host_name             => "$private_ip",
          normal_check_interval	=> 5,
          service_description   => 'number of swift containers for admin',
          use	                => 'generic-service',
    }

    nagios_service { 'load5-10.100.0.1':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.1',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.1':
          check_command	        => 'check_nrpe!check_puppet_agent',

          host_name             => '10.100.0.1',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

#    nagios_service { 'load5-10.100.0.2':
#          check_command	        => 'check_nrpe!load5',
#          host_name             => '10.100.0.2',
#          normal_check_interval	=> 5,
#          service_description   => '5 minute load average',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'df_var-10.100.0.2':
#          check_command	        => 'check_nrpe!df_var',
#          host_name             => '10.100.0.2',
#          service_description   => 'Percent disk space used on /var',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'check_puppet_agent-10.100.0.2':
#          check_command	        => 'check_nrpe!check_puppet_agent',
#          host_name             => '10.100.0.2',
#          service_description   => 'Puppet agent status',
#          use	                => 'generic-service',
#    }

    nagios_service {'load5-10.100.0.3':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.3',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.3':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.3',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.3':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.3',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_mnt_trystack-10.100.0.3':
          check_command	        => 'check_nrpe!check_mnt_trystack',
          host_name             => '10.100.0.3',
          service_description   => 'Glance gluster mount',
          use	                => 'generic-service',
    }

    nagios_service { 'check_swift_proxy-10.100.0.3':
          check_command	        => 'check_nrpe!check_swift_proxy',
          host_name             => '10.100.0.3',
          service_description   => 'Swift Proxy service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.4':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.4',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.4':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.4',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.4':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.4',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_server-10.100.0.4':
          check_command	        => 'check_nrpe!check_neutron_server',
          host_name             => '10.100.0.4',
          service_description   => 'Neutron Server service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-10.100.0.4':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => '10.100.0.4',
          service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_dhcp_agent-10.100.0.4':
          check_command	        => 'check_nrpe!check_neutron_dhcp_agent',
          host_name             => '10.100.0.4',
          service_description   => 'Neutron DHCP agent service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_l3_agent-10.100.0.4':
          check_command	        => 'check_nrpe!check_neutron_l3_agent',
          host_name             => '10.100.0.4',
          service_description   => 'Neutron L3 Agent service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_cleanup-10.100.0.4':
          check_command	        => 'check_nrpe!check_neutron_ovs_cleanup',
          host_name             => '10.100.0.4',
          service_description   => 'Neutron OVS Cleanup service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_metadata_agent-10.100.0.4':
          check_command	        => 'check_nrpe!check_neutron_metadata_agent',
          host_name             => '10.100.0.4',
          service_description   => 'Neutron Metadata Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.5':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.5',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.5':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.5',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.5':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.5',
	  service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.5':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.5',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-10.100.0.5':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => '10.100.0.5',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-10.100.0.5':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => '10.100.0.5',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.6':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.6',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.6':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.6',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.6':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.6',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.6':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.6',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-10.100.0.6':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => '10.100.0.6',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-10.100.0.6':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => '10.100.0.6',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.7':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.7',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.7':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.7',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.7':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.7',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.7':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.7',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-10.100.0.7':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => '10.100.0.7',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-10.100.0.7':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => '10.100.0.7',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.8':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.8',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.8':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.8',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.8':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.8',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.8':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.8',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-10.100.0.8':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => '10.100.0.8',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-10.100.0.8':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => '10.100.0.8',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.9':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.9',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.9':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.9',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.9':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.9',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.9':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.9',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-10.100.0.9':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => '10.100.0.9',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-10.100.0.9':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => '10.100.0.9',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.10':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.10',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.10':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.10',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.10':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.10',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.10':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.10',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-10.100.0.10':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => '10.100.0.10',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-10.100.0.10':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => '10.100.0.10',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.11':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.11',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.11':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.11',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.11':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.11',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.11':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.11',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-10.100.0.11':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => '10.100.0.11',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-10.100.0.11':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => '10.100.0.11',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.12':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.12',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.12':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.12',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.12':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.12',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.12':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.12',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-10.100.0.12':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => '10.100.0.12',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-10.100.0.12':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => '10.100.0.12',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.13':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.13',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_srv-10.100.0.13':
          check_command	        => 'check_nrpe!df_srv',
          host_name             => '10.100.0.13',
          service_description   => 'Percent disk space used on /srv',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.13':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.13',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster-10.100.0.13':
          check_command	        => 'check_nrpe!check_glusterfs',
          host_name             => '10.100.0.13',
          service_description   => 'Gluster Server Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.13':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.13',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.14':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.14',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_srv-10.100.0.14':
          check_command	        => 'check_nrpe!df_srv',
          host_name             => '10.100.0.14',
          service_description   => 'Percent disk space used on /srv',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.14':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.14',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster-10.100.0.14':
          check_command	        => 'check_nrpe!check_glusterfs',
          host_name             => '10.100.0.14',
          service_description   => 'Gluster Server Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.14':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.14',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.15':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.15',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_srv-10.100.0.15':
          check_command	        => 'check_nrpe!df_srv',
          host_name             => '10.100.0.15',
          service_description   => 'Percent disk space used on /srv',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.15':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.15',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster-10.100.0.15':
          check_command	        => 'check_nrpe!check_glusterfs',
          host_name             => '10.100.0.15',
          service_description   => 'Gluster Server Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-10.100.0.15':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => '10.100.0.15',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service {'load5-10.100.0.16':
          check_command	        => 'check_nrpe!load5',
          host_name             => '10.100.0.16',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-10.100.0.16':
          check_command	        => 'check_nrpe!df_var',
          host_name             => '10.100.0.16',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-10.100.0.16':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => '10.100.0.16',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_mnt_trystack-10.100.0.16':
          check_command	        => 'check_nrpe!check_mnt_trystack',
          host_name             => '10.100.0.16',
          service_description   => 'Glance gluster mount',
          use	                => 'generic-service',
    }

    nagios_service { 'check_swift_proxy-10.100.0.16':
          check_command	        => 'check_nrpe!check_swift_proxy',
          host_name             => '10.100.0.16',
          service_description   => 'Swift Proxy service check',
          use	                => 'generic-service',
    }

}
