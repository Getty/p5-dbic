package # hide from PAUSE
    DBIC::CDBICompat::Copy;

use strict;
use warnings;

use Carp;

=head1 NAME

DBIC::CDBICompat::Copy - Emulates Class::DBI->copy($new_id)

=head1 SYNOPSIS

See DBIC::CDBICompat for usage directions.

=head1 DESCRIPTION

Emulates C<<Class::DBI->copy($new_id)>>.

=cut


# CDBI's copy will take an id in addition to a hash ref.
sub copy {
    my($self, $arg) = @_;
    return $self->next::method($arg) if ref $arg;

    my @primary_columns = $self->primary_columns;
    croak("Need hash-ref to edit copied column values")
        if @primary_columns > 1;

    return $self->next::method({ $primary_columns[0] => $arg });
}

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=head1 COPYRIGHT AND LICENSE

This module is free software L<copyright|DBIC/COPYRIGHT AND LICENSE>
by the L<DBIC (DBIC) authors|DBIC/AUTHORS>. You can
redistribute it and/or modify it under the same terms as the
L<DBIC library|DBIC/COPYRIGHT AND LICENSE>.

=cut

1;
