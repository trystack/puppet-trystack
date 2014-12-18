class trystack::control::neutron_ts () {
  if $private_ip == '' { fail('private_ip is empty') }
  if $mysql_ip == '' { fail('mysql_ip is empty') }
  if $amqp_ip == '' { fail('amqp_ip is empty') }
  if $nova_user_password == '' { fail('nova_user_password is empty') }
  if $neutron_user_password == '' { fail('neutron_user_password is empty') }
  if $neutron_db_password == '' { fail('neutron_db_password is empty') }
  if $neutron_metadata_shared_secret == '' { fail('neutron_metadata_shared_secret is empty') }

  $neutron_sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_ip}/neutron"

  #exec { 'neutron-db-manage upgrade':
  #  command     => 'neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head',
  #  path        => '/usr/bin',
  #  user        => 'neutron',
  #  logoutput   => 'on_failure',
  #  before      => Service['neutron-server'],
  #  require     => [Neutron_config['database/connection'], Neutron_config['DEFAULT/core_plugin']],
  #}

  # For cases where "neutron-db-manage upgrade" command is called we need to fill config file first
  if defined(Exec['neutron-db-manage upgrade']) {
    Neutron_plugin_ml2<||> -> File['/etc/neutron/plugin.ini'] -> Exec['neutron-db-manage upgrade']
  }

  class { 'neutron':
    rabbit_host           => "$amqp_ip",
    rabbit_port           => '5672',
    rabbit_user           => 'guest',
    rabbit_password       => 'guest',
    core_plugin           => 'neutron.plugins.ml2.plugin.Ml2Plugin',
    allow_overlapping_ips => true,
    service_plugins       => ['neutron.services.loadbalancer.plugin.LoadBalancerPlugin',
                              'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin',
                              'neutron.services.metering.metering_plugin.MeteringPlugin',
                              'neutron.services.firewall.fwaas_plugin.FirewallPlugin'],
    verbose               => true,
    debug                 => false,
  }

  # Configure nova notifications system
  class { 'neutron::server::notifications':
      nova_admin_username    => 'nova',
      nova_admin_password    => "${nova_user_password}",
      nova_admin_tenant_name => 'services',
      nova_url               => "http://${private_ip}:8774/v2",
      nova_admin_auth_url    => "http://${private_ip}:35357/v2.0",
  }

  class { 'neutron::server':
    sql_connection => $neutron_sql_connection,
    connection => $neutron_sql_connection,
    auth_password => $neutron_user_password,
    auth_host => "$private_ip",
    enabled => true,
    mysql_module   => '2.2',
    sync_db => true,
  }

  class { 'neutron::plugins::ml2':
    type_drivers          => ['vxlan'],
    tenant_network_types  => ['vxlan'],
    mechanism_drivers     => ['openvswitch', 'l2population'],
    flat_networks         => ['*'],
    network_vlan_ranges   => [],
    tunnel_id_ranges      => [],
    vxlan_group           => undef,
    vni_ranges            => ['10:1000'],
    enable_security_group => true,
  }

  packstack::firewall {'neutron_server':
    host => 'ALL',
    service_name => 'neutron server',
    chain => 'INPUT',
    ports => '9696',
    proto => 'tcp',
  }
}    
