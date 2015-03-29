package Moblo;
use Mojo::Base 'Mojolicious';
use Moblo::Schema;

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
 
  my $schema = Moblo::Schema->connect('dbi:SQLite:moblo.db','','',{sqlite_unicode => 1});
  $self->helper(db => sub{return $schema;});

  $authorized->get('/create')->name('create_post')->to(template => 'admin/create_post');
  $authorized->post('/create')->name('publish_post')->to('Post#create');
  #on get display a template asking to confirm deletion.
  $authorized->get('/delete/:id',[id=>qr/\d+/])->name('delete_post')->to(template => 'admin/delete_post_confirm');
  #on POST, delete the post 
  $authorized->post('/delete/:id',[id => qr/\d+/])->name('delete_post_confirmed')->to('Post#dlete'); 
}

1;
