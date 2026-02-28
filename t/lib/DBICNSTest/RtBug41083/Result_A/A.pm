package DBICNSTest::RtBug41083::Result_A::A;
use strict;
use warnings;
use base 'DBIC::Core';
__PACKAGE__->table('a');
__PACKAGE__->add_columns('a');
1;
