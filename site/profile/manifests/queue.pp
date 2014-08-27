class profile::queue (
  $rabbitmq = false,
) {
  validate_bool($rabbitmq)

  anchor { 'profile::queue::begin': } ->
  anchor { 'profile::queue::end': }

  if $rabbitmq {
    Anchor['profile::queue::begin'] ->
    class { 'component::rabbitmq': } ->
    Anchor['profile::queue::end']
  }
}
