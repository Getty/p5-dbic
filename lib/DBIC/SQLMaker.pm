package DBIC::SQLMaker;
# ABSTRACT: An SQL::Abstract-based SQL maker class

use strict;
use warnings;

use base qw(
  DBIC::SQLMaker::ClassicExtensions
  SQL::Abstract
);

# NOTE THE LACK OF mro SPECIFICATION
# This is deliberate to ensure things will continue to work
# with ( usually ) untagged custom darkpan subclasses

1;

__END__

=head1 DESCRIPTION

This module serves as a mere "nexus class" providing
L<SQL::Abstract>-based SQL generation functionality to L<DBIC> itself, and
to a number of database-engine-specific subclasses. This indirection is
explicitly maintained in order to allow swapping out the core of SQL
generation within DBIC on per-C<$schema> basis without major architectural
changes. It is guaranteed by design and tests that this fast-switching
will continue being maintained indefinitely.

=head2 Implementation switching

See L<DBIC::Storage::DBI/connect_call_rebase_sqlmaker>

The L<SQLMaker rebase|DBIC::Storage::DBI/connect_call_rebase_sqlmaker>
functionality allows plugging in alternative SQL generation backends,
including L<SQL::Abstract::Classic> for backwards compatibility.

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

