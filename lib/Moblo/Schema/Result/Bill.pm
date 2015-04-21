package Moblo::Schema::Result::Bill;
use base qw/DBIx::Class::Core/;
use DateTime;

#Load ColumnDefault for DateTime
__PACKAGE__->load_components(qw/ColumnDefault Core/);
#Automatically load DateTime columns int DateTime objects
__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->load_components(qw/InflateColumn::Boolean Core/);
__PACKAGE__->false_is(['false','','0']);
__PACKAGE__->true_is(['true','1']);
# __PACKAGE__->load_components(qw/InflateColumn::Currency/);
__PACKAGE__->table('bills');

#Column definition
__PACKAGE__->add_columns(

	id => {
		data_type => 'integer',
		is_auto_increment => 1,
	},

	customer_name => {
		data_type => 'text',
	},

	company_name => {
		data_type => 'text',
	},

	date_published => {
        data_type => 'datetime',
        default_value => \"(datetime('now'))",
    },

    amount => {
		data_type => 'decimal',
	    size => [9,2],
        is_nullable => 0,
        default_valuev=> '0.00',
  #       is_currency => 1,
    },

    is_payed => {
    	data_type => 'int',
    	is_boolean => 1,
    },
);


#Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
	billed =>
	'Moblo::Schema::Result::User',
	#foriegnt key in this class
	'customer_name'
);
__PACKAGE__->belongs_to(
	biller =>
	'Moblo::Schema::Result::Company',
	#forien key in this class
	'company_name'
);


1;