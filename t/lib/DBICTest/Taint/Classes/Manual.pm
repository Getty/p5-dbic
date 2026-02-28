package # hide from PAUSE
    DBICTest::Taint::Classes::Manual;

use warnings;
use strict;

use base 'DBIC::Core';
__PACKAGE__->table('test');

1;
