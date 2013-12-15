class trystack::nagios::configs {

    file{['/etc/nagios/nagios_command.cfg', '/etc/nagios/nagios_host.cfg']:
        ensure => 'present',
        mode => '0644',
        owner => 'nagios',
        group => 'nagios',
    }

    # Remove the entry for localhost, it contains services we're not
    # monitoring
    file{['/etc/nagios/objects/localhost.cfg']:
        ensure => 'present',
        content => '',
    }

    file_line{'nagios_host':
        path => '/etc/nagios/nagios.cfg',
        line => 'cfg_file=/etc/nagios/nagios_host.cfg',
    }

    file_line{'nagios_command':
        path => '/etc/nagios/nagios.cfg',
        line => 'cfg_file=/etc/nagios/nagios_command.cfg',
    }

    file_line{'nagios_service':
        path => '/etc/nagios/nagios.cfg',
        line => 'cfg_file=/etc/nagios/nagios_service.cfg',
    }

    nagios_command{'check_nrpe':
        command_line => '/usr/lib64/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -c $ARG1$',
    }

    exec{'nagiospasswd':
        command => "/usr/bin/htpasswd -bc /etc/nagios/passwd $nagios_user $nagios_password",
        creates => "/etc/nagios/passwd",
    }

    file {"/etc/nagios/keystonerc_admin":
        ensure  => "present", owner  => "nagios", mode => '0600',
        content => "export OS_USERNAME=admin
export OS_TENANT_NAME=admin
export OS_PASSWORD=$admin_password
export OS_AUTH_URL=http://$private_ip:5000/v2.0/
",}

}
