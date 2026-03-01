package # hide from PAUSE
    DBIC::ClassResolver::PassThrough;
# ABSTRACT: Simple class resolver that passes through names unchanged
use strict;
use warnings;

sub class {
  shift;
  return shift;
}

1;
