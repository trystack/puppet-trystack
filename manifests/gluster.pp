class trystack::gluster () {

    firewall { '001 gluster bricks incoming':
        iniface => 'em1',
        proto    => 'tcp',
        dport    => '49152-49170',
        action   => 'accept',
    }
 
    firewall { '001 gluster incoming':
        iniface => 'em1',
        proto    => 'tcp',
        dport    => '24007-24020',
        action   => 'accept',
    }

    file { '/export': ensure => directory, }

    # puppet creates and cleans up the file every run
    # this resource stops that madness
    file { '/var/lib/puppet/tmp/gluster/vrrp': ensure => directory, }

    class { 'puppet::vardir': }
    class { 'gluster::server':
        #ips => ["10.100.0.10", "10.100.0.11", "10.100.0.12"],
        #vip => "${annex_loc_vip_1}",
        clients => ["10.100.0.*",],
        #zone => 'loc',
        #shorewall => true,
        repo => false,
    }

    ##### Host 10 ####
    gluster::host { 'host10.trystack.org':
        ip => '10.100.0.10',
        uuid => '80a19f09-f8b2-4912-a65c-0ea4768431b2',
    }

    gluster::brick { 'host10.trystack.org:/export/sdb1':
        dev        => '/dev/sdb',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host10.trystack.org:/export/sdc1':
        dev        => '/dev/sdc',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host10.trystack.org:/export/sdd1':
        dev        => '/dev/sdd',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host10.trystack.org:/export/sde1':
        dev        => '/dev/sde',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host10.trystack.org:/export/sdf1':
        dev        => '/dev/sdf',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host10.trystack.org:/export/sdg1':
        dev        => '/dev/sdg',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host10.trystack.org:/export/sdh1':
        dev        => '/dev/sdh',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host10.trystack.org:/export/sdi1':
        dev        => '/dev/sdi',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host10.trystack.org:/export/sdj1':
        dev        => '/dev/sdj',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    ##### Host 11 ####
    gluster::host { 'host11.trystack.org':
        ip => '10.100.0.11',
        uuid => '1ffc7240-36b0-482e-9c9b-8de5ea9c8e50',
    }

    gluster::brick { 'host11.trystack.org:/export/sdb1':
        dev        => '/dev/sdb',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host11.trystack.org:/export/sdc1':
        dev        => '/dev/sdc',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host11.trystack.org:/export/sdd1':
        dev        => '/dev/sdd',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host11.trystack.org:/export/sde1':
        dev        => '/dev/sde',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host11.trystack.org:/export/sdf1':
        dev        => '/dev/sdf',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host11.trystack.org:/export/sdg1':
        dev        => '/dev/sdg',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host11.trystack.org:/export/sdh1':
        dev        => '/dev/sdh',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host11.trystack.org:/export/sdi1':
        dev        => '/dev/sdi',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host11.trystack.org:/export/sdj1':
        dev        => '/dev/sdj',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    ##### Host 12 ####
    gluster::host { 'host12.trystack.org':
        ip => '10.100.0.12',
        uuid => '1b047765-c666-493e-be6e-be5dbe4689f5',
    }

    gluster::brick { 'host12.trystack.org:/export/sdb1':
        dev        => '/dev/sdb',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host12.trystack.org:/export/sdc1':
        dev        => '/dev/sdc',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host12.trystack.org:/export/sdd1':
        dev        => '/dev/sdd',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host12.trystack.org:/export/sde1':
        dev        => '/dev/sde',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host12.trystack.org:/export/sdf1':
        dev        => '/dev/sdf',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host12.trystack.org:/export/sdg1':
        dev        => '/dev/sdg',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host12.trystack.org:/export/sdh1':
        dev        => '/dev/sdh',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host12.trystack.org:/export/sdi1':
        dev        => '/dev/sdi',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host12.trystack.org:/export/sdj1':
        dev        => '/dev/sdj',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    ##### Host 13 ####
    gluster::host { 'host13.trystack.org':
        ip => '10.100.0.13',
        uuid => '604df7c2-c9e5-448a-982b-818144116e55',
    }

    gluster::brick { 'host13.trystack.org:/export/sdb1':
        dev        => '/dev/sdb',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host13.trystack.org:/export/sdc1':
        dev        => '/dev/sdc',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host13.trystack.org:/export/sdd1':
        dev        => '/dev/sdd',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host13.trystack.org:/export/sde1':
        dev        => '/dev/sde',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host13.trystack.org:/export/sdf1':
        dev        => '/dev/sdf',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host13.trystack.org:/export/sdg1':
        dev        => '/dev/sdg',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host13.trystack.org:/export/sdh1':
        dev        => '/dev/sdh',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host13.trystack.org:/export/sdi1':
        dev        => '/dev/sdi',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host13.trystack.org:/export/sdj1':
        dev        => '/dev/sdj',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    ##### Host 14 ####
    gluster::host { 'host14.trystack.org':
        ip => '10.100.0.14',
        uuid => '2cd2233e-bdd7-4d0e-9db1-25704bbeae97',
    }

    gluster::brick { 'host14.trystack.org:/export/sdb1':
        dev        => '/dev/sdb',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host14.trystack.org:/export/sdc1':
        dev        => '/dev/sdc',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host14.trystack.org:/export/sdd1':
        dev        => '/dev/sdd',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host14.trystack.org:/export/sde1':
        dev        => '/dev/sde',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host14.trystack.org:/export/sdf1':
        dev        => '/dev/sdf',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host14.trystack.org:/export/sdg1':
        dev        => '/dev/sdg',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host14.trystack.org:/export/sdh1':
        dev        => '/dev/sdh',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host14.trystack.org:/export/sdi1':
        dev        => '/dev/sdi',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host14.trystack.org:/export/sdj1':
        dev        => '/dev/sdj',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    ##### Host 15 ####
    gluster::host { 'host15.trystack.org':
        ip => '10.100.0.15',
        uuid => '5a3cdffd-ce0c-40aa-aed8-c40dd16bdeb4',
    }

    gluster::brick { 'host15.trystack.org:/export/sdb1':
        dev        => '/dev/sdb',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host15.trystack.org:/export/sdc1':
        dev        => '/dev/sdc',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host15.trystack.org:/export/sdd1':
        dev        => '/dev/sdd',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host15.trystack.org:/export/sde1':
        dev        => '/dev/sde',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host15.trystack.org:/export/sdf1':
        dev        => '/dev/sdf',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host15.trystack.org:/export/sdg1':
        dev        => '/dev/sdg',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host15.trystack.org:/export/sdh1':
        dev        => '/dev/sdh',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host15.trystack.org:/export/sdi1':
        dev        => '/dev/sdi',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    gluster::brick { 'host15.trystack.org:/export/sdj1':
        dev        => '/dev/sdj',
        lvm        => false,
        fstype     => 'ext4',
        areyousure => true,
    }   

    $trystack_brick_list = [
        'host10.trystack.org:/export/sdb1',
        'host11.trystack.org:/export/sdb1',
        'host12.trystack.org:/export/sdb1',
        'host13.trystack.org:/export/sdb1',
        'host14.trystack.org:/export/sdb1',
        'host15.trystack.org:/export/sdb1',
        'host10.trystack.org:/export/sdc1',
        'host11.trystack.org:/export/sdc1',
        'host12.trystack.org:/export/sdc1',
        'host13.trystack.org:/export/sdc1',
        'host14.trystack.org:/export/sdc1',
        'host15.trystack.org:/export/sdc1',
        'host10.trystack.org:/export/sdd1',
        'host11.trystack.org:/export/sdd1',
        'host12.trystack.org:/export/sdd1',
        'host13.trystack.org:/export/sdd1',
        'host14.trystack.org:/export/sdd1',
        'host15.trystack.org:/export/sdd1',
    ]
    
    $mysql_brick_list = [
        'host10.trystack.org:/export/sde1',
        'host11.trystack.org:/export/sde1',
        'host12.trystack.org:/export/sde1',
        'host10.trystack.org:/export/sdf1',
        'host11.trystack.org:/export/sdf1',
        'host12.trystack.org:/export/sdf1',
        'host10.trystack.org:/export/sdg1',
        'host11.trystack.org:/export/sdg1',
        'host12.trystack.org:/export/sdg1',
    ]

    $mongo_brick_list = [
        'host10.trystack.org:/export/sdh1',
        'host11.trystack.org:/export/sdh1',
        'host12.trystack.org:/export/sdh1',
        'host10.trystack.org:/export/sdi1',
        'host11.trystack.org:/export/sdi1',
        'host12.trystack.org:/export/sdi1',
        'host10.trystack.org:/export/sdj1',
        'host11.trystack.org:/export/sdj1',
        'host12.trystack.org:/export/sdj1',
    ]
    # TODO: have this run transactionally on *one* gluster host.
    gluster::volume { 'trystack':
        replica => 3,
        bricks => $trystack_brick_list,
        start => undef,	# i'll start this myself
    }
    
    gluster::volume::property { 'trystack#cluster.data-self-heal-algorithm':
        value => 'full',
    }
    
    # namevar must be: <VOLNAME>#<KEY>
    #gluster::volume::property { 'examplevol#auth.reject':
    #	value => ['192.0.2.13', '198.51.100.42', '203.0.113.69'],
    #}
    
    gluster::volume { 'mysql':
        replica => 3,
        bricks => $mysql_brick_list,
        start => undef,
    }

    gluster::volume::property { 'mysql#cluster.data-self-heal-algorithm':
        value => 'full',
    }

    gluster::volume { 'mongo':
        replica => 3,
        bricks => $mongo_brick_list,
        start => undef,
    }

    gluster::volume::property { 'mongo#cluster.data-self-heal-algorithm':
        value => 'full',
    }

}
