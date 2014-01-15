class trystack::loadbalancer {

    class { 'haproxy': 
        # We want pacemaker to manage this service's state
        # not puppet
        manage_service => false,
    }

    haproxy::listen { "admin":
        mode => 'http',
        ipaddress => '*',
        ports => [8081],
        options => { 'stats' => 'enable', },
    }

    haproxy::frontend { 'keystone-frontend':
        ipaddress => [$private_ip, $public_ip],
        ports     => '5000',
        options   => { 'default_backend' => 'keystone-backend', },
        mode      => 'http',
    }

    haproxy::backend { 'keystone-backend':
        options => { 'balance' => 'roundrobin',
                     'mode'    => 'http',
                     'server'  => ['host3 10.100.0.3:5000 check inter 10s',
                                   'host16 10.100.0.16:5000 check inter 10s',]
        }
    }

    haproxy::frontend { 'keystone-admin-frontend':
        ipaddress => [$private_ip, $public_ip],
        ports     => '35357',
        options   => { 'default_backend' => 'keystone-admin-backend', },
        mode      => 'http',
    }

    haproxy::backend { 'keystone-admin-backend':
        options => { 'balance' => 'roundrobin',
                     'mode'    => 'http',
                     'server'  => ['host3 10.100.0.3:35357 check inter 10s',
                                   'host16 10.100.0.16:35357 check inter 10s',]
        }
    }

    haproxy::frontend { 'nova-ec2-frontend':
        ipaddress => [$private_ip, $public_ip],
        ports     => '8773',
        options   => { 'default_backend' => 'nova-ec2-backend', },
        mode      => 'http',
    }

    haproxy::backend { 'nova-ec2-backend':
        options => { 'balance' => 'roundrobin',
                     'mode'    => 'http',
                     'server'  => ['host3 10.100.0.3:8773 check inter 10s',
                                   'host16 10.100.0.16:8773 check inter 10s',]
        }
    }

    haproxy::frontend { 'nova-api-frontend':
        ipaddress => [$private_ip, $public_ip],
        ports     => '8774',
        options   => { 'default_backend' => 'nova-api-backend', },
        mode      => 'http',
    }

    haproxy::backend { 'nova-api-backend':
        options => { 'balance' => 'roundrobin',
                     'mode'    => 'http',
                     'server'  => ['host3 10.100.0.3:8774 check inter 10s',
                                   'host16 10.100.0.16:8774 check inter 10s',]
        }
    }

    haproxy::frontend { 'nova-metadata-frontend':
        ipaddress => [$private_ip, $public_ip],
        ports     => '8775',
        options   => { 'default_backend' => 'nova-metadata-backend', },
        mode      => 'http',
    }

    haproxy::backend { 'nova-metadata-backend':
        options => { 'balance' => 'roundrobin',
                     'mode'    => 'http',
                     'server'  => ['host3 10.100.0.3:8775 check inter 10s',
                                   'host16 10.100.0.16:8775 check inter 10s',]
        }
    }

    haproxy::frontend { 'glance-frontend':
        ipaddress => [$private_ip, $public_ip],
        ports     => '9292',
        options   => { 'default_backend' => 'glance-backend', },
        mode      => 'http',
    }

    haproxy::backend { 'glance-backend':
        options => { 'balance' => 'roundrobin',
                     'mode'    => 'http',
                     'server'  => ['host3 10.100.0.3:9292 check inter 10s',
                                   'host16 10.100.0.16:9292 check inter 10s',]
        }
    }

    haproxy::frontend { 'glance-registry-frontend':
        ipaddress => [$private_ip, $public_ip],
        ports     => '9191',
        options   => { 'default_backend' => 'glance-registry-backend', },
        mode      => 'http',
    }

    haproxy::backend { 'glance-registry-backend':
        options => { 'balance' => 'roundrobin',
                     'mode'    => 'http',
                     'server'  => ['host3 10.100.0.3:9191 check inter 10s',
                                   'host16 10.100.0.16:9191 check inter 10s',]
        }
    }

    haproxy::frontend { 'cinder-frontend':
        ipaddress => [$private_ip, $public_ip],
        ports     => '8776',
        options   => { 'default_backend' => 'cinder-backend', },
        mode      => 'http',
    }

    haproxy::backend { 'cinder-backend':
        options => { 'balance' => 'roundrobin',
                     'mode'    => 'http',
                     'server'  => ['host3 10.100.0.3:8776 check inter 10s',
                                   'host16 10.100.0.16:8776 check inter 10s',]
        }
    }

    haproxy::frontend { 'swift-frontend':
        ipaddress => [$private_ip, $public_ip],
        ports     => '8080',
        options   => { 'default_backend' => 'swift-backend', },
        mode      => 'http',
    }

    haproxy::backend { 'swift-backend':
        options => { 'balance' => 'roundrobin',
                     'mode'    => 'http',
                     'server'  => ['host3 10.100.0.3:8080 check inter 10s',
                                   'host16 10.100.0.16:8080 check inter 10s',]
        }
    }

}
