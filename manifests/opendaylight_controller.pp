class trystack::opendaylight_controller {
     if $odl_rest_port == '' { $odl_rest_port= '8081'}
     class {"opendaylight":
       extra_features => ['odl-base-all', 'odl-aaa-authn', 'odl-restconf', 'odl-nsf-all', 'odl-adsal-northbound', 'odl-mdsal-apidocs', 'odl-ovsdb-openstack', 'odl-ovsdb-northbound', 'odl-dlux-core'],
       odl_rest_port  => $odl_rest_port,
     }
}
