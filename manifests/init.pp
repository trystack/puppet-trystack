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

    if ($external_network_flag != '') and str2bool($external_network_flag) {
      class { "trystack::external_net_presetup":
        stage   => presetup,
        require => Class['trystack::repo'],
      }
    }
}
