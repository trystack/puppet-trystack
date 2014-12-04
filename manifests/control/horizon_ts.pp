class trystack::control::horizon_ts() {

  if $public_fqdn == '' { fail('public_fqdn is empty') }
  if $horizon_secret_key == '' { fail('horizon_secret_key is empty') }


  include concat::setup

#$horizon_packages = ["python-memcached", "python-netaddr"]

#package {$horizon_packages:
#    notify => Class["horizon"],
#    ensure => present,
#}

  class {'horizon':
    servername => $public_fqdn,
    secret_key => $horizon_secret_key,
    keystone_host => $private_ip,
    keystone_default_role => '_member_',
    #fqdn => [$private_ip, "$::fqdn", 'localhost'],
    # TO-DO: Parameter fqdn is used both for ALLOWED_HOSTS in settings_local.py
    #        and for ServerAlias directives in vhost.conf which is breaking server
    #        accessibility. We need ALLOWED_HOSTS values, but we have to avoid
    #        ServerAlias definitions. For now we will use this wildcard hack until
    #        puppet-horizon will have separate parameter for each config.
    fqdn => '*',
    can_set_mount_point => 'False',
    django_debug => false ? {true => 'True', false => 'False'},
    listen_ssl => true,
    horizon_cert => '/etc/pki/tls/certs/x86.trystack.org.crt',
    horizon_key => '/etc/pki/tls/private/x86.trystack.org.key',
    horizon_ca => '/etc/pki/tls/certs/gd_bundle-g2-g1.crt',
    neutron_options => {
      'enable_lb' => true,
      'enable_firewall' => true
    },
  }

  apache::listen { '443': }

  # little bit of hatred as we'll have to patch upstream puppet-horizon
  file_line {'horizon_ssl_wsgi_fix':
    path    => '/etc/httpd/conf.d/15-horizon_ssl_vhost.conf',
    match   => 'WSGIProcessGroup.*',
    line    => '  WSGIProcessGroup horizon-ssl',
    require => File['15-horizon_ssl_vhost.conf'],
    notify  => Service['httpd'],
  }


  firewall { "001 horizon  incoming":
    proto    => 'tcp',
    dport    => ['443'],
    action   => 'accept',
  }

  selboolean{'httpd_can_network_connect':
    value => on,
    persistent => true,
  }

############################
    #file {"/etc/httpd/conf.d/rootredirect.conf":
    #    ensure => present,
    #    content => "RedirectMatch ^/$ https://$public_fqdn/dashboard/",
    #    notify => File["/etc/httpd/conf.d/openstack-dashboard.conf"],
    #}

    #class {'apache::mod::php': }
    ## The apache module purges files it doesn't know about
    ## avoid this be referencing them here
    #file { '/etc/httpd/conf.d/nagios.conf':}

    #class {'apache::mod::ssl': }
    #file {'/etc/httpd/conf.d/ssl.conf':}
    ##file {'/etc/httpd/conf.d/proxy.conf':}
    #file {'/etc/httpd/conf.d/ssl_redirect.conf':
    #    source => 'puppet:///modules/trystack/ssl_redirect.conf',
    #}
}
