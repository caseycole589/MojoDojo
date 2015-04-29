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
  $self->app->sessions->default_expiration('1000000');

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
  my $authorized = $r->under('/admin')->to('Login#is_logged_in_admin');
  $authorized->get('/')->name('restricted_area')->to(template => 'admin/admin_overview');
  $authorized->post('/render_customers')->to('Admin#render_customers');
  $authorized->post('/render_message')->to('Admin#render_message');
  $authorized->post('/send_message')->to('Admin#send_message');
  $authorized->post('/insert_a_years_worth_of_bills')->to('Bill#insert_a_years_worth_of_bills');
  $authorized->post('/Bill_Once')->to('Bill#Bill_Once');


  my $customer = $r->under('/customer')->to('Login#is_logged_in_customer');
  $customer->get('/')->to(template => 'customer/customer_overview');
  # $customer->post('/')->to('Customer');
  $customer->post('/profile')->to('Customer#render_profile');
  $customer->post('/profile_update')->to('Customer#profile_update');
  $customer->post('/render_bill_history')->to('Bill#render_bill_history');
  $customer->post('/render_inbox')->to('Mail#render_inbox');
  $customer->post('/delete_email')->to('Mail#delete_email');
  $customer->post('/render_pay_bills')->to('Bill#render_pay_bills');
  $customer->post('/pay_bill')->to('Bill#pay_bill');
  $customer->post('/render_future_bills')->to('Bill#render_future_bills');
  $customer->post('/get_map_data')->to('Bill#get_map_data');
  $customer->post('/render_tips_and_tricks')->to('Bill#render_tips_and_tricks');

  my $schema = Moblo::Schema->connect('dbi:SQLite:share/moblo-schema.db', '', '', {sqlite_unicode => 1,  on_connect_do => 'PRAGMA foreign_keys = ON',});
  
  $self->helper(db => sub{return $schema;});

}

1;
