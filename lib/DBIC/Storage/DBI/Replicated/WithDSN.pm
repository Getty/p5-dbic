package DBIC::Storage::DBI::Replicated::WithDSN;
# ABSTRACT: A DBI Storage Role with DSN information in trace output

use Moose::Role;
use Scalar::Util 'reftype';
requires qw/_query_start/;

use Try::Tiny;
use namespace::clean -except => 'meta';

=head1 SYNOPSIS

This class is used internally by L<DBIC::Storage::DBI::Replicated>.

=head1 DESCRIPTION

This role adds C<DSN: > info to storage debugging output.

=head1 METHODS

This class defines the following methods.

=head2 around: _query_start

Add C<DSN: > to debugging output.

=cut

around '_query_start' => sub {
  my ($method, $self, $sql, @bind) = @_;

  my $dsn = (try { $self->dsn }) || $self->_dbi_connect_info->[0];

  my($op, $rest) = (($sql=~m/^(\w+)(.+)$/),'NOP', 'NO SQL');
  my $storage_type = $self->can('active') ? 'REPLICANT' : 'MASTER';

  my $query = do {
    if ((reftype($dsn)||'') ne 'CODE') {
      "$op [DSN_$storage_type=$dsn]$rest";
    }
    elsif (my $id = try { $self->id }) {
      "$op [$storage_type=$id]$rest";
    }
    else {
      "$op [$storage_type]$rest";
    }
  };

  $self->$method($query, @bind);
};

=head1 ALSO SEE

L<DBIC::Storage::DBI>

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=cut

1;
