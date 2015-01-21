class trystack {
    stage { 'first':
      before => Stage['main'],
    }

    class { "trystack::repo":
      stage => first,
    }
}
