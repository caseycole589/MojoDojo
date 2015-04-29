use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.01',
  PREREQ_PM => {'Mojolicious' => '6.08','SQL::Translator' => '0.11021','DBIx::Class::Migration' => '0.057','Mojolicious::Plugin::Bcrypt' => '0.14','Math::Round' => '0.07'},
  test      => {TESTS => 't/*.t'}
);
