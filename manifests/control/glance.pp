class trystack::control::glance() {

    if $private_ip == '' { fail('private_ip is empty') }
    if $amqp_ip == '' { fail('$amqp_ip is empty') }
    if $mysql_ip == '' { fail('mysql_ip is empty') }
    if $glance_user_password == '' { fail('glance_user_password is empty') }
    if $glance_db_password == '' { fail('glance_db_password is empty') }

    class {"glance::config":
        api_config => { 'DEFAULT/container_format' =>  { value => 'ami,ari,aki,bare,ovf,ova,docker', }, },
    }

    class {"glance::api":
      bind_host => $::ipaddress_em1,
      auth_host => "$private_ip",
      auth_url => "http://$private_ip:5000/",
      registry_host => "$private_ip",
      keystone_tenant => "services",
      keystone_user => "glance",
      keystone_password => "$glance_user_password",
      pipeline => 'keystone',
      sql_connection => "mysql://glance:$glance_db_password@$mysql_ip/glance",
      verbose => true,
      debug => false,
      mysql_module => '2.2',
    }

    class { 'glance::backend::file': }
    
    class {"glance::registry":
      bind_host => $::ipaddress_em1,
      auth_host => "$private_ip",
      keystone_tenant => "services",
      keystone_user => "glance",
      keystone_password => "$glance_user_password",
      sql_connection => "mysql://glance:$glance_db_password@$mysql_ip/glance",
      verbose => true,
      debug => false,
      mysql_module => '2.2',
    }

    class { 'glance::notify::rabbitmq':
        rabbit_host      => "$amqp_ip",
        rabbit_port      => '5672',
        rabbit_use_ssl   => false,
        rabbit_userid    => 'guest',
        rabbit_password  => 'guest',
    }

    # Create firewall rules to allow only the FIREWALL_ALLOWED
    # hosts that need to connect via FIREWALL_PORTS
    # using FIREWALL_CHAIN

    packstack::firewall {'glance_API':
      host => 'ALL',
      service_name => 'glance',
      chain => 'INPUT',
      ports => '9292',
      proto => 'tcp',
    }

}
