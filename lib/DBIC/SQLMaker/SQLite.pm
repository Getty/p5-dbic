package # Hide from PAUSE
  DBIC::SQLMaker::SQLite;
# ABSTRACT: SQLite-specific SQL generation
use warnings;
use strict;

use base qw( DBIC::SQLMaker );

#
# SQLite does not understand SELECT ... FOR UPDATE
# Disable it here
sub _lock_select () { '' };

1;
