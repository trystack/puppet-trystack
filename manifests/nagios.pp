class trystack::nagios {
    if $public_fqdn == '' { fail('public_fqdn is empty') }
    if $private_ip == '' { fail('private_ip is empty') }
    if $mysql_ip == '' { fail('mysql_ip is empty') }
    if $neutron_ip == '' { fail('neutron_ip is empty') }

    package{['nagios',
             'nagios-plugins-nrpe',
             'nagios-plugins-mysql',
             'nagios-plugins-http']:
        ensure => present,
        before => Class['trystack::nagios::configs']
    }

    #class {'apache': }
    #apache::listen { '443': }
    #apache::listen { '8140': }
    ##class {'apache::mod::php': }
    ##class {'apache::mod::wsgi':}
    ##class {'apache::mod::proxy_http':}
    ## The apache module purges files it doesn't know about
    ## avoid this be referencing them here
    #file { '/etc/httpd/conf.d/elasticsearch.conf':}
    #file { '/etc/httpd/conf.d/nagios.conf':}
    #file { '/etc/httpd/conf.d/foreman.conf':}
    #file { '/etc/httpd/conf.d/munin.conf':}
    #file { '/etc/httpd/conf.d/puppet.conf':}
    #file { '/etc/httpd/conf.d/php.conf':}


    ##class { 'foreman': }

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

    class{'nagios::server': 
      apache_httpd_ssl             => false,
    }

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
 
