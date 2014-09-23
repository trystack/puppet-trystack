class trystack::nagios::nrpe {
    Exec { timeout => 300 }

    package{'nrpe':
        ensure => present,
        before => Class['nagios_configs']
    }

    class nagios_configs(){
        file_line{'allowed_hosts':
            path => '/etc/nagios/nrpe.cfg',
            match => 'allowed_hosts=',
            line => "allowed_hosts=$nagios_ip",
        }

        # 5 minute load average
        file_line{'load5':
            path => '/etc/nagios/nrpe.cfg',
            match => 'command\[load5\]=',
            line => 'command[load5]=cut /proc/loadavg -f 1 -d " "',
        }

        # disk used on /var
        file_line{'df_var':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[df_var\]=",
            line => "command[df_var]=/usr/lib64/nagios/plugins/check_df_var",
        }

        # disk used on /var
        file_line{'df_srv':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[df_srv\]=",
            line => "command[df_srv]=df /srv/ | sed -re 's/.* ([0-9]+)%.*/\\1/' | grep -E '^[0-9]'",
        }

        # puppet agent status
        file_line{'check_puppet_agent':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_puppet_agent\]=",
            line => "command[check_puppet_agent]=/usr/lib64/nagios/plugins/check_puppet_agent",
        }

        # ensure em2 is down
        file_line{'check_em2_down':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_em2_down\]=",
            line => "command[check_em2_down]=/usr/lib64/nagios/plugins/check_em2_down",
        }

        # make sure glance storage is mounted
        file_line{'check_mnt_trystack':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_mnt_trystack\]=",
            line => "command[check_mnt_trystack]=/usr/lib64/nagios/plugins/check_mnt_trystack",
        }

        file_line{'check_glusterfs_trystack':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_glusterfs_trystack\]=",
            line => "command[check_glusterfs_trystack]=/usr/lib64/nagios/plugins/check_glusterfs -v trystack -n 3",
        }

        file_line{'check_glusterfs_mysql':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_glusterfs_mysql\]=",
            line => "command[check_glusterfs_mysql]=/usr/lib64/nagios/plugins/check_glusterfs -v mysql -n 3",
        }

        file_line{'check_glusterfs_mongo':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_glusterfs_mongo\]=",
            line => "command[check_glusterfs_mongo]=/usr/lib64/nagios/plugins/check_glusterfs -v mongo -n 3",
        }

        file_line{'check_neutron_dhcp_agent':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_neutron_dhcp_agent\]=",
            line => "command[check_neutron_dhcp_agent]=/usr/lib64/nagios/plugins/check_service neutron-dhcp-agent",
        }

        file_line{'check_neutron_server':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_neutron_server\]=",
            line => "command[check_neutron_server]=/usr/lib64/nagios/plugins/check_service neutron-server",
        }

        file_line{'check_neutron_l3_agent':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_neutron_l3_agent\]=",
            line => "command[check_neutron_l3_agent]=/usr/lib64/nagios/plugins/check_service neutron-l3-agent",
        }

        file_line{'check_neutron_lbaas_agent':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_neutron_lbaas_agent\]=",
            line => "command[check_neutron_lbaas_agent]=/usr/lib64/nagios/plugins/check_service neutron-lbaas-agent",
        }

        file_line{'check_neutron_metadata_agent':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_neutron_metadata_agent\]=",
            line => "command[check_neutron_metadata_agent]=/usr/lib64/nagios/plugins/check_service neutron-metadata-agent",
        }

        file_line{'check_neutron_ovs_cleanup':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_neutron_ovs_cleanup\]=",
            line => "command[check_neutron_ovs_cleanup]=/usr/lib64/nagios/plugins/check_service neutron-ovs-cleanup",
        }

        file_line{'check_swift_proxy':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_swift_proxy\]=",
            line => "command[check_swift_proxy]=/usr/lib64/nagios/plugins/check_service openstack-swift-proxy",
        }

        file_line{'check_nova_compute':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_nova_compute\]=",
            line => "command[check_nova_compute]=/usr/lib64/nagios/plugins/check_service openstack-nova-compute",
        }

        file_line{'check_neutron_ovs_agent':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_neutron_ovs_agent\]=",
            line => "command[check_neutron_ovs_agent]=/usr/lib64/nagios/plugins/check_service neutron-openvswitch-agent",
        }

        file_line{'check_memcached':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_memcached\]=",
            line => "command[check_memcached]=/usr/lib64/nagios/plugins/check_service memcached",
        }

        file_line{'check_gre_tunnels_exist':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_gre_tunnels_exist\]=",
            line => "command[check_gre_tunnels_exist]=/usr/lib64/nagios/plugins/check_gre_tunnels_exist",
        }

    }

    file{"/usr/lib64/nagios/plugins/check_puppet_agent":
        mode => 755,
        owner => "nrpe",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/check_puppet_agent",
    }

    file{"/usr/lib64/nagios/plugins/check_em2_down":
        mode => 755,
        owner => "nrpe",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/check_em2_down",
    }

    file{"/usr/lib64/nagios/plugins/check_df_var":
        mode => 755,
        owner => "nrpe",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/check_df_var",
    }

    file{"/usr/lib64/nagios/plugins/check_mnt_trystack":
        mode => 755,
        owner => "nrpe",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/check_mnt_trystack",
    }

    package { ['bc', 'nagios-plugins']:
        ensure => 'present',
    }
        
    file{"/usr/lib64/nagios/plugins/check_service":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/check_service",
    }

    file{"/usr/lib64/nagios/plugins/check_glusterfs":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/check_glusterfs",
        require => [Package['bc'], Package['nagios-plugins']],
    }

    file{"/usr/lib64/nagios/plugins/check_gre_tunnels_exist":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/check_gre_tunnels_exist",
        require => [Package['bc'], Package['nagios-plugins']],
    }

    file{"/etc/sudoers.d/nagios":
        ensure => 'absent',
    }

    file{"/etc/sudoers.d/nrpe":
        mode => 440,
        owner => "root",
        source => "puppet:///modules/trystack/sudoers.d_nrpe",
    }

    class{'nagios_configs':
        notify => Service['nrpe'],
    }

    service{'nrpe':
        ensure => running,
        enable => true,
        hasstatus => true,
        require => Firewall['001 nrpe incoming'],
    }

    firewall { '001 nrpe incoming':
        proto    => 'tcp',
        dport    => ['5666'],
        iniface  => 'em1',
        action   => 'accept',
    }

}
