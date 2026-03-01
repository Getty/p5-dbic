package # hide from PAUSE
    DBIC::Relationship::Helpers;
# ABSTRACT: Relationship helper methods
use strict;
use warnings;

use base qw/DBIC/;

__PACKAGE__->load_components(qw/
    Relationship::HasMany
    Relationship::HasOne
    Relationship::BelongsTo
    Relationship::ManyToMany
/);

1;
