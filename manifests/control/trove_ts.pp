class trystack::control::trove_ts() {

  if $amqp_ip == '' { fail('amqp_ip is empty') }
  if $mysql_ip == '' { fail('mysql_ip is empty') }
  if $private_ip == '' { fail('private_ip is empty') }
  if $public_ip == '' { fail('public_ip is empty') }
  if $nova_user_password == '' { fail('nova_user_password is empty') }
  if $trove_db_password == '' { fail('trove_db_password is empty') }
  if $trove_user_password == '' { fail('trove_user_password is empty') }

  class {'trove':
    rabbit_host                  => $amqp_ip,
    rabbit_password              => 'guest',
    rabbit_port                  => '5672',
    rabbit_userid                => 'guest',
    database_connection          => "mysql://trove:$trove_db_password@$mysql_ip/trove",
    nova_compute_url             => "http://${private_ip}:8774/v2",
    nova_proxy_admin_user        => 'nova',
    nova_proxy_admin_pass        => $nova_user_password,
    nova_proxy_admin_tenant_name => 'services',
    control_exchange             => 'trove',
    cinder_url                   => false,
    swift_url                    => false,
  }
  class { 'trove::client': }

  class { 'trove::keystone::auth':
    admin_address    => $private_ip,
    internal_address => $private_ip,
    public_address   => $public_ip,
    password         => $trove_user_password,
    region           => 'RegionOne',
  }

  class { 'trove::db::mysql':
    password      => $trove_db_password,
    host          => '%',
    allowed_hosts => '%'
  }

  class { 'trove::api':
    bind_host         => '0.0.0.0',
    auth_url          => "http://${private_ip}:5000/v2.0",
    keystone_password => $trove_user_password,
  }

  class { 'trove::conductor':
    auth_url          => "http://${private_ip}:5000/v2.0"
  }

  class { 'trove::taskmanager':
    auth_url          => "http://${private_ip}:5000/v2.0"
  }

  packstack::firewall {'trove_API':
    host => 'ALL',
    service_name => 'cinder-api',
    chain => 'INPUT',
    ports => ['8779'],
    proto => 'tcp',
  }
}
