package Moblo::Controller::Mail;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/encode_json decode_json/;

sub render_inbox{
	my $self = shift;

	$self->render(template => "/mailbox/inbox");
}

sub delete_email{
	my $self = shift;
	my $json = $self->req->json;
	my $rs = $self->db->resultset('Message');
	while () {
		# body...
	}
	$self->render(json => {success => "true"});
}

1;