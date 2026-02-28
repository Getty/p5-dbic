package DBIC::CDBICompat::Iterator;

use strict;
use warnings;


=head1 NAME

DBIC::CDBICompat::Iterator - Emulates the extra behaviors of the Class::DBI search iterator.

=head1 SYNOPSIS

See DBIC::CDBICompat for usage directions.

=head1 DESCRIPTION

Emulates the extra behaviors of the Class::DBI search iterator.

=head2 Differences from DBIC result set

The CDBI iterator returns true if there were any results, false otherwise.  The DBIC result set always returns true.

=cut


sub _init_result_source_instance {
  my $class = shift;

  my $table = $class->next::method(@_);
  $table->resultset_class("DBIC::CDBICompat::Iterator::ResultSet");

  return $table;
}

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=head1 COPYRIGHT AND LICENSE

This module is free software L<copyright|DBIC/COPYRIGHT AND LICENSE>
by the L<DBIC (DBIC) authors|DBIC/AUTHORS>. You can
redistribute it and/or modify it under the same terms as the
L<DBIC library|DBIC/COPYRIGHT AND LICENSE>.

=cut

package # hide
  DBIC::CDBICompat::Iterator::ResultSet;

use strict;
use warnings;

use base qw(DBIC::ResultSet);

sub _bool {
    # Performance hack so internal checks whether the result set
    # exists won't do a SQL COUNT.
    return 1 if caller =~ /^DBIC::/;

    return $_[0]->count;
}

sub _construct_results {
  my $self = shift;

  my $rows = $self->next::method(@_);

  if (my $f = $self->_resolved_attrs->{record_filter}) {
    $_ = $f->($_) for @$rows;
  }

  return $rows;
}

1;
