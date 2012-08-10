use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Paginator::Lite',
    AUTHOR        => q{Blabos de Blebe <blabos@cpan.org>},
    VERSION_FROM  => 'lib/Paginator/Lite.pm',
    ABSTRACT_FROM => 'lib/Paginator/Lite.pm',
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ( 'LICENSE' => 'perl' )
        : () ),
    PL_FILES  => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Moo'        => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Paginator-Lite-*' },
);
