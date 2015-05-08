package Moblo::Controller::Customer;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/encode_json decode_json/;



sub render_profile {
	my $self = shift;

	$self->render(template => "customer/profile");
}

sub profile_update{
	my $self = shift;
	my $json = $self->req->json;

	my $firstname = $json->{firstname};
	my $lastname = $json->{lastname};
	my $email = $json->{email};
	my $city = $json->{city};
	my $zipcode = $json->{zipcode};

	#get the result set

	my $users = $self->db->resultset('User');
	my $user = $users->find({
	 	username => $self->session('username')
	});
	if($firstname ne ""){
		$user->firstname($firstname);
	}

	if($lastname ne ""){
		$user->lastname($lastname);
	}

	if ($email ne "") {
		$user->email($email);
	}

	if ($city ne "") {
		$user->city($city);
	}
	if ($zipcode ne "") {
		$user->zipcode(int($zipcode));
	}
	$user->update;
	$self->render(json => {success => "true"});
}

1;