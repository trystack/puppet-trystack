class trystack::control::amqp {

  package {["erlang", "perl-Nagios-Plugin"]:
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
    #config_variables => {"loopback_users" =>  "[]",},
  }

  Package['erlang']->Class['rabbitmq']

  packstack::firewall {'amqp':
    host => '10.100.0.0/24',
    service_name => 'amqp',
    chain => 'INPUT',
    ports => ['5671', '5672'],
    proto => 'tcp',
  }
}
