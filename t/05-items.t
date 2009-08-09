#!perl -T

use strict;
use warnings;

use Test::More tests => 14;

use Paginator::Lite;

my $paginator = Paginator::Lite->new;


eval {
    $paginator->repaginate({
        'items'         => 800,
        'items_per_page'=> 20,
        'current'       => 30,
    });
};
if ($@) {
    diag($@, 'Repaginate receiving "items", "items_per_page"');
}


cmp_ok(($paginator->first), '==',  1, 'Checking $paginator->first');
cmp_ok(($paginator->prev ), '==', 29, 'Checking $paginator->prev' );
cmp_ok(($paginator->begin), '==', 26, 'Checking $paginator->begin');
cmp_ok(($paginator->curr ), '==', 30, 'Checking $paginator->curr' );
cmp_ok(($paginator->end  ), '==', 35, 'Checking $paginator->end'  );
cmp_ok(($paginator->next ), '==', 31, 'Checking $paginator->next' );
cmp_ok(($paginator->last ), '==', 40, 'Checking $paginator->last' );


eval {
    $paginator->repaginate({
        'items'         => 801,
        'items_per_page'=> 20,
        'current'       => 30,
    });
};
if ($@) {
    diag($@, 'Repaginate receiving "items", "items_per_page"');
}


cmp_ok(($paginator->first), '==',  1, 'Checking $paginator->first');
cmp_ok(($paginator->prev ), '==', 29, 'Checking $paginator->prev' );
cmp_ok(($paginator->begin), '==', 26, 'Checking $paginator->begin');
cmp_ok(($paginator->curr ), '==', 30, 'Checking $paginator->curr' );
cmp_ok(($paginator->end  ), '==', 35, 'Checking $paginator->end'  );
cmp_ok(($paginator->next ), '==', 31, 'Checking $paginator->next' );
cmp_ok(($paginator->last ), '==', 41, 'Checking $paginator->last' );
