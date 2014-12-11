class trystack::network {
  class { "quickstack::neutron::networker":
    neutron_metadata_proxy_secret => $neutron_metadata_shared_secret,
    neutron_db_password           => $neutron_db_password,
    neutron_user_password         => $neutron_user_password,
    nova_db_password              => $nova_db_password,
    nova_user_password            => $nova_user_password,
    controller_priv_host          => $private_ip,
    ovs_tunnel_iface              => 'em1',
    ovs_tunnel_network            => '',
    ovs_l2_population             => 'True',
    mysql_host                    => $mysql_ip,
    amqp_host                     => $amqp_ip,
    amqp_username                 => 'guest',
    amqp_password                 => 'guest',
    external_network_bridge       => 'br-ex',
    tenant_network_type           => 'vxlan',
  }
}
