package # hide form PAUSE
    DBIC::CDBICompat::AbstractSearch;

use strict;
use warnings;

=head1 NAME

DBIC::CDBICompat::AbstractSearch - Emulates Class::DBI::AbstractSearch

=head1 SYNOPSIS

See DBIC::CDBICompat for usage directions.

=head1 DESCRIPTION

Emulates L<Class::DBI::AbstractSearch>.

=cut

# The keys are mostly the same.
my %cdbi2dbix = (
    limit               => 'rows',
);

sub search_where {
    my $class = shift;
    my $where = (ref $_[0]) ? $_[0] : { @_ };
    my $attr  = (ref $_[0]) ? $_[1] : {};

    # Translate the keys
    $attr->{$cdbi2dbix{$_}} = delete $attr->{$_} for keys %cdbi2dbix;

    return $class->resultset_instance->search($where, $attr);
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
