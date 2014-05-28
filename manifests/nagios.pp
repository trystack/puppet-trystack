class trystack::nagios {
#Exec { timeout => 300 }

    package{['nagios',
             'nagios-plugins-nrpe',
             'nagios-plugins-ping',
             'nagios-plugins-mysql']:
        ensure => present,
        before => Class['trystack::nagios::configs']
    }

    class {'apache': }
    class {'apache::mod::php': }
    class {'apache::mod::wsgi':}
    class {'apache::mod::proxy_http':}
    # The apache module purges files it doesn't know about
    # avoid this be referencing them here
    file { '/etc/httpd/conf.d/elasticsearch.conf':}
    file { '/etc/httpd/conf.d/nagios.conf':}
    file { '/etc/httpd/conf.d/foreman.conf':}
    file { '/etc/httpd/conf.d/munin.conf':}
    file { '/etc/httpd/conf.d/passenger.conf':}
    file { '/etc/httpd/conf.d/ssl.conf':}
    file { '/etc/httpd/conf.d/puppet.conf':}

    service{['nagios']:
        ensure => running,
        enable => true,
        hasstatus => true,
    }

    #firewall { '001 nagios incoming':
    #    proto    => 'tcp',
    #    dport    => ['80'],
    #    action   => 'accept',
    #}

    class{'trystack::nagios::configs':
        notify => [Service['nagios'], Service['httpd']],
    }

    class{'trystack::nagios::commands':
        notify  => [Service['nagios'], Service['httpd']],
        require => Class['trystack::nagios::configs'],
    }

    class{'trystack::nagios::hosts':
        notify  => [Service['nagios'], Service['httpd']],
        require => Class['trystack::nagios::commands'],
    }

    class{'trystack::nagios::services':
        notify  => [Service['nagios'], Service['httpd']],
        require => Class['trystack::nagios::hosts'],
    }
}
 
