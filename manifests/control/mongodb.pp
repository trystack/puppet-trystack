class trystack::control::mongodb {

  if $private_ip == '' { fail('private_ip is empty') }

  class { 'mongodb::server':
      smallfiles   => true,
      bind_ip      => ["$private_ip"],
  }

  packstack::firewall {'mongodb':
    host => "$private_ip",
    service_name => 'mongodb-server',
    chain => 'INPUT',
    ports => '27017',
    proto => 'tcp',
  }
}
