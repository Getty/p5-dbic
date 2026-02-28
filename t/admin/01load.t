use strict;
use warnings;

use Test::More;

use lib 't/lib';
use DBICTest;

BEGIN {
    require DBIC;
    plan skip_all => 'Test needs ' . DBIC::Optional::Dependencies->req_missing_for('admin')
      unless DBIC::Optional::Dependencies->req_ok_for('admin');
}

use_ok 'DBIC::Admin';


done_testing;
