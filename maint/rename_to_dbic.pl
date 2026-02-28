#!/usr/bin/env perl
#
# rename_to_dbic.pl - Rename DBIx::Class namespace
#
# Usage:
#   perl maint/rename_to_dbic.pl                    # Dry run → DBIC
#   perl maint/rename_to_dbic.pl --apply             # Actually rename to DBIC
#   perl maint/rename_to_dbic.pl --to=Deebee         # Dry run → Deebee
#   perl maint/rename_to_dbic.pl --apply --to=Deebee # Actually rename to Deebee
#   perl maint/rename_to_dbic.pl --apply --phase=move    # Only move files
#   perl maint/rename_to_dbic.pl --apply --phase=content # Only content changes
#   perl maint/rename_to_dbic.pl --apply --phase=verify  # Only verify
#
use strict;
use warnings;
use File::Find;
use File::Path qw(make_path);
use File::Basename qw(dirname);
use Getopt::Long;
use Cwd qw(getcwd);

my $DRY_RUN = 1;
my $PHASE = 'all';
my $VERBOSE = 0;
my $TARGET = 'DBIC';

GetOptions(
  'apply'   => sub { $DRY_RUN = 0 },
  'phase=s' => \$PHASE,
  'verbose' => \$VERBOSE,
  'to=s'    => \$TARGET,
) or die "Usage: $0 [--apply] [--to=Name] [--phase=move|content|verify|all] [--verbose]\n";

# Derive all name variants from the target
my $FROM_PKG   = 'DBIx::Class';          # DBIx::Class
my $TO_PKG     = $TARGET;                 # e.g. DBIC
my $FROM_DIST  = 'DBIx-Class';           # DBIx-Class
my $TO_DIST    = $TARGET;                 # e.g. DBIC
my $FROM_PATH  = 'DBIx/Class';           # DBIx/Class
my $TO_PATH    = $TARGET =~ s{::}{/}gr;  # e.g. DBIC or Dee/Bee
my $FROM_DIR   = 'DBIx/Class';           # for lib/ directory structure
my $TO_DIR     = $TO_PATH;               # target directory structure

my $ROOT = getcwd();

# Check we're in the right place - handle both before and after rename
my $source_exists = -f "$ROOT/lib/DBIx/Class.pm";
my $target_exists = -f "$ROOT/lib/${TO_PATH}.pm";

die "Run this from the distribution root.\n"
  . "Expected lib/DBIx/Class.pm (source) or lib/${TO_PATH}.pm (already moved)\n"
  unless $source_exists || $target_exists;

printf "Rename: %s → %s\n", $FROM_PKG, $TO_PKG;
printf "Mode:   %s | Phase: %s\n\n", ($DRY_RUN ? 'DRY RUN' : 'APPLYING'), $PHASE;

my $stats = {
  files_moved => 0,
  files_modified => 0,
  replacements => 0,
  errors => [],
};

# ============================================================
# PHASE 1: Move files (git mv)
# ============================================================

