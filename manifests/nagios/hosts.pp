class trystack::nagios::hosts {

    nagios_host { "_$public_fqdn": , use => 'linux-server', address => "$public_fqdn"}
    nagios_host { "$private_ip": , use => 'linux-server', address => "$private_ip"}
    nagios_host { "$mysql_ip": , use => 'linux-server', address => "$mysql_ip"}
    nagios_host { 'host01': , use => 'linux-server', address => '10.100.0.1'}
#    nagios_host { '10.100.0.2': , use => 'linux-server', address => '10.100.0.2'}
    nagios_host { 'host03': , use => 'linux-server', address => '10.100.0.3'}
    nagios_host { "$neutron_ip": , use => 'linux-server', address => "$neutron_ip"}
    nagios_host { 'host05': , use => 'linux-server', address => '10.100.0.5'}
    nagios_host { 'host06': , use => 'linux-server', address => '10.100.0.6'}
    nagios_host { 'host07': , use => 'linux-server', address => '10.100.0.7'}
    nagios_host { 'host08': , use => 'linux-server', address => '10.100.0.8'}
    nagios_host { 'host09': , use => 'linux-server', address => '10.100.0.9'}
    nagios_host { 'host10': , use => 'linux-server', address => '10.100.0.10'}
    nagios_host { 'host11': , use => 'linux-server', address => '10.100.0.11'}
    nagios_host { 'host12': , use => 'linux-server', address => '10.100.0.12'}
    nagios_host { 'host13': , use => 'linux-server', address => '10.100.0.13'}
    nagios_host { 'host14': , use => 'linux-server', address => '10.100.0.14'}
    nagios_host { 'host15': , use => 'linux-server', address => '10.100.0.15'}
#    nagios_host { host16': , use => 'linux-server', address => '10.100.0.16'}
#    nagios_host { host17': , use => 'linux-server', address => '10.100.0.17'}
    nagios_host { 'host18': , use => 'linux-server', address => '10.100.0.18'}

}
