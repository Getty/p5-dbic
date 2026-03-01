package # Hide from PAUSE
  DBIC::SQLAHacks::OracleJoins;
# ABSTRACT: Deprecated Oracle join syntax customizations
use warnings;
use strict;

use base qw( DBIC::SQLMaker::OracleJoins );

1;
