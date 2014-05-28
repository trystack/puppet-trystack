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
}

