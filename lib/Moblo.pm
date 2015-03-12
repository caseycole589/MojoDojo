package Moblo;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  $self->defaults(layout => 'base');

  # Router
  my $r = $self->routes;

  #template is directly renderd in route definition
  $r->get('/')->to(template => 'main/index');

  # but can be used to manaully render data with a controller like this
  # $r->get('/')->to('main#index');
  # or 
  # $r->route('/')->via('GET')->to(controller => 'Main', action => 'index')




  #example came with
  # Normal route to controller
  #$r->get('/')->to('example#welcome');
  # could also be written as
  #$r->route('/')->via('GET')->to(controller => 'Example', action => 'welcome'); 

}

1;
