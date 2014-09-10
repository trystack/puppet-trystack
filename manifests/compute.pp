class trystack::compute() {
  class { '::ntp':
    servers  => [ '10.100.0.1' ],
    restrict => ['10.100.0.0 mask 255.255.255.0 nomodify notrap'],
  }

  package{ ['openstack-selinux', 'glusterfs-fuse']:
      ensure => present,
  }

  class { "trystack::compute::nova_ts": }
  class { "trystack::compute::neutron_ts": }


  exec{'selinux permissive':
       command => '/usr/sbin/setenforce 0',
       onlyif => '/usr/sbin/getenforce | grep Enforcing',
  }
}
