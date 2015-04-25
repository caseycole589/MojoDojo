package Moblo::Controller::Mail;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/encode_json decode_json/;



#in the emails because I was lazy last name stored the state of the email
#firstname I don't remember but its in the admin overview
sub render_inbox{
	my $self = shift;

	$self->render(template => "/mailbox/inbox");
}

sub delete_email{
	my $self = shift;
	my $json = $self->req->json;

	#search from minified result set
	my $rs = $self->db->resultset('Message')->search({
		company_name => $self->session('company'),
		user_id => $self->session('user_id'),
		lastname => "unread"
	});

	#get emails pass from json
	my $emails = $json->{selected_emails};
	my $len = $json->{lengther};

	#loop through and delete each email
	foreach my $x (0..$len) {
		my $deletion = $rs->find($emails->[$x]->{id});
		$deletion->delete;
	}
	$self->render(json => {success => "true"});
}

1;