class trystack::control::memcache() {

    #package { "python-memcached": }

    class {'memcached': }

    firewall { '001 memcache incoming':
        proto    => 'tcp',
        dport    => ['11211'],
        action   => 'accept',
    }

}
