class trystack::ceph_deploy (
  $fsid                      = '904c8491-5c16-4dae-9cc3-6ce633a7f4cc',
  $osd_pool_default_pg_num   = '128',
  $osd_pool_default_size     = '1',
  $osd_pool_default_min_size = '1',
  $mon_initial_members       = '',
  $mon_host                  = '',
  $cluster_network           = "10.4.8.0/21",
  $public_network            = "10.4.8.0/21",
  $osd_journal_size          = '1000',
  $osd_ip                    = '',
  $mon_key                   = 'AQDcvhVV+H08DBAA5/0GGcfBQxz+/eKAdbJdTQ==',
  $admin_key                 = 'AQDcvhVV+H08DBAA5/0GGcfBQxz+/eKAdbJdTQ==',
  $images_key                = 'AQAfHBdUKLnUFxAAtO7WPKQZ8QfEoGqH0CLd7A==',
  $volumes_key               = 'AQAfHBdUsFPTHhAAfqVqPq31FFCvyyO7oaOQXw==',
  $boostrap_key              = 'AQDcvhVV+H08DBAA5/0GGcfBQxz+/eKAdbJdTQ==',
) {

  class { 'ceph':
     fsid                      => $fsid,
     osd_pool_default_pg_num   => $osd_pool_default_pg_num,
     osd_pool_default_size     => $osd_pool_default_size,
     osd_pool_default_min_size => $osd_pool_default_min_size,
     mon_initial_members       => $mon_initial_members,
     mon_host                  => $mon_host,
     cluster_network           => $cluster_network,
     public_network            => $public_network,
  }
  ->
  ceph_config {
    'global/osd_journal_size': value => $osd_journal_size;
  }
  ->
  ceph::mon { $::hostname:
     public_addr  => $osd_ip,
     key          => $mon_key,
  }
  
  Ceph::Key {
        inject         => true,
        inject_as_id   => 'mon.',
        inject_keyring => "/var/lib/ceph/mon/ceph-${::hostname}/keyring",
  }
  
  ceph::key { 'client.admin':
        secret  => $admin_key,
        cap_mon => 'allow *',
        cap_osd => 'allow *',
        cap_mds => 'allow',
        mode    => '0644',
  }
  ceph::key { 'client.images':
        secret  => $images_key,
        cap_mon => 'allow r',
        cap_osd => 'allow class-read object_prefix rbd_children, allow rwx pool=images',
        inject  => true,
        mode    => '0644',
  }

  ceph::key { 'client.volumes':
        secret  => $volumes_key,
        cap_mon => 'allow r',
        cap_osd => 'allow class-read object_prefix rbd_children, allow rwx pool=volumes',
        inject  => true,
        mode    => '0644',
  }
  ceph::key { 'client.bootstrap-osd':
        secret  => $boostrap_key,
        cap_mon => 'allow profile bootstrap-osd',
        keyring_path => '/var/lib/ceph/bootstrap-osd/ceph.keyring',
  }
  ->
  ceph::osd { '/osd0': } 
  ->
  exec { 'create volumes pool':
        command => "/usr/bin/ceph osd pool create volumes $osd_pool_default_pg_num",
  }
  ->
  exec { 'create images pool':
        command => "/usr/bin/ceph osd pool create images $osd_pool_default_pg_num",
  }
}
