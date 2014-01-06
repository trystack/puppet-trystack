class trystack::nagios::hosts {

    nagios_host { "$public_fqdn": , use => 'linux-server', address => "$public_fqdn"}
    nagios_host { "$private_ip": , use => 'linux-server', address => "$private_ip"}
    nagios_host { '10.100.0.1': , use => 'linux-server', address => '10.100.0.1'}
#    nagios_host { '10.100.0.2': , use => 'linux-server', address => '10.100.0.2'}
    nagios_host { '10.100.0.3': , use => 'linux-server', address => '10.100.0.3'}
    nagios_host { '10.100.0.4': , use => 'linux-server', address => '10.100.0.4'}
    nagios_host { '10.100.0.5': , use => 'linux-server', address => '10.100.0.5'}
    nagios_host { '10.100.0.6': , use => 'linux-server', address => '10.100.0.6'}
    nagios_host { '10.100.0.7': , use => 'linux-server', address => '10.100.0.7'}
    nagios_host { '10.100.0.8': , use => 'linux-server', address => '10.100.0.8'}
    nagios_host { '10.100.0.9': , use => 'linux-server', address => '10.100.0.9'}
    nagios_host { '10.100.0.10': , use => 'linux-server', address => '10.100.0.10'}
    nagios_host { '10.100.0.11': , use => 'linux-server', address => '10.100.0.11'}
    nagios_host { '10.100.0.12': , use => 'linux-server', address => '10.100.0.12'}
    nagios_host { '10.100.0.13': , use => 'linux-server', address => '10.100.0.13'}
    nagios_host { '10.100.0.14': , use => 'linux-server', address => '10.100.0.14'}
    nagios_host { '10.100.0.15': , use => 'linux-server', address => '10.100.0.15'}
    nagios_host { '10.100.0.16': , use => 'linux-server', address => '10.100.0.16'}

}
