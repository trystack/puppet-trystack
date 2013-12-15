class trystack::compute() {

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
