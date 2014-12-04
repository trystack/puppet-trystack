class trystack::control::keystone_ts() {

    if $public_ip == '' { fail('public_ip is empty') }
    if $private_ip == '' { fail('private_ip is empty') }
    if $mysql_ip == '' { fail('mysql_ip is empty') }
    if $memcache_ip == '' { fail('memcache_ip is empty') }
    if $neutron_ip == '' { fail('neutron_ip is empty') }
    if $keystone_db_password == '' { fail('keystone_db_password is empty') }
    if $keystone_admin_token == '' { fail('keystone_admin_token is empty') }
    if $admin_email == '' { fail('admin_email is empty') }
    if $admin_password == '' { fail('admin_password is empty') }
    if $nova_user_password == '' { fail('nova_user_password is empty') }
    if $cinder_user_password == '' { fail('cinder_user_password is empty') }
    if $glance_user_password == '' { fail('glance_user_password is empty') }
    if $neutron_user_password == '' { fail('neutron_user_password is empty') }
    if $heat_user_password == '' { fail('heat_user_password is empty') }
    if $ceilometer_user_password == '' { fail('ceilometer_user_password is empty') }
    if $swift_user_password == '' { fail('swift_user_password is empty') }


    keystone_config{
        #"token/expiration": value => "3601";
        "token/caching": value => "true";
        "cache/enable": value => "true";
        "cache/backend": value => "dogpile.cache.memcached";
        #"cache/backend_argument": value => "url:$memcache_ip";
        "cache/memcache_servers": value => "${memcache_ip}:11211";
    }

    class {"keystone":
      admin_token => "$keystone_admin_token",
      sql_connection => "mysql://keystone_admin:$keystone_db_password@$mysql_ip/keystone",
      token_format => "PKI",
      token_driver => "keystone.token.persistence.backends.memcache.Token",
      #bind_host => $::ipaddress_em1,
      memcache_servers => ["${memcache_ip}:11211",],
      token_expiration => 3600,
      verbose => true,
      debug => false,
      mysql_module => '2.2',
    }

    class {"keystone::roles::admin":
        email => "$admin_email",
        password => "$admin_password",
        admin_tenant => "admin"
    }

    class {"keystone::endpoint":
        public_address  => "$public_ip",
        admin_address  => "$private_ip",
        internal_address  => "$private_ip",
    }
    

# Run token flush every minute (without output so we won't spam admins)
#cron { 'token-flush':
#    ensure => 'present',
#    command => '/usr/bin/keystone-manage token_flush >/dev/null 2>&1',
#    minute => '*/1',
#    user => 'keystone',
#    require => [User['keystone'], Group['keystone']],
#} -> service { 'crond':
#    ensure => 'running',
#    enable => true,
#}
    # Create firewall rules to allow only the FIREWALL_ALLOWED
    # hosts that need to connect via FIREWALL_PORTS
    # using FIREWALL_CHAIN

    packstack::firewall {'keystone':
      host => 'ALL',
      service_name => 'keystone',
      chain => 'INPUT',
      ports => ['5000', '35357'],
      proto => 'tcp',
    }

    class {"glance::keystone::auth":
      password          => "$glance_user_password",
      public_address    => "$public_ip",
      admin_address     => "$private_ip",
      internal_address  => "$private_ip",
    }
    
    
    class {"cinder::keystone::auth":
      password          => "$cinder_user_password",
      public_address    => "$public_ip",
      admin_address     => "$private_ip",
      internal_address  => "$private_ip",
    }
    
    
keystone_service { "${cinder::keystone::auth::auth_name}_v2":
    ensure      => present,
    type        => "${cinder::keystone::auth::service_type}v2",
    description => "Cinder Service v2",
}

keystone_endpoint { "${cinder::keystone::auth::region}/${cinder::keystone::auth::auth_name}_v2":
    ensure       => present,
    public_url   => "${cinder::keystone::auth::public_protocol}://${cinder::keystone::auth::public_address}:${cinder::keystone::auth::port}/v2/%(tenant_id)s",
    admin_url    => "http://${cinder::keystone::auth::admin_address}:${cinder::keystone::auth::port}/v2/%(tenant_id)s",
    internal_url => "http://${cinder::keystone::auth::internal_address}:${cinder::keystone::auth::port}/v2/%(tenant_id)s",
}


    class {"nova::keystone::auth":
      password => "$nova_user_password",
      public_address    => "$public_ip",
      admin_address     => "$private_ip",
      internal_address  => "$private_ip",
      cinder => true,
    }
    
    
    class {"neutron::keystone::auth":
      password          => "$neutron_user_password",
      public_address    => "$public_ip",
      admin_address     => "$private_ip",
      internal_address  => "$private_ip",
      #public_address    => "$neutron_ip",
      #admin_address     => "$neutron_ip",
      #internal_address  => "$neutron_ip",
    }
    
    
    class { 'ceilometer::keystone::auth':
      password          => "$ceilometer_user_password",
      public_address    => "$public_ip",
      admin_address     => "$private_ip",
      internal_address  => "$private_ip",
    }

    #class { 'swift::keystone::auth':
    #  password          => "$swift_user_password",
    #  public_address    => "$public_ip",
    #  admin_address     => "$private_ip",
    #  internal_address  => "$private_ip",
    #}

    class {"heat::keystone::auth":
      password          => "$heat_user_password",
      public_address    => "$public_ip",
      admin_address     => "$private_ip",
      internal_address  => "$private_ip",
    }

    class {"heat::keystone::auth_cfn":
      password => "$heat_user_password",
      public_address    => "$public_ip",
      admin_address     => "$private_ip",
      internal_address  => "$private_ip",
    }

    keystone_role { 'heat_stack_owner':
      ensure => present,
    }


}
