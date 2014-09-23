class trystack::compute::nova_docker() inherits trystack::compute::nova_base {

    nova_config{
        "DEFAULT/compute_driver": value => "novadocker.virt.docker.DockerDriver";
    }
    
    
}
