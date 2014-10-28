class trystack::compute::nova_libvirt() inherits trystack::compute::nova_base {

    # Ensure Firewall changes happen before libvirt service start
    # preventing a clash with rules being set by libvirt
    Firewall <| |> -> Class['nova::compute::libvirt']
    
    nova_config{
       # "DEFAULT/libvirt_inject_partition": value => "-1";
        "libvirt/inject_partition": value => "-1";
    }
    
    package { 'qemu-kvm':
        ensure => "installed",
        require => Class['nova::compute::libvirt']
    }
    
    class { 'nova::compute::libvirt':
      libvirt_type       => "kvm",
      #vncserver_listen   => "$::ipaddress_em1",
      vncserver_listen   => "0.0.0.0",
      migration_support  => true,
    }
    
    #exec {'load_kvm':
    #    user => 'root',
    #    command => '/bin/sh /etc/sysconfig/modules/kvm.modules',
    #    unless => '/usr/bin/test -e /etc/sysconfig/modules/kvm.modules',
    #}
    
    #Class['nova::compute']-> Exec["load_kvm"]
    
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
