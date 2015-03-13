package Moblo::Controller::Main;
use Mojo::Base 'Mojolicious::Controller';

	#actions go here
sub index {
	
	my $self = shift;
	#this action forces the rendering of templates/main/index
	$self->render('main/index');	
}
