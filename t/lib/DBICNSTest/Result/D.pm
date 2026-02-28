package DBICNSTest::Result::D;

use warnings;
use strict;

use base qw/DBIC::Core/;
__PACKAGE__->table('d');
__PACKAGE__->add_columns('d');
1;
