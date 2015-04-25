package Moblo::Schema::Result::Message;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('messages');

#Column definition
__PACKAGE__->add_columns(

	id => {
		data_type => 'integer',
		is_auto_increment => 1,
	},

	user_id => {
		data_type => 'integer',
	},

	firstname => {
		data_type => 'text',
	},

	lastname => {
		data_type => 'text',
	},

	email => {
		data_type => 'text',
	},

	company_name => {
		data_type => 'text',
	},

	date_sent => {
        data_type => 'datetime',
    },

    template => {
    	data_type => 'text',
    },
);


#We want 'username' to be unique 
#this adds an SQL unique constraint


#Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');

1;