package Moblo::Schema::Result::User;
use base qw/DBIx::Class::Core/;



#has_many realationship (that is zero or more records in the foriegn tabel post)
#has_one relationship Posts -> User(one autor per post)
#belongs_to relationship Comments -> Posts Comments -> Users each comment has a foreign key to one user and post
#relation ships are added for each table to the bottom of each associated result class

#Associated table in database
__PACKAGE__->table('users');

#Column definition
__PACKAGE__->add_columns(

	id => {
		data_type => 'integer',
		is_auto_increment => 1,
	},

	pw_hash => {
		data_type => 'text',
	},

	username => {
		data_type => 'text',
	},

	firstname => {
		data_type => 'text',
	},

	lastname => {
		data_type => 'text',
	},

	city => {
		data_type => 'text',
	},

	zipcode => {
		data_type => 'integer',
	},

	email => {
		data_type => 'text',
	},

	company => {
		data_type => 'text',
	},

	user_level => {
		data_type => 'text',
	},
);


#We want 'username' to be unique 
#this adds an SQL unique constraint
__PACKAGE__->add_unique_constraint(
	[qw/username/],
);

#Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');


__PACKAGE__->has_many(
	#Name of the accessor for this relation
	posts =>
	#Foreign result class
	'Moblo::Schema::Result::Post',
	#Foreign key in the table 'posts'
	'author_id'
);

__PACKAGE__->has_many(
	comments =>
	'Moblo::Schema::Result::Comment',
	'user_id'
);

__PACKAGE__->belongs_to(
	'name',
	"Moblo::Schema::Result::Company",
	{name => 'company'}
);

1;