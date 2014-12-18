class trystack {
    file {'/etc/hosts':
      content=> 'file:///modules/trystack/etc.hosts',
    }
}
