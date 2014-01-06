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
            line => "command[df_var]=df /var/ | sed -re 's/.* ([0-9]+)%.*/\\1/' | grep -E '^[0-9]'",
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

        # delete the old gluster check
        file_line{'check_gluster':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_gluster\]=",
            line => "command[check_gluster]=/usr/lib64/nagios/plugins/check_gluster",
            ensure => 'absent',
        }

        file_line{'check_glusterfs':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_glusterfs\]=",
            line => "command[check_glusterfs]=/usr/lib64/nagios/plugins/check_glusterfs -v trystack -n 3",
        }

    }

    file{"/usr/lib64/nagios/plugins/check_puppet_agent.rb":
        ensure => 'absent',
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

    file{"/usr/lib64/nagios/plugins/check_mnt_trystack":
        mode => 755,
        owner => "nrpe",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/check_mnt_trystack",
    }

    file{"/usr/lib64/nagios/plugins/check_gluster":
        ensure => 'absent',
    }

    package { ['bc', 'nagios-plugins']:
        ensure => 'present',
    }
        
    file{"/usr/lib64/nagios/plugins/check_glusterfs":
        mode => 755,
        owner => "nagios",
        seltype => "nagios_unconfined_plugin_exec_t",
        source => "puppet:///modules/trystack/check_glusterfs",
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
