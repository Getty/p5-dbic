package     # hide from PAUSE
    DBIC::Admin::Descriptive;
# ABSTRACT: Getopt::Long::Descriptive integration for DBIC admin
use warnings;
use strict;

use base 'Getopt::Long::Descriptive';

require DBIC::Admin::Usage;
sub usage_class { 'DBIC::Admin::Usage'; }

1;
