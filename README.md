# NAME

DBIC - Extensible and flexible object <-> relational mapper.

# VERSION

version 0.082842

# SYNOPSIS

For the very impatient: [DBIC::Manual::QuickStart](https://metacpan.org/pod/DBIC%3A%3AManual%3A%3AQuickStart)

This code in the next step can be generated automatically from an existing
database, see [dbicdump](https://metacpan.org/pod/dbicdump) from the distribution `DBIC-Schema-Loader`.

## Schema classes preparation

Create a schema class called `MyApp/Schema.pm`:

    package MyApp::Schema;
    use base qw/DBIC::Schema/;

    __PACKAGE__->load_namespaces();

    1;

Create a result class to represent artists, who have many CDs, in
`MyApp/Schema/Result/Artist.pm`:

See [DBIC::ResultSource](https://metacpan.org/pod/DBIC%3A%3AResultSource) for docs on defining result classes.

    package MyApp::Schema::Result::Artist;
    use base qw/DBIC::Core/;

    __PACKAGE__->table('artist');
    __PACKAGE__->add_columns(qw/ artistid name /);
    __PACKAGE__->set_primary_key('artistid');
    __PACKAGE__->has_many(cds => 'MyApp::Schema::Result::CD', 'artistid');

    1;

A result class to represent a CD, which belongs to an artist, in
`MyApp/Schema/Result/CD.pm`:

    package MyApp::Schema::Result::CD;
    use base qw/DBIC::Core/;

    __PACKAGE__->load_components(qw/InflateColumn::DateTime/);
    __PACKAGE__->table('cd');
    __PACKAGE__->add_columns(qw/ cdid artistid title year /);
    __PACKAGE__->set_primary_key('cdid');
    __PACKAGE__->belongs_to(artist => 'MyApp::Schema::Result::Artist', 'artistid');

    1;

## API usage

Then you can use these classes in your application's code:

    # Connect to your database.
    use MyApp::Schema;
    my $schema = MyApp::Schema->connect($dbi_dsn, $user, $pass, \%dbi_params);

    # Query for all artists and put them in an array,
    # or retrieve them as a result set object.
    # $schema->resultset returns a DBIC::ResultSet
    my @all_artists = $schema->resultset('Artist')->all;
    my $all_artists_rs = $schema->resultset('Artist');

    # Output all artists names
    # $artist here is a DBIC::Row, which has accessors
    # for all its columns. Rows are also subclasses of your Result class.
    foreach $artist (@all_artists) {
      print $artist->name, "\n";
    }

    # Create a result set to search for artists.
    # This does not query the DB.
    my $johns_rs = $schema->resultset('Artist')->search(
      # Build your WHERE using an SQL::Abstract-compatible structure:
      { name => { like => 'John%' } }
    );

    # Execute a joined query to get the cds.
    my @all_john_cds = $johns_rs->search_related('cds')->all;

    # Fetch the next available row.
    my $first_john = $johns_rs->next;

    # Specify ORDER BY on the query.
    my $first_john_cds_by_title_rs = $first_john->cds(
      undef,
      { order_by => 'title' }
    );

    # Create a result set that will fetch the artist data
    # at the same time as it fetches CDs, using only one query.
    my $millennium_cds_rs = $schema->resultset('CD')->search(
      { year => 2000 },
      { prefetch => 'artist' }
    );

    my $cd = $millennium_cds_rs->next; # SELECT ... FROM cds JOIN artists ...
    my $cd_artist_name = $cd->artist->name; # Already has the data so no 2nd query

    # new() makes a Result object but doesn't insert it into the DB.
    # create() is the same as new() then insert().
    my $new_cd = $schema->resultset('CD')->new({ title => 'Spoon' });
    $new_cd->artist($cd->artist);
    $new_cd->insert; # Auto-increment primary key filled in after INSERT
    $new_cd->title('Fork');

    $schema->txn_do(sub { $new_cd->update }); # Runs the update in a transaction

    # change the year of all the millennium CDs at once
    $millennium_cds_rs->update({ year => 2002 });

# DESCRIPTION

This is an SQL to OO mapper with an object API inspired by [Class::DBI](https://metacpan.org/pod/Class%3A%3ADBI)
(with a compatibility layer as a springboard for porting) and a resultset API
that allows abstract encapsulation of database operations. It aims to make
representing queries in your code as perl-ish as possible while still
providing access to as many of the capabilities of the database as possible,
including retrieving related records from multiple tables in a single query,
`JOIN`, `LEFT JOIN`, `COUNT`, `DISTINCT`, `GROUP BY`, `ORDER BY` and
`HAVING` support.

DBIC can handle multi-column primary and foreign keys, complex
queries and database-level paging, and does its best to only query the
database in order to return something you've directly asked for. If a
resultset is used as an iterator it only fetches rows off the statement
handle as requested in order to minimise memory usage. It has auto-increment
support for SQLite, MySQL, PostgreSQL, Oracle, SQL Server and DB2 and is
known to be used in production on at least the first four, and is fork-
and thread-safe out of the box (although
[your DBD may not be](https://metacpan.org/pod/DBI#Threads-and-Thread-Safety)).

This project is still under rapid development, so large new features may be
marked **experimental** - such APIs are still usable but may have edge bugs.
Failing test cases are _always_ welcome and point releases are put out rapidly
as bugs are found and fixed.

We do our best to maintain full backwards compatibility for published
APIs, since DBIC is used in production in many organisations,
and even backwards incompatible changes to non-published APIs will be fixed
if they're reported and doing so doesn't cost the codebase anything.

The test suite is quite substantial, and several developer releases
are generally made to CPAN before the branch for the next release is
merged back to trunk for a major release.

# WHERE TO START READING

See [DBIC::Manual::DocMap](https://metacpan.org/pod/DBIC%3A%3AManual%3A%3ADocMap) for an overview of the exhaustive documentation.
To get the most out of DBIC with the least confusion it is strongly
recommended to read (at the very least) the
[Manuals](https://metacpan.org/pod/DBIC%3A%3AManual%3A%3ADocMap#Manuals) in the order presented there.

# GETTING HELP/SUPPORT

Due to the sheer size of its problem domain, DBIC is a relatively
complex framework. After you start using DBIC questions will inevitably
arise. If you are stuck with a problem or have doubts about a particular
approach do not hesitate to contact us via any of the following options (the
list is sorted by "fastest response time"):

- RT Bug Tracker: [https://rt.cpan.org/Public/Dist/Display.html?Name=DBIC](https://rt.cpan.org/Public/Dist/Display.html?Name=DBIC)
- Email: [mailto:bug-DBIC@rt.cpan.org](mailto:bug-DBIC@rt.cpan.org)
- Twitter: [https://twitter.com/intent/tweet?text=%40ribasushi%20%23DBIC](https://twitter.com/intent/tweet?text=%40ribasushi%20%23DBIC)

# HOW TO CONTRIBUTE

Contributions are always welcome, in all usable forms (we especially
welcome documentation improvements). The delivery methods include git-
or unified-diff formatted patches, GitHub pull requests, or plain bug
reports either via RT or the Mailing list. Do not hesitate to
[get in touch](#getting-help-support) with any further questions you may
have.

This project is maintained in a git repository. The code and related tools are
accessible at the following locations:

- Current git repository: [https://github.com/Perl5/DBIC](https://github.com/Perl5/DBIC)
- Travis-CI log: [https://travis-ci.com/github/Perl5/DBIC/branches](https://travis-ci.com/github/Perl5/DBIC/branches)

# AUTHOR

Torsten Raudssus <torsten@raudssus.de>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2005 by DBIC Contributors.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
