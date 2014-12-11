class trystack::compute {
  class { "quickstack::compute_common":
    auth_host                    => $private_ip,
    glance_host                  => $private_ip,
    libvirt_images_rbd_pool      => 'volumes',
    libvirt_images_rbd_ceph_conf => '/etc/ceph/ceph.conf',
    libvirt_inject_password      => 'false',
    libvirt_inject_key           => 'false',
    libvirt_images_type          => 'rbd',
    mysql_ca                     => $quickstack::params::mysql_ca,
    nova_host                    => $private_ip,
    nova_db_password              => $nova_db_password,
    nova_user_password            => $nova_user_password,
    private_network              => '',
    private_iface                => '',
    private_ip                   => '',
    rbd_user                     => 'volumes',
    rbd_secret_uuid              => '',
    network_device_mtu           => $quickstack::params::network_device_mtu,

    admin_password                => $admin_password,
    ssl                           => false,

    mysql_host                    => $mysql_ip,
    amqp_host                     => $amqp_ip,
    amqp_username                 => 'guest',
    amqp_password                 => 'guest',
    #amqp_nssdb_password           => $quickstack::params::amqp_nssdb_password,

    ceilometer_metering_secret    => $ceilometer_metering_secret,
    ceilometer_user_password      => $ceilometer_user_password,

    cinder_backend_gluster        => $quickstack::params::cinder_backend_gluster,


  }
}
