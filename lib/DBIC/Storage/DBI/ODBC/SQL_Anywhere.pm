package DBIC::Storage::DBI::ODBC::SQL_Anywhere;

use strict;
use warnings;
use base qw/
  DBIC::Storage::DBI::ODBC
  DBIC::Storage::DBI::SQLAnywhere
/;
use mro 'c3';

1;

=head1 NAME

DBIC::Storage::DBI::ODBC::SQL_Anywhere - Driver for using Sybase SQL
Anywhere through ODBC

=head1 SYNOPSIS

All functionality is provided by L<DBIC::Storage::DBI::SQLAnywhere>, see
that module for details.

=head1 CAVEATS

=head2 uniqueidentifierstr data type

If you use the C<uniqueidentifierstr> type with this driver, your queries may
fail with:

  Data truncated (SQL-01004)

B<WORKAROUND:> use the C<uniqueidentifier> type instead, it is more efficient
anyway.

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=head1 COPYRIGHT AND LICENSE

This module is free software L<copyright|DBIC/COPYRIGHT AND LICENSE>
by the L<DBIC (DBIC) authors|DBIC/AUTHORS>. You can
redistribute it and/or modify it under the same terms as the
L<DBIC library|DBIC/COPYRIGHT AND LICENSE>.

