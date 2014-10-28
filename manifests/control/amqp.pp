class trystack::control::amqp {

  package { "erlang":
    ensure => "installed"
  }

  class {"rabbitmq":
    port             => '5672',
    ssl_management_port      => '5671',
    ssl              => false,
    ssl_cert         => '',
    ssl_key          => '',
    default_user     => 'guest',
    default_pass     => 'guest',
    package_provider => 'yum',
    admin_enable     => false,
  }

  Package['erlang']->Class['rabbitmq']

#  # Create firewall rules to allow only the FIREWALL_ALLOWED
#  # hosts that need to connect via FIREWALL_PORTS
#  # using FIREWALL_CHAIN
#
#  packstack::firewall {'amqp_10.1.254.2':
#    host => '10.1.254.2',
#    service_name => 'amqp',
#    chain => 'INPUT',
#    ports => ['5671', '5672'],
#    proto => 'tcp',
#  }
#  # Create firewall rules to allow only the FIREWALL_ALLOWED
#  # hosts that need to connect via FIREWALL_PORTS
#  # using FIREWALL_CHAIN
#
#  packstack::firewall {'amqp_10.1.254.6':
#    host => '10.1.254.6',
#    service_name => 'amqp',
#    chain => 'INPUT',
#    ports => ['5671', '5672'],
#    proto => 'tcp',
#  }
#  # Create firewall rules to allow only the FIREWALL_ALLOWED
#  # hosts that need to connect via FIREWALL_PORTS
#  # using FIREWALL_CHAIN
#
#  packstack::firewall {'amqp_10.1.254.4':
#    host => '10.1.254.4',
#    service_name => 'amqp',
#    chain => 'INPUT',
#    ports => ['5671', '5672'],
#    proto => 'tcp',
#  }
}
