class component::rabbitmq {
  anchor { 'component::rabbitmq::begin': } ->
    class { '::rabbitmq': } ->
  anchor { 'component::rabbitmq::end': }
}
