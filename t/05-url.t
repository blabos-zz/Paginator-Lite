#!perl

use Test::Most;
use Paginator::Lite;

my ( $pag, %args );

%args = (
    base_url   => '/foo/bar',
    curr       => 5,
    frame_size => 5,
    items      => 200,
    page_size  => 10,
    params     => {
        foo => 'abc',
        bar => '123',
    },
);

##############################################################################

$pag = Paginator::Lite->new(%args);

is( $pag->first_url, '/foo/bar/1',  'First URI with path mode' );
is( $pag->prev_url,  '/foo/bar/4',  'Prev URI with path mode' );
is( $pag->curr_url,  '/foo/bar/5',  'Curr URI with path mode' );
is( $pag->next_url,  '/foo/bar/6',  'Next URI with path mode' );
is( $pag->last_url,  '/foo/bar/20', 'Last URI with path mode' );

##############################################################################

$pag = Paginator::Lite->new( %args, mode => 'query' );

is(
    $pag->first_url,
    '/foo/bar?bar=123&foo=abc&page=1',
    'First URI with query mode'
);

is(
    $pag->prev_url,
    '/foo/bar?bar=123&foo=abc&page=4',
    'Prev URI with query mode'
);

is(
    $pag->curr_url,
    '/foo/bar?bar=123&foo=abc&page=5',
    'Curr URI with query mode'
);

is(
    $pag->next_url,
    '/foo/bar?bar=123&foo=abc&page=6',
    'Next URI with query mode'
);

is(
    $pag->last_url,
    '/foo/bar?bar=123&foo=abc&page=20',
    'Last URI with query mode'
);

##############################################################################

done_testing;

