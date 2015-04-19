package Moblo::Controller::Customer;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/encode_json decode_json/;



sub render_profile {
	my $self = shift;

	$self->render(template => "customer/profile");
}

1;