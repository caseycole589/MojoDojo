package Moblo::Schema::Result::Post;
use base qw/DBIx::Class::Core/;

#has_many realationship (that is zero or more records in the foriegn tabel post)
#has_one relationship Posts -> User(one autor per post)
#belongs_to relationship Comments -> Posts Comments -> Users each comment has a foreign key to one user and post
#relation ships are added for each table to the bottom of each associated result class

# Associated table in database
__PACKAGE__->table('posts');

# Column definition
__PACKAGE__->add_columns(

    id => {
        data_type => 'integer',
        is_auto_increment => 1,
    },

    author_id => {
        data_type => 'text',
    },

    title => {
        data_type => 'text',
    },

    content => {
        data_type => 'text',
    },

    date_published => {
        data_type => 'datetime',
    },

);

# Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(  
  #Name of the accessor for this relation
  author =>
  #Foreign result class 
  'Moblo::Schema::Result::User',
  #Foreign key in THIS table 
  'author_id'
);

__PACKAGE__->has_many(
  #comments is the accesssor in this relation
  #ex. comments has a forieng key of post id
  comments =>
  'Moblo::Schema::Result::Comment',
  'post_id'
);
1;