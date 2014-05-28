class trystack::control::heat_ts() {
    class { 'heat':
        keystone_host     => $private_ip,
        keystone_password => $heat_user_password,
        auth_uri          => "http://${private_ip}:35357/v2.0",
        rabbit_host        => "$qpid_ip",
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
}

