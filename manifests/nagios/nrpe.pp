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
            line => "command[check_em2_down]=if /sbin/ip a show em2 | /usr/bin/wc -l | /bin/grep 2 > /dev/null; then echo 'em2 is down'; $(exit 0); else echo 'em2 is up'; $(exit 2); fi",
        }

        # make sure glance storage is mounted
        file_line{'check_mnt_trystack':
            path => '/etc/nagios/nrpe.cfg',
            match => "command\[check_mnt_trystack\]=",
            line => "command[check_mnt_trystack]=/bin/mount | /bin/grep '/mnt/trystack'",
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
