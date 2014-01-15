class trystack::control::horizon_ts() {

    package { ["python-memcached", "python-netaddr"]:
        notify => Class["horizon"],
    }

    file {"/etc/httpd/conf.d/rootredirect.conf":
        ensure => present,
        content => "RedirectMatch ^/$ https://$public_fqdn/dashboard/",
        notify => File["/etc/httpd/conf.d/openstack-dashboard.conf"],
    }

    class {'horizon':
       secret_key => "$horizon_secret_key",
       keystone_host => "$private_ip",
    }

    class {'memcached':}

    class {'apache::mod::php': }
    # The apache module purges files it doesn't know about
    # avoid this be referencing them here
    file { '/etc/httpd/conf.d/nagios.conf':}

    #firewall { '001 horizon incoming':
    #    proto    => 'tcp',
    #    dport    => ['443', '80'],
    #    action   => 'accept',
    #}

    if ($::selinux != "false"){
        selboolean{'httpd_can_network_connect':
            value => on,
            persistent => true,
        }
    }

    Exec { timeout => 300 }

    class {'apache::mod::ssl': }
    file {'/etc/httpd/conf.d/ssl.conf':}
    file {'/etc/httpd/conf.d/ssl_redirect.conf':
        source => 'puppet:///modules/trystack/ssl_redirect.conf',
    }

    # set the name of the ssl cert and key file
    file_line{'sslcert':
        path => '/etc/httpd/conf.d/ssl.conf',
        match => '^SSLCertificateFile ',
        line => 'SSLCertificateFile /etc/pki/tls/certs/x86.trystack.org.crt',
        require =>  Class['apache::mod::ssl']
    }

    file_line{'sslkey':
        path => '/etc/httpd/conf.d/ssl.conf',
        match => '^SSLCertificateKeyFile ',
        line => 'SSLCertificateKeyFile /etc/pki/tls/private/x86.trystack.org.key',
        require =>  Class['apache::mod::ssl']
    }
}
