package DBICNSTest::Result::A;

use warnings;
use strict;

use base qw/DBIC::Core/;
__PACKAGE__->table('a');
__PACKAGE__->add_columns('a');
1;
