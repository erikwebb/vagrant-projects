class base {
  stage { 'pre': before => Stage['main'] }

  # Ensure this class is run first so that EPEL is available  
  class { 'base::install': stage => 'pre' }
}