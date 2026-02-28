package # Hide from PAUSE
  DBIC::SQLAHacks::MySQL;

use warnings;
use strict;

use base qw( DBIC::SQLMaker::MySQL );

1;
