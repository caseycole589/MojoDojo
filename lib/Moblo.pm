package Moblo;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
 
  my $self = shift;

  #Allows to set the signing key as an  array
  #where the first key will be used for all new sessions
  #and the other keys are still used for validation but not new sessins.
  $self->secrets(['secretKey_usefornewsessionsOIsFDneSriocEJWEF',
	'thisKeyuseforvalidationsoiJSc83md']);

  #the cookie name
  $self->app->sessions->cookie_name('moblo');

  #Expiration reduced to 10000 seconds
  $self->app->sessions->default_expiration('10000');


  $self->defaults(layout => 'base');

  # Router
  my $r = $self->routes;

  #template is directly renderd in route definition
  # GET / -> Main::index()
  $r->get('/')->to(template => 'main/index');

  # but can be used to manaully render data with a controller like this
  # $r->get('/')->to('main#index');
  # or 
  # $r->route('/')->via('GET')->to(controller => 'Main', action => 'index')

 
  # if replace link_to login in 
  $r->get('/login')->to(template => 'login/login_form');
  #the name is the name of the form that is posting can be shortend if only one form
  # $r->post('/login')->to('Login#on_user_login');
  $r->post('/login')->to('Login#on_user_login');

  $r->route('/logout')->to(cb => sub {
  	my $self = shift;

  	#expire the session (deleted upon next request)
  	$self->session(expires => 1);

  	#go back home
  	$self->redirect_to('/');
  	

  });

  #this behaves like router object we can use it to define restricted routes
  my $authorized = $r->under('/admin')->to('Login#is_logged_in');
  $authorized->get('/')->name('restricted_area')->to(template => 'admin/overview');


}

1;
