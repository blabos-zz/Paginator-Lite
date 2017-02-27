requires 'Moo';

on 'test' => sub {
    requires 'Test::Most';
    requires 'Test::Pod';
    requires 'Test::Pod::Coverage';
    requires 'Pod::Coverage::TrustPod';
    requires 'Test::Perl::Critic';
};
