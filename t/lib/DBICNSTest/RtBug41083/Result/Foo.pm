package DBICNSTest::RtBug41083::Result::Foo;
use strict;
use warnings;
use base 'DBIC::Core';
__PACKAGE__->table('foo');
__PACKAGE__->add_columns('foo');
1;
