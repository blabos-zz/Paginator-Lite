use inc::Module::Install;

name     'Paginator-Lite';
all_from 'lib/Paginator/Lite.pm';
author   q{Blabos de Blebe <blabos@cpan.org>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

