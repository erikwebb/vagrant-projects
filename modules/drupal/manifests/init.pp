class drupal {
  stage { 'application': require => Stage['main'] }

  # Ensure this class is run last so that all pacakges are available  
  class { 'drupal::install': stage => 'application' }
}