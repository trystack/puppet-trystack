class trystack::control::heat_ts() {

    if $public_ip == '' { fail('public_ip is empty') }
    if $private_ip == '' { fail('private_ip is empty') }
    if $mysql_ip == '' { fail('mysql_ip is empty') }
    if $amqp_ip == '' { fail('amqp_ip is empty') }
    if $admin_password == '' { fail('admin_password is empty') }
    if $heat_user_password == '' { fail('heat_user_password is empty') }
    if $heat_db_password == '' { fail('heat_db_password is empty') }
    if $heat_domain_password == '' { fail('heat_domain_password is empty') }
    if $heat_auth_encryption_key == '' { fail('heat_auth_encryption_key is empty') }

    class { 'heat':
        keystone_host     => $private_ip,
        keystone_password => $heat_user_password,
        auth_uri          => "http://${private_ip}:35357/v2.0",
        rabbit_host        => "$amqp_ip",
        rabbit_port        => '5672',
        rabbit_userid      => 'guest',
        rabbit_password    => 'guest',
        verbose       => false,
        debug         => false,
        sql_connection => "mysql://heat:$heat_db_password@$mysql_ip/heat",
    }

    class { 'heat::api': }

    class { 'heat::engine':
        heat_metadata_server_url      => "http://${public_ip}:8000",
        heat_waitcondition_server_url => "http://${public_ip}:8000/v1/waitcondition",
        heat_watch_server_url         => "http://${public_ip}:8003",
        auth_encryption_key           => "${heat_auth_encryption_key}",
    }

    class { 'heat::keystone::domain':
      auth_url          => "http://${private_ip}:35357/v2.0",
      keystone_admin    => 'admin',
      keystone_password => $admin_password,
      keystone_tenant   => 'admin',
      domain_name       => 'heat',
      domain_admin      => 'heat_admin',
      domain_password   => $heat_domain_password,
    }

    heat_config {
      'DEFAULT/deferred_auth_method'   : value => 'trusts';
      'DEFAULT/trusts_delegated_roles' : value => 'heat_stack_owner';
    }

    #keystone_user_role { 'admin@admin':
    #  ensure => present,
    #  roles  => ['admin', '_member_', 'heat_stack_owner'],
    #}

    class { 'heat::api_cfn': }

    packstack::firewall {'heat_cfn':
      host => 'ALL',
      service_name => 'heat_cfn',
      chain => 'INPUT',
      ports => '8000',
      proto => 'tcp',
    }

    packstack::firewall {'heat':
      host => 'ALL',
      service_name => 'heat',
      chain => 'INPUT',
      ports => '8004',
      proto => 'tcp',
    }
}

