package Moblo::Controller::Bill;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/encode_json decode_json/;
use DateTime;


sub render_bill_history {
	my $self = shift;
	$self->render(template => "customer/bill_history");
}

sub insert_a_years_worth_of_bills{
	my $bill_rs = db->resultset("Bill");
}
1;