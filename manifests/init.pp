class trystack {
    exec {'disable selinux':
        command => '/usr/sbin/setenforce 0',
        unless => '/usr/sbin/getenforce | grep Permissive',
    }
    include stdlib
    stage { 'presetup':
      before => Stage['setup'],
    }

    class { "trystack::repo":
     stage => presetup,
    }

}
