#!perl -T

use strict;
use warnings;

use Test::More tests => 7;

use Paginator::Lite;

my $paginator = Paginator::Lite->new;


eval {
    $paginator->repaginate({
        'pages'         => 50,
        'current'       => 42,
        'frame_size'    => 7,
    });
};
if ($@) {
    diag($@, 'Repaginate receiving "pages", "current" and "frame_size"');
}


cmp_ok(($paginator->first), '==',  1, 'Checking $paginator->first');
cmp_ok(($paginator->prev ), '==', 41, 'Checking $paginator->prev' );
cmp_ok(($paginator->begin), '==', 39, 'Checking $paginator->begin');
cmp_ok(($paginator->curr ), '==', 42, 'Checking $paginator->curr' );
cmp_ok(($paginator->end  ), '==', 45, 'Checking $paginator->end'  );
cmp_ok(($paginator->next ), '==', 43, 'Checking $paginator->next' );
cmp_ok(($paginator->last ), '==', 50, 'Checking $paginator->last' );
