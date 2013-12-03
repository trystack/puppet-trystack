class trystack::control::cinder_ts() {

  class {'cinder':
      sql_connection => "mysql://cinder:$cinder_db_password@$::ipaddress_em1/cinder",
      rpc_backend    => 'cinder.openstack.common.rpc.impl_qpid',
      qpid_hostname  => "$::ipaddress_em1",
      qpid_password  => "notused",
  }
  
  cinder_config {
      "DEFAULT/glance_host": value => "$::ipaddress_em1";
      "DEFAULT/secure_delete": value => "false";
      "DEFAULT/quota_gigabytes": value => "3";
      "DEFAULT/quota_volumes": value => "3";
      #"DEFAULT/glusterfs_sparsed_volumes": value => "true";
      "DEFAULT/glusterfs_qcow2_volumes": value => "true";
  }
  
  class {'cinder::api':
      keystone_password => "$cinder_user_password",
      keystone_tenant => "services",
      keystone_user => "cinder",
      keystone_auth_host => "$::ipaddress_em1",
  }
  
  class {'cinder::scheduler':
  }
  
  class {'cinder::volume':
  }
  
  class {'cinder::volume::iscsi':
      iscsi_ip_address => "$::ipaddress_em1",
  }

  class { 'cinder::volume::glusterfs':
      glusterfs_shares => [$gluster_shares],
      require => Package['glusterfs-fuse'],
  }

  
  firewall { '001 cinder incoming':
      proto    => 'tcp',
      dport    => ['3260', '8776'],
      action   => 'accept',
  }
  
  cinder_config{
      'DEFAULT/notification_driver': value => 'cinder.openstack.common.notifier.rpc_notifier'
  }
}
