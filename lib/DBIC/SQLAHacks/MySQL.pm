package # Hide from PAUSE
  DBIC::SQLAHacks::MySQL;
# ABSTRACT: Deprecated MySQL SQL customizations
use warnings;
use strict;

use base qw( DBIC::SQLMaker::MySQL );

1;
