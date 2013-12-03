class trystack::compute() {
  class { "trystack::compute::nova_ts": }
  class { "trystack::compute::neutron_ts": }
}
