package Moblo::Schema::Result::Company;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('companys');

__PACKAGE__->add_columns(
	
	id => {
		data_type => 'integer',
		is_auto_increment => 1,
	},

	name => {
		data_type => 'text',
	},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint(
	[qw/name/],
);
