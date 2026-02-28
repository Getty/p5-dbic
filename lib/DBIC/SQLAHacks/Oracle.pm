package # Hide from PAUSE
  DBIC::SQLAHacks::Oracle;

use warnings;
use strict;

use base qw( DBIC::SQLMaker::Oracle );

1;
