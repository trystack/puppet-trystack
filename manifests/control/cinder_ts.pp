class trystack::control::cinder_ts {

  if $public_ip == '' { fail('public_ip is empty') }
  if $private_ip == '' { fail('private_ip is empty') }
  if $mysql_ip == '' { fail('mysql_ip is empty') }
  if $memcache_ip == '' { fail('memcache_ip is empty') }
  if $gluster_shares == '' { fail('gluster_shares is empty') }
  if $cinder_db_password == '' { fail('cinder_db_password is empty') }
  if $cinder_user_password == '' { fail('cinder_user_password is empty') }

  class {'cinder':
    sql_connection => "mysql://cinder:$cinder_db_password@$mysql_ip/cinder",
    qpid_password  => "notused",
    rabbit_host      => "$qpid_ip",
    rabbit_port      => '5672',
    rabbit_userid    => 'guest',
    rabbit_password  => 'guest',
    verbose          => true,
    debug            => false,
    mysql_module   => '2.2',
  }
  
  cinder_config {
  #  'DEFAULT/notification_driver': value => 'cinder.openstack.common.notifier.rpc_notifier';
    "DEFAULT/glance_host": value => "$private_ip";
    "DEFAULT/secure_delete": value => "false";
    "DEFAULT/quota_gigabytes": value => "3";
    "DEFAULT/quota_volumes": value => "3";
    #"DEFAULT/glusterfs_sparsed_volumes": value => "true";
    "DEFAULT/glusterfs_qcow2_volumes": value => "true";
    "DEFAULT/memcache_servers": value => "10.100.0.3:11211";
  }
  
  #package {'python-keystone':
  #  notify => Class['cinder::api'],
  #}

  class {'cinder::api':
    bind_host => $::ipaddress_em1,
    keystone_password => "$cinder_user_password",
    keystone_tenant => "services",
    keystone_user => "cinder",
    keystone_auth_host => "$private_ip",
  }
  
  class {'cinder::scheduler': }
  class {'cinder::volume': }
  class {'cinder::ceilometer': }
  class {'cinder::backup': }

  #class {'cinder::volume::iscsi':
  #    iscsi_ip_address => "$private_ip",
  #}

  class {'cinder::backup::swift':
    backup_swift_url => "http://${public_ip}:8080/v1/AUTH_"
  }

  Class['cinder::api'] ~> Service['cinder-backup']

  package{'glusterfs-fuse':
    ensure => present,
  }

  class { 'cinder::volume::glusterfs':
      glusterfs_shares => [$gluster_shares],
      require => Package['glusterfs-fuse'],
  }

  
  packstack::firewall {'cinder':
    host => '10.100.0.0/24',
    service_name => 'cinder',
    chain => 'INPUT',
    ports => ['3260'],
    proto => 'tcp',
  }

  packstack::firewall {'cinder_API':
    host => 'ALL',
    service_name => 'cinder-api',
    chain => 'INPUT',
    ports => ['8776'],
    proto => 'tcp',
  }
    
}
