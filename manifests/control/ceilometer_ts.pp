class trystack::control::ceilometer_ts() {

    if $amqp_ip == '' { fail('amqp_ip is empty') }
    if $private_ip == '' { fail('private_ip is empty') }
    if $ceilometer_metering_secret == '' { fail('ceilometer_metering_secret is empty') }
    if $ceilometer_user_password == '' { fail('ceilometer_user_password is empty') }

    class { 'ceilometer':
        metering_secret => "$ceilometer_metering_secret",
        verbose         => false,
        debug           => false,
        rabbit_host     => "$amqp_ip",
        rabbit_port     => '5672',
        rabbit_userid   => 'guest',
        rabbit_password => 'guest',
    }
    class { 'ceilometer::db':
        database_connection => "mongodb://${private_ip}:27017/ceilometer",
    }

    class { 'ceilometer::collector': }
    class { 'ceilometer::agent::notification': }
    class { 'ceilometer::agent::central': }
    class { 'ceilometer::alarm::notifier': } 
    class { 'ceilometer::alarm::evaluator': }


    class { 'ceilometer::agent::auth':
        auth_url      => "http://${private_ip}:35357/v2.0",
        auth_password => "$ceilometer_user_password",
    }

    class { 'ceilometer::api':
        keystone_host     => "$private_ip",
        keystone_password => "$ceilometer_user_password",
    }

    packstack::firewall {'ceilometer_api':
      host => 'ALL',
      service_name => 'ceilometer-api',
      chain => 'INPUT',
      ports => '8777',
      proto => 'tcp',
    }
}
