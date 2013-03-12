class trystack::swift_node {

    #### Common ####
    class { 'ssh::server::install': }
    
    Class['swift'] -> Service <| |>
    class { 'swift':
        swift_hash_suffix => $swift_shared_secret,
        package_ensure    => latest,
    }
    
    # We need to disable this while rsync causes AVC's
    exec{'setenforce 0':
      path => '/usr/sbin',
      notify => Class['swift']
    }

    #### Builder ####
    class { 'swift::ringbuilder':
      part_power     => '18',
      replicas       => '3',
      min_part_hours => 1,
      require        => Class['swift'],
    }
    
    # sets up an rsync db that can be used to sync the ring DB
    class { 'swift::ringserver':
      local_net_ip => "10.100.0.13",
    }
    
    @@swift::ringsync { ['account', 'object', 'container']:
     ring_server => $swift_local_net_ip
    }
    
    
    firewall { '001 rsync incoming':
        proto    => 'tcp',
        dport    => ['873'],
        action   => 'accept',
    }
    
    if ($::selinux != "false"){
        selboolean{'rsync_export_all_ro':
            value => on,
            persistent => true,
        }
    }

   #### Storage ####
   class { 'swift::storage::all':
     storage_local_net_ip => $::ipaddress_em1,
     require => Class['swift'],
   }
   
   swift::storage::ext4 { "lv_swift":
        device => "/dev/vg_${$::hostname}/lv_swift",
   }

   if(!defined(File['/srv/node'])) {
     file { '/srv/node':
       owner  => 'swift',
       group  => 'swift',
       ensure => directory,
       require => Package['openstack-swift'],
     }
   }
   
   swift::ringsync{["account","container","object"]:
       ring_server => '10.100.0.13',
       before => Class['swift::storage::all'],
       require => Class['swift'],
   }
   
   firewall { '001 swift storage incoming':
       proto    => 'tcp',
       dport    => ['6000', '6001', '6002', '873'],
       action   => 'accept',
   }


}
