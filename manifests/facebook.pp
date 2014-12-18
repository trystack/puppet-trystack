class trystack::facebook() {

    if $facebook_app_id == '' { fail('facebook_app_id is empty') }
    if $facebook_app_secret == '' { fail('facebook_app_secret is empty') }
    if $member_user_role == '' { fail('member_user_role is empty') }
    if $trystack_db_password == '' { fail('trystack_db_password is empty') }
    if $keystone_admin_token == '' { fail('keystone_admin_token is empty') }

    package {'python-django-horizon-facebook': }

    file_line{'enable_apipassword':
        path  => '/usr/share/openstack-dashboard/openstack_dashboard/dashboards/settings/dashboard.py',
        match => "    panels = .*",
        line  => "    panels = ('user', 'apipassword', )",
    }

    file { "/usr/share/keystone/keystone-dist-paste.ini":
        ensure => present,
        source => "puppet:///modules/trystack/keystone-dist-paste.ini",
        group  => "keystone",
    }

    file {'/usr/lib/python2.7/site-packages/horizon/templates/splash.html':
#        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/lib/python2.6/site-packages/horizon/templates/splash.html',
    }
    file {'/usr/lib/python2.7/site-packages/horizon/templates/auth/login.html':
#        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/lib/python2.6/site-packages/horizon/templates/auth/login.html',
    }
    file {'/usr/lib/python2.7/site-packages/horizon/templates/auth/_login.html':
#        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/lib/python2.6/site-packages/horizon/templates/auth/_login.html',
    }
    file {'/usr/share/openstack-dashboard/openstack_dashboard/settings.py':
#        require => Package['openstack-dashboard'],
        content => template('trystack/settings.py.erb'),
    }
    file {'/usr/share/openstack-dashboard/openstack_dashboard/urls.py':
#        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/share/openstack-dashboard/openstack_dashboard/urls.py',
    }
}
