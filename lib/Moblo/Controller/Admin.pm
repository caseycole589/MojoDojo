package Moblo::Controller::Admin;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/encode_json decode_json/;

sub get_customers {
	my $self = shift;
	my $customers = $self->db->resultset('User');
	my $awn = $customers->search({company => $self->session('company')});
	while (my $awn = $awn->next) {
		say $awn->firstname;
	}
	$self->render(json =>{object => "$awn"});
}
sub render_customers {
	my $self = shift;
	$self->render(template => "admin/customers");
}

sub render_message{
	my $self = shift;
	$self->render(template => "admin/message");
}
1;