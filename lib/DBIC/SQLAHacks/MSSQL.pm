package # Hide from PAUSE
  DBIC::SQLAHacks::MSSQL;

use warnings;
use strict;

use base qw( DBIC::SQLMaker::MSSQL );

1;
