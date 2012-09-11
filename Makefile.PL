use 5.008008;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Paginator::Lite',
    AUTHOR             => q{Blabos de Blebe <blabos@cpan.org>},
    VERSION_FROM       => 'lib/Paginator/Lite.pm',
    ABSTRACT_FROM      => 'lib/Paginator/Lite.pm',
    MIN_PERL_VERSION   => 5.008008,
    LICENSE            => 'perl',
    PL_FILES           => {},
    BUILD_REQUIRES     => { 'Test::More' => 0 },
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMake' => 6.48 },
    PREREQ_PM          => { 'Moo' => 1.000003 },
    dist               => {
        COMPRESS => 'gzip -9f',
        SUFFIX   => 'gz',
    },
    clean => { FILES => 'Paginator-Lite-*' },
);
