package DBIC::Storage::DBI::ODBC::Firebird;

use strict;
use warnings;
use base qw/
  DBIC::Storage::DBI::ODBC
  DBIC::Storage::DBI::Firebird::Common
/;
use mro 'c3';
use Try::Tiny;
use namespace::clean;

=head1 NAME

DBIC::Storage::DBI::ODBC::Firebird - Driver for using the Firebird RDBMS
through ODBC

=head1 DESCRIPTION

Most functionality is provided by
L<DBIC::Storage::DBI::Firebird::Common>, see that driver for details.

To build the ODBC driver for Firebird on Linux for unixODBC, see:

L<http://www.firebirdnews.org/?p=1324>

This driver does not suffer from the nested statement handles across commits
issue that the L<DBD::InterBase|DBIC::Storage::DBI::InterBase> or the
L<DBD::Firebird|DBIC::Storage::DBI::Firebird> based driver does. This
makes it more suitable for long running processes such as under L<Catalyst>.

=cut

# batch operations in DBD::ODBC 1.35 do not work with the official ODBC driver
sub _run_connection_actions {
  my $self = shift;

  if ($self->_dbh_get_info('SQL_DRIVER_NAME') eq 'OdbcFb') {
    $self->_disable_odbc_array_ops;
  }

  return $self->next::method(@_);
}

# releasing savepoints doesn't work for some reason, but that shouldn't matter
sub _exec_svp_release { 1 }

sub _exec_svp_rollback {
  my ($self, $name) = @_;

  try {
    $self->_dbh->do("ROLLBACK TO SAVEPOINT $name")
  }
  catch {
    # Firebird ODBC driver bug, ignore
    if (not /Unable to fetch information about the error/) {
      $self->throw_exception($_);
    }
  };
}

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=head1 COPYRIGHT AND LICENSE

This module is free software L<copyright|DBIC/COPYRIGHT AND LICENSE>
by the L<DBIC (DBIC) authors|DBIC/AUTHORS>. You can
redistribute it and/or modify it under the same terms as the
L<DBIC library|DBIC/COPYRIGHT AND LICENSE>.


=cut

# vim:sts=2 sw=2:

1;
