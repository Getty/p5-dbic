package # Hide from PAUSE
  DBIC::SQLAHacks::OracleJoins;

use warnings;
use strict;

use base qw( DBIC::SQLMaker::OracleJoins );

1;
