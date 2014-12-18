# Common trystack configurations

class trystack(){

  class { "trystack::ntpd": }
  class {"trystack::nagios::nrpe": }

  exec{'selinux permissive':
       command => '/usr/sbin/setenforce 0',
       onlyif => '/usr/sbin/getenforce | grep Enforcing',
  }

  service { 'rsyslog': }

  package { 'audit':
    ensure => present,
  } ->
  service { 'auditd':
    ensure => running,
    enable => true,
  }

  package{['glusterfs-fuse', 'nagios-plugins-load', 'nagios-plugins-ping']:
    ensure => present,
  }


  file {'/etc/cron.hourly/trystack-cleanup.sh':
    content => template('trystack/cron.hourly-trystack-cleanup.sh.erb'),
    ensure => absent,
  }

  #file {"/etc/rsyslog.d/logstash.conf":
  #      ensure => present,
  #      content => "# Send everything to a logstash server on port 5544:\n#*.* @@host1:5544\n",
  #      notify => Service['rsyslog'],
  #}

  file {"/etc/hosts":
    ensure => present,
    source => 'puppet:///modules/trystack/hosts',
  }
  file {"/root/.ssh/":
    ensure => directory,
    mode   => 700,
  }
  file {"/root/.ssh/authorized_keys":
    ensure => present,
    mode   => 600,
    source => 'puppet:///modules/trystack/ssh_authorized_keys',
    require => File['/root/.ssh/'],
    notify => Service['sshd']
  }
  service {'sshd': }

  file_line{'disable password login':
    path => '/etc/ssh/sshd_config',
    match => '^PasswordAuthentication.*',
    line => 'PasswordAuthentication no',
    require => File['/root/.ssh/authorized_keys'],
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


  class { 'munin::client': allow => ['10.100.0.1']}

  firewall { '001 munin incoming':
    proto    => 'tcp',
    dport    => ['4949'],
    iniface  => 'em1',
    action   => 'accept',
  }


  package { 'firewalld':
    ensure => absent,
  }

  service { "firewalld":
    ensure => "stopped",
    enable => false,
    #before => [Service['iptables'], Package['firewalld']],
    before => Package['firewalld'],
  }

  package { ['iptables', 'iptables-services']:
    ensure => present,
  }

  #service { "iptables":
  #  ensure => "running",
  #  require => Package['iptables'],
  #}

  package {['NetworkManager', 'NetworkManager-tui', 'NetworkManager-config-server', 'NetworkManager-glib']:
    ensure => absent,
  }

  service { "NetworkManager":
    ensure => stopped,
    enable => false,
    #before => [Service['iptables'], Package['firewalld']],
    before => Package['NetworkManager'],
  }

  service { "network":
    ensure => running,
    enable => false,
    before => Service['NetworkManager'],
  }
}
