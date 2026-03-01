package # Hide from PAUSE
  DBIC::SQLAHacks::SQLite;
# ABSTRACT: Deprecated SQLite SQL customizations
use warnings;
use strict;

use base qw( DBIC::SQLMaker::SQLite );

1;
