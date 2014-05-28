class trystack::nagios::commands {

    package { ['python-keystoneclient',
               'python-glanceclient',
               'python-novaclient',
               'python-swiftclient',
               'python-cinderclient',
               'python-neutronclient']:
        ensure => 'present',
    }

    file{"/usr/lib64/nagios/plugins/keystone-user-list":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        content => template("packstack/keystone-user-list.erb"),
    }

    nagios_command {"keystone-user-list":
        command_line => "/usr/lib64/nagios/plugins/keystone-user-list",
        require => Package['python-keystoneclient'],
    }

    file{"/usr/lib64/nagios/plugins/glance-index":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        content => template("packstack/glance-index.erb"),
    }
 
    nagios_command {"glance-index":
        command_line => "/usr/lib64/nagios/plugins/glance-index",
        require => Package['python-glanceclient'],
    }

    file{"/usr/lib64/nagios/plugins/nova-list":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/nova-list",
    }

    nagios_command {"nova-list":
        command_line => "/usr/lib64/nagios/plugins/nova-list",
        require => Package['python-novaclient'],
    }

    file{"/usr/lib64/nagios/plugins/cinder-list":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        content => template("packstack/cinder-list.erb"),
    }

    nagios_command {"cinder-list":
        command_line => "/usr/lib64/nagios/plugins/cinder-list",
        require => Package['python-cinderclient'],
    }

    file{"/usr/lib64/nagios/plugins/swift-list":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        content => template("packstack/swift-list.erb"),
    }

    nagios_command {"swift-list":
        command_line => "/usr/lib64/nagios/plugins/swift-list",
        require => Package['python-swiftclient'],
    }

    file{"/usr/lib64/nagios/plugins/neutron-floatingip-list":
        ensure => "absent",
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/neutron-floatingip-list",
    }

    file{"/usr/lib64/nagios/plugins/neutron-external-port-count":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/neutron-external-port-count",
    }

    nagios_command {"neutron-floatingip-list":
        ensure => "absent",
        command_line => "/usr/lib64/nagios/plugins/neutron-floatingip-list",
        require => Package['python-neutronclient'],
    }

    nagios_command {"neutron-external-port-count":
        command_line => "/usr/lib64/nagios/plugins/neutron-external-port-count",
        require => Package['python-neutronclient'],
    }

    nagios_command {"check_mysql":
        command_line => "/usr/lib64/nagios/plugins/check_mysql",
        require => Package['nagios-plugins-mysql'],
    }
}
