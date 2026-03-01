package # Hide from PAUSE
  DBIC::SQLAHacks::MSSQL;
# ABSTRACT: Deprecated MSSQL SQL customizations
use warnings;
use strict;

use base qw( DBIC::SQLMaker::MSSQL );

1;
