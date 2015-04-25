use utf8;
package Moblo::Schema;

use strict;
use warnings;
# based on the DBIx::Class Schema base class
use base 'DBIx::Class::Schema';

#schema database version
our $VERSION = 11;

# This will load any classes within
# Moblo::Schema::Result and Moblo::Schema::ResultSet (if any)

__PACKAGE__->load_namespaces();

# 
1;