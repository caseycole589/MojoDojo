package Moblo::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';

sub user_exists {
	#username and password equals parameters passed
	my($self,$username,$password) = @_;

	# Determin if a user with 'username' exists
	#search is equivalnt to query
	my $user = $self->db->resultset('User')
		->search({ username => $username})->first;

	#validate password against hash, return user object
	if (defined $user && $self->bcrypt_validate($password,$user->pw_hash)){
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

		#redirect to admin screen
		$self->redirect_to('/admin');
	}

	else{
		#if something was wrong tell the user
		$self->render(text => '<b>Wrong username/password</b>
			<br/><a href="create_account">Create new account</a>',status =>403);
	}

}

sub is_logged_in {

	my $self = shift;

	return 1 if $self->session('logged_in');
	
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

	if ($username eq ""){
		$self->flash(error => "Username");
		$self->redirect_to('/create_account');
	}
	elsif($password eq ""){
		$self->flash(error => "Missing Field password");
		$self->redirect_to('/create_account');
	}
	elsif($firstname eq ""){
		$self->flash(error => "Missing field first name");
		$self->redirect_to('/create_account');
	}
	elsif($lastname eq ""){
		$self->flash(error => "Missing field last name");
		$self->redirect_to('/create_account');
	}
	else{
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
			});
			$self->flash(create_user_success => "Success");
			$self->redirect_to('/login');
		}
	}
}

1;