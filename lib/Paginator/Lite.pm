package Paginator::Lite;

use warnings;
use strict;

use Carp;

=head1 NAME

Paginator::Lite - A simple paginator

=head1 VERSION

Version 1.02

=cut

our $VERSION = '1.02';

=head1 SYNOPSIS

This module provides a simple way to get some information about a collection
of data (rows of the database, sometimes) that can be used to build pagination
components.

    use Paginator::Lite;
    
    my $paginator = Paginator::Lite->new({
        current     => 3,
        items       => 30,
        frame_size  => 5,
    });
    
    ...
    
    $paginator->first       # 1
    $paginator->last        # 6
    $paginator->next        # 4
    
    

=head1 DESCRIPTION

When handle with huge amounts of data sometimes you want to display only a
portion of it and provide controls to naviagte through it.

The classic way is to provide links or buttons to next, previous and some
pages around the current page, like this:

    (prev)  1 2 [3] 4 5 (next)

But when the number of pages grow up too much this approach may be annoying:

    (prev) 1 2 3 4 5 6 7 8 9 10 [11] 12 13 14 15 16 16 18 19 20 21 (next)

So Paginator::Lite helps you calculating the numbers to feed your view loops
and implements the concept of frame. A frame is a small portion of pages
around the current page that will be displayed in addition to (prev), (next)
and other permanent buttons:

    (prev) 10 11 12 [13] 14 15 16 (next)
            \                  /
              ----- frame ----
                7 of 21 pages

=head1 METHODS

=head2 new

Constructor. Creates a Paginator::Lite object. May be aclled without args or
with the same as repaginate()

    my $paginator = Paginator::Lite->new;

=cut

sub new {
    my $class = shift;
    my $args  = shift || {};
    my $atts  = {
        'first'      => 1,
        'prev'       => 1,
        'begin'      => 1,
        'curr'       => 1,
        'end'        => 1,
        'next'       => 1,
        'last'       => 1,
        'frame_size' => 1,
        'pages'      => 1,
    };

    my $paginator = bless $atts, $class;
    $paginator->repaginate($args)
      if exists $args->{'pages'}
      || ( exists $args->{'items'} && exists $args->{'frame_size'} );

    return $paginator;
}

=head2 repaginate

Takes the parameters and calculates the next, previous and which pages will be
into the frame.

All parameters are optional. The module provides some default values.

If you try to pass negative values, the method will kick your ass, throwing
an exception! Therefore, be nice!

If you pass the total number of pages, the method will ignore the number of
items and the number of items per page (if one or both were provided).
Otherwise, if you don't provide the number of pages, the method will try to
calculate it using the number of items, the number of items per page or
defaults values if you don't provide any.

Usually you will provide the args 'current', 'frame_size' and 'pages'.
The last one may be exchanged by the pair 'items' and 'items_per_page'.

All parameter are named as follow:

=over

=item pages: The total number of pages.

=item items: The total number of items.

=item items_per_page: The number of items for each page.

=item current: The number of the current page.

=item frame_size: The size of frame.

=back

Example:

    $paginator->repaginate({
        'pages'         => 20,
        'current'       => 13,
        'frame_size'    => 7,
    });
    
    my $first   = $paginator->first;    # $first    == 1
    my $prev    = $paginator->prev;     # $prev     == 12
    my $begin   = $paginator->begin;    # $begin    == 10
    my $curr    = $paginator->curr;     # $curr     == 13
    my $end     = $paginator->end;      # $end      == 16
    my $last    = $paginator->last;     # $last     == 20
    
=cut

sub repaginate {
    my ( $self, $args ) = @_;
    my ( $pages, $current );

    $current = int( $args->{'current'} || 1 );
    croak 'Cannot paginate without a positive current page.'
      unless $current > 0;

    $self->{'frame_size'} =
      defined $args->{'frame_size'}
      ? int( $args->{'frame_size'} )
      : 10;

    croak 'Cannot paginate with a negative frame size.'
      unless $self->{'frame_size'} >= 0;

    if ( $args->{'pages'} ) {
        $pages = int( $args->{'pages'} );
    }
    else {
        my $items_per_page = int( $args->{'items_per_page'} || 1 );
        my $items          = int( $args->{'items'}          || 1 );

        croak 'Cannot paginate with non positive items'
          unless $items > 0;
        croak 'Cannot paginate with non positive items_per_page'
          unless $items_per_page > 0;

        # Calculate and round up.
        my $div = $items / $items_per_page;
        $pages = int($div);
        $pages++ unless $pages == $div;
    }
    croak 'Cannot paginate without a positive number of pages.'
      unless $pages > 0;

    $current = $current <= $pages ? $current : 1;

    $self->{'first'} = 1;
    $self->{'last'}  = $pages;
    $self->{'curr'}  = $current;

    my $half_frame = int( 0.5 + $self->{'frame_size'} / 2 );

    $self->{'prev'} = $current - 1;
    $self->{'prev'} = $self->{'prev'} > 0 ? $self->{'prev'} : 1;

    $self->{'next'} = $current + 1;
    $self->{'next'} = $self->{'next'} <= $pages ? $self->{'next'} : $pages;

    $self->{'pages'} = $pages;

    if ( $self->{'frame_size'} == 0 ) {
        $self->{'begin'} = $self->{'end'} = $current;
    }
    elsif ( $pages > $self->{'frame_size'} ) {
        $self->{'begin'} = $current - $half_frame + 1;
        $self->{'begin'} = $self->{'begin'} > 0 ? $self->{'begin'} : 1;
        $self->{'end'}   = $self->{'begin'} + $self->{'frame_size'} - 1;

        if ( $self->{'end'} > $pages ) {
            $self->{'end'}   = $pages;
            $self->{'begin'} = $self->{'end'} - $self->{'frame_size'} + 1;
        }
    }
    else {
        $self->{'begin'} = 1;
        $self->{'end'}   = $pages;
    }
}

=head2 first

Accessor method to retrieve the number of the first one page.

=cut

sub first {
    my $self = shift;

    return $self->{'first'};
}

=head2 prev

Accessor method to retrieve the number of previous page.

=cut

sub prev {
    my $self = shift;

    return $self->{'prev'};
}

=head2 begin

Accessor method to retrieve the beginning of the frame.

=cut

sub begin {
    my $self = shift;

    return $self->{'begin'};
}

=head2 curr

Accessor method to retrieve the number of current page.

=cut

sub curr {
    my $self = shift;

    return $self->{'curr'};
}

=head2 end

Accessor method to retrieve the end of the frame.

=cut

sub end {
    my $self = shift;

    return $self->{'end'};
}

=head2 next

Accessor method to retrieve the number of next page.

=cut

sub next {
    my $self = shift;

    return $self->{'next'};
}

=head2 last

Accessor method to retrieve the number of the last one page.

=cut

sub last {
    my $self = shift;

    return $self->{'last'};
}

=head2 frame_size

Accessor method to retrieve the frame size.

=cut

sub frame_size {
    my $self = shift;

    return $self->{'frame_size'};
}

=head2 pages

Accessor method to retrieve the total number of pages

=cut

sub pages {
    my $self = shift;

    return $self->{'pages'};
}

=head1 AUTHOR

Blabos de Blebe, C<< <blabos at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-paginator-lite at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Paginator-Lite>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Paginator::Lite


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Paginator-Lite>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Paginator-Lite>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Paginator-Lite>

=item * Search CPAN

L<http://search.cpan.org/dist/Paginator-Lite/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2011 Blabos de Blebe.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

42;
