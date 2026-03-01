use warnings;
use strict;

use Test::More;
use File::Find;

# PodWeaver now generates =head1 COPYRIGHT AND LICENSE,
# so we only check for the FURTHER QUESTIONS? boilerplate in source
my $further_questions = q{
=head1 FURTHER QUESTIONS?

Check the list of L<additional DBIC resources|DBIC/GETTING HELP/SUPPORT>.
};

find({
  wanted => sub {
    my $fn = $_;

    return unless -f $fn;
    return unless $fn =~ / \. (?: pm | pod ) $ /ix;

    my $data = do { local (@ARGV, $/) = $fn; <> };

    if ($data !~ /^=head1/m) {
      # No POD at all — skip
    }
    elsif ($fn =~ qr{\Qlib/DBIC/Optional/Dependencies.pm}) {
      # the generator is full of false positives, .pod is where it's at
    }
    elsif ($fn =~ qr{\Qlib/DBIC.}) {
      # nothing to check there - a static set of words
    }
    else {
      ok ( $data !~ / ^ =head1 \s $_ /xmi, "No standalone $_ headings in $fn" )
        for qw(AUTHOR CONTRIBUTOR LICENSE LICENCE);

      ok ( $data !~ / ^ =head1 \s COPYRIGHT /xmi, "No COPYRIGHT headings in source $fn (PodWeaver generates this)" );

      ok ($data =~ / \Q$further_questions\E /xms, "Expected FURTHER QUESTIONS? section found in $fn")
        if $data =~ /^=head1 \s+ (?:DESCRIPTION|SYNOPSIS)/xm;
    }
  },
  no_chdir => 1,
}, (qw(lib examples)) );

done_testing;
