package Moblo::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';

sub user_exists {
	#username and password equals parameters passed
	my($username,$password) = @_;

	return ($username eq 'foo' && $password eq 'bar');
}

#called upon form submit

sub on_user_login {
	my $self = shift;
	
	#grab request parameters
	my $username = $self->param('username');
	my $password = $self->param('password');
	
	
	if(user_exists($username,$password)) {

		$self->session(logged_in => 1);
		$self->session(username => $username);

		$self->redirect_to('/admin');
	}

	else {
		#render the text wrong username/password in bold
		$self->render(text => '<b>Wrong username/password</b>',status => 403);
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

1;