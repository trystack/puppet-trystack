class trystack::control::qpid () {

    # pacemaker will manage this service
    # so we disable puppet's managment of it
    class {"qpid::server":
        auth => "no",
        #manage_service => false,
    }
    
    firewall { '001 qpid incoming':
        proto    => 'tcp',
        dport    => ['5672'],
        action   => 'accept',
    }

}
