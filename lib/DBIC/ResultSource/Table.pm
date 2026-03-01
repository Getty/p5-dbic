package DBIC::ResultSource::Table;
# ABSTRACT: Table object

use strict;
use warnings;

use DBIC::ResultSet;

use base qw/DBIC/;
__PACKAGE__->load_components(qw/ResultSource/);

=head1 SYNOPSIS

=head1 DESCRIPTION

Table object that inherits from L<DBIC::ResultSource>.

=head1 METHODS

=head2 from

Returns the FROM entry for the table (i.e. the table name)

=cut

sub from { shift->name; }

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=cut

1;
