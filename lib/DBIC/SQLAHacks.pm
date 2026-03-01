package # Hide from PAUSE
  DBIC::SQLAHacks;
# ABSTRACT: Deprecated SQL customization layer
use warnings;
use strict;

use base qw/DBIC::SQLMaker/;

1;
