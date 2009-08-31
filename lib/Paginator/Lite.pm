package Paginator::Lite;

use warnings;
use strict;

use Carp;

=head1 NAME

Paginator::Lite - A simple paginator

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.03';


=head1 SYNOPSIS

This module provides a simple way to get some informations about a collection
of data (database rows, sometimes) that may be used to make pagination
components.

=head1 DESCRIPTION

When you handle collections of data, sometimes you don't want to retrieve or
display all items at once. If you are working with a database, its easy
retrieve only a portion of rows each time using the keywords LIMIT and OFFSET.

The annoying problem, is how to create navigation for all 'pages' of data.

On my applications, normally I know the total number of rows, how much rows
I want to display and what is the current page. So, since the first and last
pages are relatively fixed, I can make a loop that iterates from first page
(normally 1) until the last page and create the navigation.

This approach works fine since I don't have too many pages to display. When
the number of pages grow up, I get too many components polluting the
interface. In this case, I need paginate the paginator!

For this, I think in the concept of frame. A frame is a subset of pagination
components that are visible at this moment. So, instead of a thousand of
buttons or links, I have a 'window' with only some of them. Something like
the pagination at bottom of Google Search page, that displays only 20 page
each time. Additionally, the current page is in middle of frame always that
is possible. I like this!

So, given the total number of pages (or the number of items and the number of
items per page), the number of the current page and the frame size, I want a
subset of pages (the number of each page) on which the current page is in the
middle of frame, the first page on frame is something like
(current - frame_size / 2) and the last page on frame is something like
(current + frame_size / 2). Additionally I want know which is the first page
(almost always 1), last page, previous page and next page.

With these informations, I can create a view like this:

    (first) (prev) 4 5 6 [7] 8 9 10 (next) (last)

Usually, each time we need draw the paginator, we need calculate these values
and check them if they are not out of range. This module does exactly this.

Note: This module don't generates html. It only helps you to do this,
providing you with information about how to generate a simple view.


=head1 METHODS

=head2 new

Constructor. Creates a Paginator::Lite object. Doesn't expect arguments.

    my $paginator = Paginator::Lite->new;

=cut

sub new {
    my $class   = shift;
    my $args    = shift || {};
    my $atts    = {
        'first'     => 1,
        'prev'      => 1,
        'begin'     => 1,
        'curr'      => 1,
        'end'       => 1,
        'next'      => 1,
        'last'      => 1,
    };
    
    return bless $atts, $class;
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
    my ($self, $atts) = @_;
    my ($pages, $current, $frame_size);
    
    $current = int($atts->{'current'} || 1);
    croak 'Cannot paginate without a positive current page.'
        unless $current > 0;
    
    $frame_size = int($atts->{'frame_size'} || 10);
    croak 'Cannot paginate without a positive frame size.'
        unless $frame_size > 0;
    
    if ($atts->{'pages'}) {
        $pages = int($atts->{'pages'});
    }
    else {
        my $items_per_page = int($atts->{'items_per_page'} || 1);
        my $items = int($atts->{'items'} || 1);
        
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
     
    $self->{'first'}    = 1;
    $self->{'last'}     = $pages;
    $self->{'curr'}     = $current;
    
    my $half_frame = int(0.5 + $frame_size / 2);
    
    $self->{'prev'} = $current - 1;
    $self->{'prev'} = $self->{'prev'} > 0 ? $self->{'prev'} : 1;
    
    $self->{'next'} = $current + 1;
    $self->{'next'} = $self->{'next'} <= $pages ? $self->{'next'} : $pages;
    
    if ($pages > $frame_size) {
        $self->{'begin'} = $current - $half_frame + 1;
        $self->{'begin'} = $self->{'begin'} > 0 ? $self->{'begin'} : 1;
        $self->{'end'}   = $self->{'begin'} + $frame_size - 1;
        
        if ($self->{'end'} > $pages) {
            $self->{'end'}   = $pages;
            $self->{'begin'} = $self->{'end'} - $frame_size + 1;
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

Accessor method to retrieve the number of first page into the frame.

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

Accessor method to retrieve the number of last page into the frame.

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

Copyright 2009 Blabos de Blebe.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

42; # End of Paginator::Lite
