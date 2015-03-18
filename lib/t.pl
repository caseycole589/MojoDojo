
#this script deploys sqlite database set up in schema 
#thanks to people on perl monks for helping me solve this problem
#if your looking at this as an example make sure the script is in the right directory

use lib '.';
use Moblo::Schema;

my $schema = Moblo::Schema->connect('dbi:SQLite:moblo.db');
$schema->deploy();
