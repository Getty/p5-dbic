package # hide package from pause
  DBIC::PK::Auto::Pg;

use strict;
use warnings;

use base qw/DBIC/;

__PACKAGE__->load_components(qw/PK::Auto/);

1;

__END__

=head1 NAME

DBIC::PK::Auto::Pg - (DEPRECATED) Automatic primary key class for Pg

=head1 SYNOPSIS

Just load PK::Auto instead; auto-inc is now handled by Storage.

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=head1 COPYRIGHT AND LICENSE

This module is free software L<copyright|DBIC/COPYRIGHT AND LICENSE>
by the L<DBIC (DBIC) authors|DBIC/AUTHORS>. You can
redistribute it and/or modify it under the same terms as the
L<DBIC library|DBIC/COPYRIGHT AND LICENSE>.
