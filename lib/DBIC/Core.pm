package DBIC::Core;

use strict;
use warnings;

use base qw/DBIC/;

__PACKAGE__->load_components(qw/
  Relationship
  InflateColumn
  PK
  Row
  ResultSourceProxy::Table
/);

1;

__END__

=head1 NAME

DBIC::Core - Core set of DBIC modules

=head1 SYNOPSIS

  # In your result (table) classes
  use base 'DBIC::Core';

=head1 DESCRIPTION

This class just inherits from the various modules that make up the
L<DBIC> core features.  You almost certainly want these.

The core modules currently are:

=over 4

=item L<DBIC::InflateColumn>

=item L<DBIC::Relationship> (See also L<DBIC::Relationship::Base>)

=item L<DBIC::PK>

=item L<DBIC::Row>

=item L<DBIC::ResultSourceProxy::Table> (See also L<DBIC::ResultSource>)

=back

A better overview of the methods found in a Result class can be found
in L<DBIC::Manual::ResultClass>.

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=head1 COPYRIGHT AND LICENSE

This module is free software L<copyright|DBIC/COPYRIGHT AND LICENSE>
by the L<DBIC (DBIC) authors|DBIC/AUTHORS>. You can
redistribute it and/or modify it under the same terms as the
L<DBIC library|DBIC/COPYRIGHT AND LICENSE>.
