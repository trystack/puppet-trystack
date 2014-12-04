class trystack::compute::nova_base() {

  if $private_ip == '' { fail('private_ip is empty') }
  if $mysql_ip == '' { fail('mysql_ip is empty') }
  if $amqp_ip == '' { fail('amqp_ip is empty') }
  if $public_fqdn == '' { fail('public_fqdn is empty') }

  include trystack::compute::neutron_ts
  include trystack::compute::ceilometer_ts

  package{'python-cinderclient':
      before => Class["nova"]
  }

  nova_config{
      "DEFAULT/volume_api_class": value => "nova.volume.cinder.API";
      "DEFAULT/cinder_catalog_info": value => "volume:cinder:internalURL";
      "DEFAULT/metadata_host": value => "$private_ip";
      "DEFAULT/sql_connection": value => "mysql://nova@$mysql_ip/nova";
  }

  class {"nova::compute":
      enabled => true,
      vncproxy_protocol => 'http',
      vncproxy_host => "$public_fqdn",
      vncserver_proxyclient_address => "$::ipaddress_em1",
  }

  packstack::firewall {'nova_compute':
    host => "$private_ip",
    service_name => 'nova compute',
    chain => 'INPUT',
    ports => ['5900-5999'],
    proto => 'tcp',
  }


  # if fqdn is not set correctly we have to tell compute agent which host it should query
  if !$::fqdn or $::fqdn != $::hostname {
      ceilometer_config {
          'DEFAULT/host': value => $::hostname
      }
  }

  # Ensure Firewall changes happen before nova services start
  # preventing a clash with rules being set by nova-compute and nova-network
  Firewall <| |> -> Class['nova']
  
  class {"nova":
      glance_api_servers => "$private_ip:9292",
      verbose     => false,
      debug       => false,
      rabbit_host           => "$amqp_ip",
      rabbit_port           => '5672',
      rabbit_userid         => 'guest',
      rabbit_password       => 'guest',
  #nova_public_key    => $public_key,
  #nova_private_key   => $private_key,
  #nova_shell => '/bin/bash',
  }
}
