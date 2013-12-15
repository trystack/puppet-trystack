# Common trystack configurations

class trystack(){
  require ntp
  file {"/root/.ssh/":
        ensure => directory,
        mode   => 700,
  }
  file {"/root/.ssh/authorized_keys":
        ensure => present,
        mode   => 600,
        source => 'puppet:///modules/trystack/ssh_authorized_keys',
  }

  file_line { 'puppet_report_on':
    path    => '/etc/puppet/puppet.conf',
    match   => '^[ ]*report[ ]*=',
    line    => "    report = true",
  }

  #file_line { 'puppet_pluginsync_on':
  #  path    => '/etc/puppet/puppet.conf',
  #  match   => '^[ ]*pluginsync=',
  #  line    => "    pluginsync=true",
  #}

}
