package Moblo::Controller::Bill;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/encode_json decode_json/;
use DateTime;
use Math::Round;
use Mojo::Log;

sub render_bill_history {
	my $self = shift;
	$self->render(template => "customer/bill_history");
}
sub render_pay_bills{
	my $self = shift;


	$self->render(template => "customer/pay_bill");
}

sub render_tips_and_tricks{
	my $self = shift;

	$self->render(template => "customer/tips_and_tricks");
}
sub render_future_bills{
	my $self = shift;


	$self->render(template => "customer/future_bill");
}

sub get_map_data {
	my $self = shift;
	my $data = qq({"labels":["January","February","March","April","May","June","July","August","September","November","December",""],"datasets":[{"label": "My First dataset","fillColor":"rgba(220,220,220,0.2)","strokeColor":"rgba(220,220,220,1)","pointColor": "rgba(220,220,220,1)","pointStrokeColor":"#fff","pointHighlightFill":"#fff","pointHighlightStroke":"rgba(220,220,220,1)","data": [);
	my $log= Mojo::Log->new;

	my $bill_rs = $self->db->resultset('Bill');
	my $bills_data = $bill_rs->search({company_name => $self->session('company'),customer_name => $self->session('user_id')});
	#loop through all the bills and add them to the string
	while(my $bills = $bills_data->next){
		$data .= $bills->amount . ',';

	}
	$data .= '0]}]}';

	$self->render(json => {data => $data});

}
sub pay_bill{
	my $self = shift;
	my $log = Mojo::Log->new;
	# 

	my $json = $self->req->json;
	my $lengther = $json->{lengther};
	my $bills = $json->{selected_bills};
	my $bill_rs = $self->db->resultset('Bill');
	foreach my $x (0.. $lengther) {
		my $bill = $bill_rs->search({
			id=> $bills->[$x]->{id},
		});

		$bill->update({ is_payed => 1 });
	}

	$self->render(json=> {success => 'true'});
}
sub insert_a_years_worth_of_bills{
	my $self = shift;

	#create json object 
	my $json = $self->req->json;
	
	#create a log
	my $log = Mojo::Log->new;

	#store how many customers we got 
	my $lengther = $json->{lengther};

	#$log->info($json->{lengther});
	#create result set
	
	my $bill_rs = $self->db->resultset("Bill");
	#create hash year consisting of day and houw much charged
	my %year = bill_per_day_last_year();
	my $customers = $json->{selected_customers};
	
	
	for my $current_customer (0..$lengther){
		$log->info($customers->[$current_customer]->{user_id});
		
		#iterate through all the keys 
		while( my( $key, $value ) = each  %year ){
			#customer name === id
	    	$bill_rs->create({
	    		customer_name => $customers->[$current_customer]->{user_id},
	    		company_name => $self->session('company'),
	    		date_published => $key,
	    		amount => $value,
	    		is_payed => 1,

	    	});
		}#end while 
	}#end for
	$self->render(json => {billed => 'true'});
}

sub Bill_Once {
	my $self = shift;

	#create a log
	my $log = Mojo::Log->new;
	# $log->info("were in bill once");
	#create json object 
	my $json = $self->req->json;

	my $lengther = $json->{lengther};
	my $customers = $json->{selected_customers};
	my $amount = $json->{amount};
	my $date = DateTime->now->iso8601;
	my $company = $self->session('company');
	my $payed = 0;
	#$log->info($json->{lengther});

	
	my $bill_rs = $self->db->resultset("Bill");
	for my $current_customer (0..$lengther){
		$bill_rs->create({
    		customer_name => $customers->[$current_customer]->{user_id},
    		company_name => $self->session('company'),
    		date_published => $date,
    		amount => $amount,
    		is_payed => $payed,

	    });
	}


	$self->render(json => {billed => 'true'});
}
#fills a hash with days and charges
sub bill_per_day_last_year{
	my %b;
	#january
	for(1..2){
		my $dt = DateTime->new(
			year => 2014,
			month => 1,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}	
	#febuary
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 2,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}	
	#march
	for(1..1){
		my $dt = DateTime->new(
			year => 2014,
			month => 3,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}
	#april
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 4,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}
	#may
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 5,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}
	#june
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 6,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}	
	#july
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 7,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}
	#august			
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 8,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}	
	#september
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 9,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b->{$dt} = $amount;
	}	
	#october
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 10,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}	
	#november
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 11,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
	}	
	#december
	for(1..3){
		my $dt = DateTime->new(
			year => 2014,
			month => 12,
			day => $_,
			hour => 0,
			minute => 0,
			second => 0,
		);
		my $amount = nearest(0.01, rand(20));
		$b{$dt} = $amount;
		# print $b->{$dt};
	}	
	# foreach my $x (keys $b) {
	# 	print "he";
	# }
	return %b;
}

1;