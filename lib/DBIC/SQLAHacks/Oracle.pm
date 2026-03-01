package # Hide from PAUSE
  DBIC::SQLAHacks::Oracle;
# ABSTRACT: Deprecated Oracle SQL customizations
use warnings;
use strict;

use base qw( DBIC::SQLMaker::Oracle );

1;
