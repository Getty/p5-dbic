package DBIC::Storage::DBI::Replicated::Balancer::First;
# ABSTRACT: Just get the First Balancer

use Moose;
with 'DBIC::Storage::DBI::Replicated::Balancer';
use namespace::clean -except => 'meta';

=head1 SYNOPSIS

This class is used internally by L<DBIC::Storage::DBI::Replicated>.  You
shouldn't need to create instances of this class.

=head1 DESCRIPTION

Given a pool (L<DBIC::Storage::DBI::Replicated::Pool>) of replicated
database's (L<DBIC::Storage::DBI::Replicated::Replicant>), defines a
method by which query load can be spread out across each replicant in the pool.

This Balancer just gets whichever is the first replicant in the pool.

=head1 ATTRIBUTES

This class defines the following attributes.

=head1 METHODS

This class defines the following methods.

=head2 next_storage

Just get the first storage.  Probably only good when you have one replicant.

=cut

sub next_storage {
  return  (shift->pool->active_replicants)[0];
}

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=cut

__PACKAGE__->meta->make_immutable;

1;
