class component::redis($instances = {}) {
  validate_hash($instances)

  contain '::redis'
  create_resources('::redis::instance', $instances)
}
