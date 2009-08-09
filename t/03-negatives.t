#!perl -T

use strict;
use warnings;

use Test::More tests => 8;

use Paginator::Lite;

my $paginator = Paginator::Lite->new;


eval {
    $paginator->repaginate({'pages' => -1});
};
if ($@) {
    pass('Checking exceptions for negative "pages"');
    #diag($@);
}
else {
    fail('Checking exceptions for negative "pages"');
}


eval {
    $paginator->repaginate({'current' => -1});
};
if ($@) {
    pass('Checking exceptions for negative "current"');
    #diag($@);
}
else {
    fail('Checking exceptions for negative "current"');
}


eval {
    $paginator->repaginate({'frame_size' => -1});
};
if ($@) {
    pass('Checking exceptions for negative "frame_size"');
    #diag($@);
}
else {
    fail('Checking exceptions for negative "frame_size"');
}


eval {
    $paginator->repaginate({'items' => -1});
};
if ($@) {
    pass('Checking exceptions for negative "items"');
    #diag($@);
}
else {
    fail('Checking exceptions for negative "items"');
}


eval {
    $paginator->repaginate({'items_per_page' => -1});
};
if ($@) {
    pass('Checking exceptions for negative "items_per_page"');
    #diag($@);
}
else {
    fail('Checking exceptions for negative "items_per_page"');
}


eval {
    $paginator->repaginate({
        'items'         => -1,
        'items_per_page'=> -1
    });
};
if ($@) {
    pass('Checking exceptions for negative "items" and "items_per_page"');
    #diag($@);
}
else {
    fail('Checking exceptions for negative "items" and "items_per_page"');
}


eval {
    $paginator->repaginate({
        'items'         =>  1,
        'items_per_page'=> -1
    });
};
if ($@) {
    pass('Checking exceptions for negative "items" or "items_per_page" 1');
    #diag($@);
}
else {
    fail('Checking exceptions for negative "items" or "items_per_page" 1');
}


eval {
    $paginator->repaginate({
        'items'         => -1,
        'items_per_page'=>  1
    });
};
if ($@) {
    pass('Checking exceptions for negative "items" or "items_per_page" 2');
    #diag($@);
}
else {
    fail('Checking exceptions for negative "items" or "items_per_page" 2');
}
