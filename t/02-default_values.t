#!perl -T

use strict;
use warnings;

use Test::More tests => 7;

use Paginator::Lite;

my $paginator = Paginator::Lite->new;


eval {
    $paginator->repaginate();
};
if ($@) {
    diag($@, 'Repaginate without args');
}


cmp_ok(($paginator->first), '==', 1, 'Checking $paginator->first');
cmp_ok(($paginator->prev ), '==', 1, 'Checking $paginator->prev' );
cmp_ok(($paginator->begin), '==', 1, 'Checking $paginator->begin');
cmp_ok(($paginator->curr ), '==', 1, 'Checking $paginator->curr' );
cmp_ok(($paginator->end  ), '==', 1, 'Checking $paginator->end'  );
cmp_ok(($paginator->next ), '==', 1, 'Checking $paginator->next' );
cmp_ok(($paginator->last ), '==', 1, 'Checking $paginator->last' );
