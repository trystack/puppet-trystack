class trystack::repo {
    file {'/etc/hosts':
      source=> 'puppet:///modules/trystack/etc.hosts',
    }

    yumrepo { "openstack-juno":
      baseurl => "http://repos.fedorapeople.org/repos/openstack/openstack-juno/epel-7/",
      descr => "RDO Community repository",
      enabled => 1,
      gpgcheck => 0,
   }
}
