class trystack {
    
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

}
