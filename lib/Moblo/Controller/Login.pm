package Moblo::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/encode_json decode_json/;

sub user_exists {
	#username and password equals parameters passed
	my($self,$username,$password) = @_;

	# Determin if a user with 'username' exists
	#search is equivalnt to query
	my $user = $self->db->resultset('User')
		->search({ username => $username})->first;

	#validate password against hash, return user object
	if (defined $user ){
		return $user;
	}

}

#called upon form submit

sub on_user_login {
	my $self = shift;
	
	#grab request parameters
	my $username = $self->param('username');
	my $password = $self->param('password');
	
	if(my $user = $self->user_exists($username, $password)){

		#set session variables
		$self->session(logged_in => 1);
		$self->session(username => $username);
		$self->session(user_id => $user->id);
		$self->session(company => $user->company);
		$self->session(user_level => $user->user_level);
		$self->session(zipcode => $user->zipcode);
		$self->session(city => $user->city);
		$self->session(email => $user->email);
		$self->session(firstname => $user->firstname);
		$self->session(lastname => $user->lastname);
		#redirect to admin screen
		if($user->user_level eq 'admin'){
			$self->redirect_to('/admin');
		}
		#redirect to customer screen
		else{
			$self->redirect_to('/customer');
		}
	}

	else{
		#if something was wrong tell the user
		$self->render(text => '<b>Wrong username/password</b>
			<br/><a href="create_account">Create new account</a> or
			 <br/><a href="create_company_form"> Create a Company</a>',status =>403);
	}

}

sub is_logged_in_admin {

	my $self = shift;

	return 1 if $self->session('logged_in') && $self->session('user_level') eq 'admin';
	
	$self->render(
		text =>'<h1> Your no longer logged in </h1>',
		status => 403
	);
}
sub is_logged_in_customer {
	my $self = shift;
	return 1 if $self->session('logged_in') && $self->session('user_level') eq 'customer';

	$self->render(
		text =>'<h1> Your no longer logged in </h1>',
		status => 403
	);
}

sub create_new_account{
	my $self = shift;


	my $username = $self->param('username');
	my $password = $self->param('password');
	my $firstname = $self->param('firstname');
	my $lastname = $self->param('lastname');
	my $zipcode = $self->param('zipcode');
	my $city = $self->param('city');
	my $email = $self->param('email');
	my $company = $self->param('company');
	my $user_level = 'customer';



	
	#get the result set
	my $users =$self->db->resultset('User');
	my $count = $users->search({ username => $username })->count;
	
	#if usern"ame is not unique
	if($count == 1){
		$self->flash(error => "User Name is already taken");
		$self->redirect_to('/create_account');
	}
	else{
		#create new record in the database
		my $created = $users->create({
			username => $username,
			pw_hash => $self->bcrypt($password),
			firstname => $firstname,
			lastname => $lastname,
			email => $email,
			zipcode => int($zipcode),
			city => $city,
			user_level => 'customer',
			company => $company
		});
		$self->flash(create_user_success => "Success");
		$self->redirect_to('/');
	}
	
}
#creates a new company
sub create_new_company {
	
	my $self = shift;

	my $json = $self->req->json;
	#if in array acces like this
	# print $json->[0]->{company};
	#use like this if {"key:value"}
	#if($json->{company} eq 'what'){
	#	$self->render(json => {tool => "one"});
	#}
	#else{
	#		$self->render(json => {tool => "two"});
	#}
	my $users_company = $json->{company};
	my $companys = $self->db->resultset('Company');
	my $counts = $companys->search({name => $users_company});
	my $total = $companys->count;
	if($counts == 0){
		$companys->create({
			id => $total + 1,
			name => "$users_company"
		});
		$self->render(json => {name => $users_company});
	}
	else{
		$self->render(json => {name => "invalid",count => $total});
	}
	
}

sub create_admin {
	my $self = shift;
	my $json = $self->req->json;
	my $users = $self->db->resultset('User');
	
	my $users_company = $json->{Company};
	my $users_username = $json->{Username};
	my $users_password = $json->{Password};
	my $users_firstname = $json->{Firstname};
	my $users_lastname = $json->{Lastname};
	my $users_email = $json->{email};
	my $users_city = $json->{city};
	my $users_zipcode = $json->{zipcode};
   	my $count = $users->search({ username => $users_username })->count;
	#if usern"ame is not unique
	if($count >= 1){
		 $self->render(json => {success => "false"});
    }
    else{
	    $users->create({
		    company => $users_company,
		    username => $users_username,
		    pw_hash => $self->bcrypt($users_password),
		    firstname => $users_firstname,
		    lastname => $users_lastname,
		    email => $users_email,
		    city => $users_city,
		    zipcode => int($users_zipcode),
		    user_level => 'admin',
	    });
	
        $self->render(json => {success => "true"});
        
    }

    
}

# sub company_selection {
# 	my $self = shift;
# 	#get all company names
# 	my @all_companys = $self->db->resultset('Company')->search(undef,{
# 		columns =>['name'],
# 	});
# 	$self->render(json => {comapany => @all_companys});
# }

1;