if ($PHASE eq 'all' or $PHASE eq 'move') {
  print "=" x 60, "\n";
  print "PHASE 1: Moving files\n";
  print "=" x 60, "\n\n";

  # 1a. Move main module: lib/DBIx/Class.pm → lib/$TO_PATH.pm
  move_file("lib/${FROM_PATH}.pm", "lib/${TO_PATH}.pm");

  # 1b. Move all modules under lib/DBIx/Class/ → lib/$TO_DIR/
  my @class_files;
  if (-d "$ROOT/lib/$FROM_DIR") {
    find(sub {
      return unless -f && /\.(pm|pod(\.proto)?)$/;
      push @class_files, $File::Find::name;
    }, "$ROOT/lib/$FROM_DIR");
  }

  for my $src (sort @class_files) {
    (my $rel = $src) =~ s{^\Q$ROOT/\E}{};
    (my $dst = $rel) =~ s{^lib/\Q$FROM_DIR\E/}{lib/$TO_DIR/};
    move_file($rel, $dst);
  }

  # 1c. Move SQL::Translator integration files
  # These live under SQL::Translator::Parser::DBIx::Class and ::Producer::DBIx::Class
  # They become SQL::Translator::Parser::$TARGET and ::Producer::$TARGET
  move_file(
    "lib/SQL/Translator/Parser/${FROM_PATH}.pm",
    "lib/SQL/Translator/Parser/${TO_PATH}.pm",
  );

  if (-d "$ROOT/lib/SQL/Translator/Producer/$FROM_DIR") {
    my @producer_files;
    find(sub {
      return unless -f && /\.(pm|pod(\.proto)?)$/;
      push @producer_files, $File::Find::name;
    }, "$ROOT/lib/SQL/Translator/Producer/$FROM_DIR");

    for my $src (sort @producer_files) {
      (my $rel = $src) =~ s{^\Q$ROOT/\E}{};
      (my $dst = $rel) =~ s{Producer/\Q$FROM_DIR\E/}{Producer/$TO_DIR/};
      move_file($rel, $dst);
    }
  }

  # 1d. Clean up empty directories left behind
  if (!$DRY_RUN) {
    for my $dir (
      "$ROOT/lib/DBIx/Class",
      "$ROOT/lib/DBIx",
      "$ROOT/lib/SQL/Translator/Parser/DBIx",
      "$ROOT/lib/SQL/Translator/Producer/DBIx",
    ) {
      cleanup_empty_dirs($dir);
    }
  }

  print "\n";
}

# ============================================================
# PHASE 2: Content replacements
# ============================================================

if ($PHASE eq 'all' or $PHASE eq 'content') {
  print "=" x 60, "\n";
  print "PHASE 2: Content replacements\n";
  print "=" x 60, "\n\n";

  # Collect all text files to process
  my @files;
  for my $dir (qw(lib t xt script examples)) {
    next unless -d "$ROOT/$dir";
    find(sub {
      return unless -f;
      return if $File::Find::name =~ m{/\.git/};
      return if $File::Find::name =~ m{/blib/};
      return if $File::Find::name =~ m{/maint/}; # don't mangle ourselves
      return unless /\.(pm|pl|pod|t|PL)$/ || $_ eq 'dbicadmin';
      push @files, $File::Find::name;
    }, "$ROOT/$dir");
  }

  # Also process select top-level files
  for my $f (qw(Makefile.PL MANIFEST.SKIP .gitignore Changes)) {
    push @files, "$ROOT/$f" if -f "$ROOT/$f";
  }

  for my $file (sort @files) {
    process_file($file);
  }

  print "\n";
}

# ============================================================
# PHASE 3: Verification
# ============================================================

if ($PHASE eq 'all' or $PHASE eq 'verify') {
  print "=" x 60, "\n";
  print "PHASE 3: Verification\n";
  print "=" x 60, "\n\n";

  if ($DRY_RUN) {
    print "  (skipped in dry-run mode)\n\n";
  } else {
    # Check for remaining old-name references
    print "Scanning for remaining $FROM_PKG references...\n";
    my @remaining;
    my @check_dirs = grep { -d "$ROOT/$_" } qw(lib t xt script);
    find(sub {
      return unless -f && /\.(pm|pl|pod|t|PL)$/;
      return if $File::Find::name =~ m{/\.git/};
      return if $File::Find::name =~ m{/maint/};
      open my $fh, '<', $_ or return;
      my $ln = 0;
      while (<$fh>) {
        $ln++;
        if (/\Q$FROM_PKG\E/ || /\Q$FROM_DIST\E/) {
          next if /rename|migration|formerly|was \Q$FROM_PKG\E/i;
          chomp;
          push @remaining, sprintf("%s:%d: %s", $File::Find::name, $ln, $_);
        }
      }
      close $fh;
    }, map { "$ROOT/$_" } @check_dirs);

    if (@remaining) {
      printf "WARNING: Found %d remaining references:\n", scalar @remaining;
      my $show = @remaining > 50 ? 50 : scalar @remaining;
      printf "  %s\n", $_ for @remaining[0..$show-1];
      printf "  ... and %d more\n", @remaining - 50 if @remaining > 50;
    } else {
      print "  Clean! No remaining $FROM_PKG references found.\n";
    }

    # Syntax check on main module
    my $main_module = "lib/${TO_PATH}.pm";
    if (-f "$ROOT/$main_module") {
      print "\nSyntax checking $main_module...\n";
      my $check = `cd \Q$ROOT\E && perl -Ilib -c $main_module 2>&1`;
      if ($? == 0) {
        print "  OK: $check";
      } else {
        print "  FAIL: $check";
        push @{$stats->{errors}}, "Syntax check failed for $main_module";
      }
    }
  }

  print "\n";
}

