package # Hide from PAUSE
  DBIC::SQLAHacks::SQLite;

use warnings;
use strict;

use base qw( DBIC::SQLMaker::SQLite );

1;
