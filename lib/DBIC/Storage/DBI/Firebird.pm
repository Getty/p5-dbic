package DBIC::Storage::DBI::Firebird;
# ABSTRACT: Driver for the Firebird RDBMS via L<DBD::Firebird>

use strict;
use warnings;

# Because DBD::Firebird is more or less a copy of
# DBD::Interbase, inherit all the workarounds contained
# in ::Storage::DBI::InterBase as opposed to inheriting
# directly from ::Storage::DBI::Firebird::Common
use base qw/DBIC::Storage::DBI::InterBase/;
use mro 'c3';

1;

=head1 DESCRIPTION

This is an empty subclass of L<DBIC::Storage::DBI::InterBase> for use
with L<DBD::Firebird>, see that driver for details.

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

