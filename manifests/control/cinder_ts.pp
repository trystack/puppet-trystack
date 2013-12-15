class trystack::control::cinder_ts() {

  class {'cinder':
      sql_connection => "mysql://cinder:$cinder_db_password@$private_ip/cinder",
      rpc_backend    => 'cinder.openstack.common.rpc.impl_qpid',
      qpid_hostname  => "$private_ip",
      qpid_password  => "notused",
  }
  
  cinder_config {
      "DEFAULT/glance_host": value => "$private_ip";
      "DEFAULT/secure_delete": value => "false";
      "DEFAULT/quota_gigabytes": value => "3";
      "DEFAULT/quota_volumes": value => "3";
      #"DEFAULT/glusterfs_sparsed_volumes": value => "true";
      #"DEFAULT/glusterfs_qcow2_volumes": value => "true";
  }
  
  class {'cinder::api':
      keystone_password => "$cinder_user_password",
      keystone_tenant => "services",
      keystone_user => "cinder",
      keystone_auth_host => "$private_ip",
  }
  
  class {'cinder::scheduler':
  }
  
  class {'cinder::volume':
  }
  
  class {'cinder::volume::iscsi':
      iscsi_ip_address => "$private_ip",
  }

  #class { 'cinder::volume::glusterfs':
  #    glusterfs_shares => [$gluster_shares],
  #    require => Package['glusterfs-fuse'],
  #}

  
  firewall { '001 cinder incoming':
      proto    => 'tcp',
      dport    => ['3260', '8776'],
      action   => 'accept',
  }
  
  cinder_config{
      'DEFAULT/notification_driver': value => 'cinder.openstack.common.notifier.rpc_notifier'
  }
}
