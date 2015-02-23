class trystack::repo {
  if $::osfamily == 'RedHat' {
    if $proxy_address != '' {
      $myline= "proxy=${proxy_address}"
      include stdlib
      file_line { 'yumProxy':
        ensure => present,
        path   => '/etc/yum.conf',
        line   => $myline,
        before => Yumrepo['openstack-juno'],
      }
    }

    yumrepo { "openstack-juno":
      baseurl => "http://repos.fedorapeople.org/repos/openstack/openstack-juno/epel-7/",
      descr => "RDO Community repository",
      enabled => 1,
      gpgcheck => 0,
    }
  }
}
