package #hide from pause
  DBICTest::Base;

use strict;
use warnings;

# must load before any DBIC* namespaces
use DBICTest::RunMode;

sub _skip_namespace_frames { '^DBICTest' }

1;
