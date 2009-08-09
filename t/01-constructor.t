#!perl -T

use strict;
use warnings;

use Test::More tests => 1;

use Paginator::Lite;

ok(
    (my $paginator = Paginator::Lite->new),
    'Constructed paginator object'
);