# ============================================================
# Summary
# ============================================================

print "=" x 60, "\n";
print "Summary\n";
print "=" x 60, "\n";
printf "  Target name:    %s\n", $TO_PKG;
printf "  Files moved:    %d\n", $stats->{files_moved};
printf "  Files modified: %d\n", $stats->{files_modified};
printf "  Replacements:   %d\n", $stats->{replacements};
if (@{$stats->{errors}}) {
  printf "  ERRORS:         %d\n", scalar @{$stats->{errors}};
  print "    - $_\n" for @{$stats->{errors}};
}
print "\n";

exit( @{$stats->{errors}} ? 1 : 0 );


# ============================================================
# Subroutines
# ============================================================

sub move_file {
  my ($src, $dst) = @_;
  my $abs_src = "$ROOT/$src";
  my $abs_dst = "$ROOT/$dst";

  unless (-f $abs_src) {
    print "  SKIP (not found): $src\n" if $VERBOSE;
    return;
  }

  if (-f $abs_dst) {
    print "  SKIP (target exists): $dst\n" if $VERBOSE;
    return;
  }

  print "  MOVE: $src → $dst\n";
  $stats->{files_moved}++;

  return if $DRY_RUN;

  my $dst_dir = dirname($abs_dst);
  make_path($dst_dir) unless -d $dst_dir;

  system('git', 'mv', $abs_src, $abs_dst) == 0
    or do {
      push @{$stats->{errors}}, "git mv failed: $src → $dst";
      warn "  ERROR: git mv failed for $src → $dst\n";
    };
}

sub cleanup_empty_dirs {
  my ($dir) = @_;
  return unless -d $dir;

  # Bottom-up removal of empty directories
  finddepth(sub {
    return unless -d;
    rmdir $File::Find::name; # silently fails if not empty
  }, $dir);
  rmdir $dir;
}

sub process_file {
  my ($file) = @_;

  open my $fh, '<', $file or do {
    push @{$stats->{errors}}, "Cannot read: $file: $!";
    return;
  };
  my $content = do { local $/; <$fh> };
  close $fh;

  my $original = $content;
  my $count = 0;

  # Replacement rules — order matters!
  # More specific patterns first to avoid partial matches.

  # 1. Distribution name (hyphenated): DBIx-Class → $TO_DIST
  $count += ($content =~ s/\b\Q$FROM_DIST\E\b/$TO_DIST/g);

  # 2. Qualified package name with trailing ::  (DBIx::Class::Foo → DBIC::Foo)
  #    Must come before the standalone check
  $count += ($content =~ s/\b\Q$FROM_PKG\E::/${TO_PKG}::/g);

  # 3. Standalone package name (DBIx::Class → DBIC)
  $count += ($content =~ s/\b\Q$FROM_PKG\E\b/$TO_PKG/g);

  # 4. File path format: DBIx/Class/Foo.pm → $TO_PATH/Foo.pm
  $count += ($content =~ s{\Q$FROM_PATH\E/}{$TO_PATH/}g);
  $count += ($content =~ s{\Q$FROM_PATH\E\.pm\b}{$TO_PATH.pm}g);
  # Standalone path (e.g. in URLs): DBIx/Class → $TO_PATH
  $count += ($content =~ s{\Q$FROM_PATH\E\b}{$TO_PATH}g);

  if ($content ne $original) {
    (my $relpath = $file) =~ s{^\Q$ROOT/\E}{};
    printf "  MODIFY (%3d replacements): %s\n", $count, $relpath;
    $stats->{files_modified}++;
    $stats->{replacements} += $count;

    unless ($DRY_RUN) {
      open my $out, '>', $file or do {
        push @{$stats->{errors}}, "Cannot write: $file: $!";
        return;
      };
      print $out $content;
      close $out;
    }
  }
}
