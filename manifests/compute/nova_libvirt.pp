class trystack::compute::nova_libvirt() inherits trystack::compute::nova_base {

    # Ensure Firewall changes happen before libvirt service start
    # preventing a clash with rules being set by libvirt
    Firewall <| |> -> Class['nova::compute::libvirt']
    
    if $::is_virtual_packstack == "true" {
        $libvirt_type = "qemu"
        nova_config{
            "DEFAULT/libvirt_cpu_mode": value => "none";
        }
    }else{
        $libvirt_type = "kvm"
    }
    
    nova_config{
        "DEFAULT/libvirt_inject_partition": value => "-1";
    }
    
    package { 'qemu-kvm':
        ensure => "installed",
        require => Class['nova::compute::libvirt']
    }
    
    class { 'nova::compute::libvirt':
      libvirt_type                => "$libvirt_type",
      vncserver_listen            => "$::ipaddress_em1",
    }
    
    exec {'load_kvm':
        user => 'root',
        command => '/bin/sh /etc/sysconfig/modules/kvm.modules',
        unless => '/usr/bin/test -e /etc/sysconfig/modules/kvm.modules',
    }
    
    Class['nova::compute']-> Exec["load_kvm"]
    
    # Note : remove this once we're installing a version of openstack that isn't
    #        supported on RHEL 6.3
    if $::is_virtual_packstack == "true" and $::osfamily == "RedHat" and
        $::operatingsystemrelease == "6.3"{
        file { "/usr/bin/qemu-system-x86_64":
            ensure => link,
            target => "/usr/libexec/qemu-kvm",
            notify => Service["nova-compute"],
        }
    }
    
    # Tune the host with a virtual hosts profile
    package {'tuned':
        ensure => present,
    }
    
    service {'tuned':
        ensure => running,
        require => Package['tuned'],
    }
    
    exec {'tuned-virtual-host':
        unless => '/usr/sbin/tuned-adm active | /bin/grep virtual-host',
        command => '/usr/sbin/tuned-adm profile virtual-host',
        require => Service['tuned'],
    }
    
    file_line { 'libvirt-guests':
        path  => '/etc/sysconfig/libvirt-guests',
        line  => 'ON_BOOT=ignore',
        match => '^[\s#]*ON_BOOT=.*',
        require => Class['nova::compute::libvirt']
    }
    
    # Remove libvirt's default network (usually virbr0) as it's unnecessary and can be confusing
    exec {'virsh-net-destroy-default':
        onlyif  => '/usr/bin/virsh net-list | grep default',
        command => '/usr/bin/virsh net-destroy default',
        require => Package['libvirt'],
    }
    
    exec {'virsh-net-undefine-default':
        onlyif  => '/usr/bin/virsh net-list --inactive | grep default',
        command => '/usr/bin/virsh net-undefine default',
        require => Exec['virsh-net-destroy-default'],
    }
    
}