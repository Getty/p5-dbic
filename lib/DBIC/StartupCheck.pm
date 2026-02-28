package DBIC::StartupCheck;

use strict;
use warnings;

1;

__END__

=head1 NAME

DBIC::StartupCheck - Run environment checks on startup

=head1 SYNOPSIS

  use DBIC::StartupCheck;

=head1 DESCRIPTION

This module used to check for, and if necessary issue a warning for, a
particular bug found on Red Hat and Fedora systems using their system
perl build. As of September 2008 there are fixed versions of perl for
all current Red Hat and Fedora distributions, but the old check still
triggers, incorrectly flagging those versions of perl to be buggy. A
more comprehensive check has been moved into the test suite in
C<t/99rh_perl_perf_bug.t> and further information about the bug has been
put in L<DBIC::Manual::Troubleshooting>.

Other checks may be added from time to time.

Any checks herein can be disabled by setting an appropriate environment
variable. If your system suffers from a particular bug, you will get a
warning message on startup sent to STDERR, explaining what to do about
it and how to suppress the message. If you don't see any messages, you
have nothing to worry about.

=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.

=head1 COPYRIGHT AND LICENSE

This module is free software L<copyright|DBIC/COPYRIGHT AND LICENSE>
by the L<DBIC (DBIC) authors|DBIC/AUTHORS>. You can
redistribute it and/or modify it under the same terms as the
L<DBIC library|DBIC/COPYRIGHT AND LICENSE>.
