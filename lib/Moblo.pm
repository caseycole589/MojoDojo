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

  #Plugins

  #Bcrypt with cost factor 8
  $self->plugin('bcrypt',{cost => 8});

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

  #route to template for creating a new user
  $r->get('/create_account')->to(template => 'login/create_form');
  $r->post('/create_account')->name('create_new_account')->to('Login#create_new_account');

  $r->get('/create_company_form')->to(template => 'login/create_company_form');
  $r->post('/create_company_form/create_company')->to('Login#create_new_company');
  $r->post('/create_company_form/create_admin')->to('Login#create_admin');
 

  $r->route('/logout')->to(cb => sub {
  	my $self = shift;

  	#expire the session (deleted upon next request)
  	$self->session(expires => 1);

  	#go back home
  	$self->redirect_to('/');
  	

  });

  #this behaves like router object we can use it to define restricted routes
  my $authorized = $r->under('/admin')->to('Login#is_logged_in');
  $authorized->get('/')->name('restricted_area')->to(template => 'admin/admin_overview');
  
  my $customer = $r->under('/customer')->to('Login#is_logged_in_customer');
  $customer->get('/')->to(template => 'customer/customer_overview');
  # $customer->post('/')->to('Customer');
  $customer->post('/profile')->to('Customer#render_profile');

  my $schema = Moblo::Schema->connect('dbi:SQLite:share/moblo-schema.db', '', '', {sqlite_unicode => 1,  on_connect_do => 'PRAGMA foreign_keys = ON',});
  
  $self->helper(db => sub{return $schema;});

  $authorized->get('/create')->name('create_post')->to(template => 'admin/create_post');
  $authorized->post('/create')->name('publish_post')->to('Post#create');
  #on get display a template asking to confirm deletion.
  $authorized->get('/delete/:id',[id=>qr/\d+/])->name('delete_post')->to(template => 'admin/delete_post_confirm');
  #on POST, delete the post 
  $authorized->post('/delete/:id',[id => qr/\d+/])->name('delete_post_confirmed')->to('Post#delete'); 
}

1;
