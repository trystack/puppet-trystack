class trystack::nagios::services {

    nagios_service {'dashboard-login-page':
          check_command	        => 'check_http!-S -H x86.trystack.org -u https://x86.trystack.org/dashboard/',
          host_name             => "_$public_fqdn",
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

    nagios_service {'neutron-external-port-count':
          check_command	        => 'neutron-external-port-count',
          host_name             => "$neutron_ip",
          normal_check_interval	=> 5,
          service_description   => 'number of neutron ports on the external network in use',
          use	                => 'generic-service',
    }

    nagios_service {'swift-list':
          check_command	        => 'swift-list',
          host_name             => "$private_ip",
          normal_check_interval	=> 5,
          service_description   => 'number of swift containers for admin',
          use	                => 'generic-service',
    }

    nagios_service {'heat-stack-list':
          check_command	        => 'heat-stack-list',
          host_name             => "$private_ip",
          normal_check_interval	=> 5,
          service_description   => 'number of heat stacks for admin',
          use	                => 'generic-service',
    }

    nagios_service { 'check_mysql':
          check_command	        => "check_mysql!nagios!$mysql_nagios_password",
          host_name             => "$mysql_ip",
          service_description   => 'MySql Health check',
          use	                => 'generic-service',
    }

    nagios_service { 'load5-host01':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host01',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host01':
          check_command	        => 'check_nrpe!check_puppet_agent',

          host_name             => 'host01',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host01':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host01',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

#    nagios_service { 'load5-host02':
#          check_command	        => 'check_nrpe!load5',
#          host_name             => 'host02',
#          normal_check_interval	=> 5,
#          service_description   => '5 minute load average',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'df_var-host02':
#          check_command	        => 'check_nrpe!df_var',
#          host_name             => 'host02',
#          service_description   => 'Percent disk space used on /var',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'check_puppet_agent-host02':
#          check_command	        => 'check_nrpe!check_puppet_agent',
#          host_name             => 'host02',
#          service_description   => 'Puppet agent status',
#          use	                => 'generic-service',
#    }

    nagios_service {'load5-host03':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host03',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host03':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host03',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host03':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host03',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_mnt_trystack-host03':
          check_command	        => 'check_nrpe!check_mnt_trystack',
          host_name             => 'host03',
          service_description   => 'Glance gluster mount',
          use	                => 'generic-service',
    }

    nagios_service { 'check_swift_proxy-host03':
          check_command	        => 'check_nrpe!check_swift_proxy',
          host_name             => 'host03',
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

    nagios_service { 'check_gre_tunnels_exist-10.100.0.4':
          check_command	        => 'check_nrpe!check_gre_tunnels_exist',
          host_name             => '10.100.0.4',
          service_description   => 'Openvswitch GRE Tunnel exists',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host05':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host05',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host05':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host05',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host05':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host05',
	  service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host05':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host05',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host05':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host05',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host05':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host05',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host06':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host06',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host06':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host06',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host06':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host06',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host06':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host06',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host06':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host06',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host06':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host06',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host07':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host07',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host07':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host07',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host07':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host07',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host07':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host07',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host07':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host07',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host07':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host07',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host08':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host08',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host08':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host08',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host08':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host08',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host08':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host08',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host08':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host08',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host08':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host08',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host09':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host09',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host09':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host09',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host09':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host09',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host09':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host09',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host09':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host09',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host09':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host09',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host10':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host10',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host10':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host10',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host10':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host10',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_trystack-host10':
          check_command	        => 'check_nrpe!check_glusterfs_trystack',
          host_name             => 'host10',
          service_description   => 'Gluster TryStack Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mysql-host10':
          check_command	        => 'check_nrpe!check_glusterfs_mysql',
          host_name             => 'host10',
          service_description   => 'Gluster Mysql Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mongo-host10':
          check_command	        => 'check_nrpe!check_glusterfs_mongo',
          host_name             => 'host10',
          service_description   => 'Gluster Mongo Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host10':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host10',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host10':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host10',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host10':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host10',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host11':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host11',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host11':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host11',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host11':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host11',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_trystack-host11':
          check_command	        => 'check_nrpe!check_glusterfs_trystack',
          host_name             => 'host11',
          service_description   => 'Gluster TryStack Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mysql-host11':
          check_command	        => 'check_nrpe!check_glusterfs_mysql',
          host_name             => 'host11',
          service_description   => 'Gluster Mysql Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mongo-host11':
          check_command	        => 'check_nrpe!check_glusterfs_mongo',
          host_name             => 'host11',
          service_description   => 'Gluster Mongo Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host11':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host11',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host11':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host11',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host11':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host11',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host12':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host12',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host12':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host12',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host12':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host12',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_trystack-host12':
          check_command	        => 'check_nrpe!check_glusterfs_trystack',
          host_name             => 'host12',
          service_description   => 'Gluster TryStack Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mysql-host12':
          check_command	        => 'check_nrpe!check_glusterfs_mysql',
          host_name             => 'host12',
          service_description   => 'Gluster Mysql Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mongo-host12':
          check_command	        => 'check_nrpe!check_glusterfs_mongo',
          host_name             => 'host12',
          service_description   => 'Gluster Mongo Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host12':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host12',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host12':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host12',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host12':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host12',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host13':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host13',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_srv-host13':
          check_command	        => 'check_nrpe!df_srv',
          host_name             => 'host13',
          service_description   => 'Percent disk space used on /srv',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host13':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host13',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_trystack-host13':
          check_command	        => 'check_nrpe!check_glusterfs_trystack',
          host_name             => 'host13',
          service_description   => 'Gluster TryStack Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mysql-host13':
          check_command	        => 'check_nrpe!check_glusterfs_mysql',
          host_name             => 'host13',
          service_description   => 'Gluster Mysql Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mongo-host13':
          check_command	        => 'check_nrpe!check_glusterfs_mongo',
          host_name             => 'host13',
          service_description   => 'Gluster Mongo Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host13':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host13',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host13':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host13',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host13':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host13',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host14':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host14',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_srv-host14':
          check_command	        => 'check_nrpe!df_srv',
          host_name             => 'host14',
          service_description   => 'Percent disk space used on /srv',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host14':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host14',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_trystack-host14':
          check_command	        => 'check_nrpe!check_glusterfs_trystack',
          host_name             => 'host14',
          service_description   => 'Gluster TryStack Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mysql-host14':
          check_command	        => 'check_nrpe!check_glusterfs_mysql',
          host_name             => 'host14',
          service_description   => 'Gluster Mysql Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mongo-host14':
          check_command	        => 'check_nrpe!check_glusterfs_mongo',
          host_name             => 'host14',
          service_description   => 'Gluster Mongo Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host14':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host14',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host14':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host14',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host14':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host14',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

    nagios_service {'load5-host15':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host15',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_srv-host15':
          check_command	        => 'check_nrpe!df_srv',
          host_name             => 'host15',
          service_description   => 'Percent disk space used on /srv',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host15':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host15',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_trystack-host15':
          check_command	        => 'check_nrpe!check_glusterfs_trystack',
          host_name             => 'host15',
          service_description   => 'Gluster Trystack Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mysql-host15':
          check_command	        => 'check_nrpe!check_glusterfs_mysql',
          host_name             => 'host15',
          service_description   => 'Gluster Mysql Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_gluster_mongo-host15':
          check_command	        => 'check_nrpe!check_glusterfs_mongo',
          host_name             => 'host15',
          service_description   => 'Gluster Mongo Health Check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host15':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host15',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host15':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host15',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host15':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host15',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }

#    nagios_service {'load5-host16':
#          check_command	        => 'check_nrpe!load5',
#          host_name             => 'host16',
#          normal_check_interval	=> 5,
#          service_description   => '5 minute load average',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'df_var-host16':
#          check_command	        => 'check_nrpe!df_var',
#          host_name             => 'host16',
#          service_description   => 'Percent disk space used on /var',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'check_puppet_agent-host16':
#          check_command	        => 'check_nrpe!check_puppet_agent',
#          host_name             => 'host16',
#          service_description   => 'Puppet agent status',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'check_mnt_trystack-host16':
#          check_command	        => 'check_nrpe!check_mnt_trystack',
#          host_name             => 'host16',
#          service_description   => 'Glance gluster mount',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'check_swift_proxy-host16':
#          check_command	        => 'check_nrpe!check_swift_proxy',
#          host_name             => 'host16',
#          service_description   => 'Swift Proxy service check',
#          use	                => 'generic-service',
#    }
#
#    nagios_service {'load5-host17':
#          check_command	        => 'check_nrpe!load5',
#          host_name             => 'host17',
#          normal_check_interval	=> 5,
#          service_description   => '5 minute load average',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'df_var-host17':
#          check_command	        => 'check_nrpe!df_var',
#          host_name             => 'host17',
#          service_description   => 'Percent disk space used on /var',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'check_puppet_agent-host17':
#          check_command	        => 'check_nrpe!check_puppet_agent',
#          host_name             => 'host17',
#          service_description   => 'Puppet agent status',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'check_em2_down-host17':
#          check_command	        => 'check_nrpe!check_em2_down',
#          host_name             => 'host17',
#	  service_description   => 'Network interface em2 down',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'check_nova_compute-host17':
#          check_command	        => 'check_nrpe!check_nova_compute',
#          host_name             => 'host17',
#	  service_description   => 'Nova Compute service check',
#          use	                => 'generic-service',
#    }
#
#    nagios_service { 'check_neutron_ovs_agent-host17':
#          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
#          host_name             => 'host17',
#	  service_description   => 'Neutron OVS Agent service check',
#          use	                => 'generic-service',
#    }

    nagios_service {'load5-host18':
          check_command	        => 'check_nrpe!load5',
          host_name             => 'host18',
          normal_check_interval	=> 5,
          service_description   => '5 minute load average',
          use	                => 'generic-service',
    }

    nagios_service { 'df_var-host18':
          check_command	        => 'check_nrpe!df_var',
          host_name             => 'host18',
          service_description   => 'Percent disk space used on /var',
          use	                => 'generic-service',
    }

    nagios_service { 'check_puppet_agent-host18':
          check_command	        => 'check_nrpe!check_puppet_agent',
          host_name             => 'host18',
          service_description   => 'Puppet agent status',
          use	                => 'generic-service',
    }

    nagios_service { 'check_em2_down-host18':
          check_command	        => 'check_nrpe!check_em2_down',
          host_name             => 'host18',
	  service_description   => 'Network interface em2 down',
          use	                => 'generic-service',
    }

    nagios_service { 'check_nova_compute-host18':
          check_command	        => 'check_nrpe!check_nova_compute',
          host_name             => 'host18',
	  service_description   => 'Nova Compute service check',
          use	                => 'generic-service',
    }

    nagios_service { 'check_neutron_ovs_agent-host18':
          check_command	        => 'check_nrpe!check_neutron_ovs_agent',
          host_name             => 'host18',
	  service_description   => 'Neutron OVS Agent service check',
          use	                => 'generic-service',
    }
}
