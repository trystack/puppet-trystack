class trystack::repo {
  if $::osfamily == 'RedHat' {
    yumrepo { "openstack-juno":
      baseurl => "http://repos.fedorapeople.org/repos/openstack/openstack-juno/epel-7/",
      descr => "RDO Community repository",
      enabled => 1,
      gpgcheck => 0,
    }
  }

}
