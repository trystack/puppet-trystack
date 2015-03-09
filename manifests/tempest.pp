#The required package for tempest is missing in Khaleesi along with EPEL for CentOS.
#This is a workaround for now since we require EPEL with Foreman/Puppet
#Also is a good place to put anything additional that we wish to install on the tempest node.

class trystack::tempest {

  if $::osfamily == 'RedHat' {
    package { 'subunit-filters':
      ensure    => present,
    }
  }
}
