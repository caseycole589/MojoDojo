package Moblo::Controller::Admin;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/encode_json decode_json/;
use DateTime;
#format DateTime->now->iso8601,

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

sub send_message {
	my $self = shift;		
	my $json = $self->req->json;

	# print $json->{selected_customers}->[1]->{firstname};
	my $customs = $json->{selected_customers};
	my $number_of_customs = $json->{length} - 1;
	my $words = "";

	if($json->{chosen_template} eq 'tips'){
		$words = "Dear _____ \nwe would like take a minute of your time to tell you an about these 
		security/energy saving tips\n tip:_____ \n tip:_______ \n tip:______"; 
	}
	elsif($json->{chosen_template} eq 'legislative'){
		$words = "We thought you might like to know about our recent \nlegislative activites that will 
			soon affect your billing...";
	}
	else{
		$words = "Dear ____ \n
			After reviewing you last payment we sould like to take a moment to tell you about how 
			\nyou could save a lot of money by being prepared for hurricanes and other related disasters 
			\n......
			\n......
			\n......";
	}
	# #loop through adding customer messages to database
	for my $n (0..$number_of_customs){
		#firstname is changed to subject 
		#lastname changed read or not
		$self->db->resultset('Message')->create({
        	user_id => int($customs->[$n]->{user_id}),

        	firstname => $json->{chosen_template},

        	lastname => "unread",

        	email => $self->session('email'),

        	company_name => $self->session('company'),

            template => $words,

            date_sent => DateTime->now->iso8601,

        });
	}

	# print $number_of_customs;
	# print $customs->[0]->{email};
	$self->render(json =>{hell => 'true'});
	return 1;
}
1;