class trystack::compute::ceilometer_ts () {

  if $private_ip == '' { fail('private_ip is empty') }
  if $amqp_ip == '' { fail('amqp_ip is empty') }
  if $ceilometer_user_password == '' { fail('ceilometer_user_password is empty') }
  if $ceilometer_metering_secret == '' { fail('ceilometer_metering_secret is empty') }

  ceilometer_config{
      'service_credentials/os_endpoint_type': value => 'internalUrl';
  }

  class { 'ceilometer':
      metering_secret => "$ceilometer_metering_secret",
      verbose         => true,
      debug           => false,
      rabbit_host     => "$amqp_ip",
      rabbit_port     => '5672',
      rabbit_userid   => 'guest',
      rabbit_password => 'guest',
  #    require         => Package['nova-common'],
  }

  class { 'ceilometer::agent::auth':
      auth_url      => "http://${private_ip}:35357/v2.0",
      auth_password => "$ceilometer_user_password",
  }

  class { 'ceilometer::agent::compute': }
}
