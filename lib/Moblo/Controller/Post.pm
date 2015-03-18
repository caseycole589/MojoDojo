package Moblo::Controller::Post;
use Mojo::Base 'Mojolicious::Controller';
use DateTime;

sub create {
	my $self = shift;

	#get the post parameters
	 # Grab the request parameters
    my $title = $self->param('title');
    my $content = $self->param('content');

   
    # Persist the post
    $self->db->resultset('Post')->create({
            title => $title,
            content => $content,

            # Use the username as author name for now
            author => $self->session('username'),

            # Published now
            date_published => DateTime->now->iso8601,

        });
	#flash sends messages to next request through session cookie
	$self->flash(post_saved => 1);
	$self->redirect_to('restricted_area');

}

1;