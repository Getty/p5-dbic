use warnings;
use strict;

use Test::More;

use lib qw(t/lib);
use DBICTest; # do not remove even though it is not used (pulls in MRO::Compat if needed)

{
  package AAA;

  use base "DBIC::Core";
}

{
  package BBB;

  use base 'AAA';

  #Injecting a direct parent.
  __PACKAGE__->inject_base( __PACKAGE__, 'AAA' );
}

{
  package CCC;

  use base 'AAA';

  #Injecting an indirect parent.
  __PACKAGE__->inject_base( __PACKAGE__, 'DBIC::Core' );
}

eval { mro::get_linear_isa('BBB'); };
ok (! $@, "Correctly skipped injecting a direct parent of class BBB");

eval { mro::get_linear_isa('CCC'); };
ok (! $@, "Correctly skipped injecting an indirect parent of class BBB");

use DBIC::Storage::DBI::Sybase::Microsoft_SQL_Server;

is_deeply (
  mro::get_linear_isa('DBIC::Storage::DBI::Sybase::Microsoft_SQL_Server'),
  [qw/
    DBIC::Storage::DBI::Sybase::Microsoft_SQL_Server
    DBIC::Storage::DBI::Sybase
    DBIC::Storage::DBI::MSSQL
    DBIC::Storage::DBI::UniqueIdentifier
    DBIC::Storage::DBI::IdentityInsert
    DBIC::Storage::DBI
    DBIC::Storage::DBIHacks
    DBIC::Storage
    DBIC
    DBIC::Componentised
    Class::C3::Componentised
    DBIC::AccessorGroup
    Class::Accessor::Grouped
  /],
  'Correctly ordered ISA of DBIC::Storage::DBI::Sybase::Microsoft_SQL_Server'
);

my $storage = DBIC::Storage::DBI::Sybase::Microsoft_SQL_Server->new;
$storage->connect_info(['dbi:SQLite::memory:']); # determine_driver's init() connects for this subclass
$storage->_determine_driver;
is (
  $storage->can('sql_limit_dialect'),
  'DBIC::Storage::DBI::MSSQL'->can('sql_limit_dialect'),
  'Correct method picked'
);

if ($] >= 5.010) {
  ok (! $INC{'Class/C3.pm'}, 'No Class::C3 loaded on perl 5.10+');

  # Class::C3::Componentised loads MRO::Compat unconditionally to satisfy
  # the assumption that once Class::C3::X is loaded, so is Class::C3
  #ok (! $INC{'MRO/Compat.pm'}, 'No MRO::Compat loaded on perl 5.10+');
}

done_testing;
