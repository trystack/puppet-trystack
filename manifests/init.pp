class trystack {
    exec {'disable selinux':
        command => '/usr/sbin/setenforce 0',
        unless => '/usr/sbin/getenforce | grep Permissive',
    }
    
    include stdlib
    stage { 'presetup':
      before => Stage['setup'],
    }
    class { '::ntp':
     stage => presetup,
    }

    class { "trystack::repo":
     stage => presetup,
    }
    ->
    package { "python-rados":
     ensure => latest,
    } 

    package { 'openvswitch':
     ensure  => installed,
    }
    ->
    service {'openvswitch':
     ensure  => 'running',
    }

}
