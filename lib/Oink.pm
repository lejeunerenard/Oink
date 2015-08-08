package Oink;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Path::Tiny;
use YAML;

use Oink::Task;

use Moo;

has task_dirs => (
    is  => 'rw',
    isa => sub {
        die 'task_dirs is not an array' unless ref $_[0] eq 'ARRAY';
    },
    coerce => sub {
        unless ( ref $_[0] eq 'ARRAY' ) {
            return [ $_[0] ];
        }
    },
    default => sub {
        [];
    },
);

has tasks => (
    is      => 'rw',
    default => sub {
        [];
    },
);

around 'new' => sub {
    my $orig = shift;
    my $self = $orig->(@_);

    $self->load_tasks_from_dirs;

    return $self;
};

sub load_tasks_from_dirs {
    my $self = shift;

    foreach my $dir ( @{ $self->task_dirs } ) {
        $self->add_tasks($dir);
    }
}

sub add_tasks {
    my $self = shift;
    my $dir  = shift;

    my @new_tasks;

    my $iter = path($dir)->iterator;
    while ( my $path = $iter->() ) {
        push @new_tasks, Oink::Task->new( %{ Load( $path->slurp ) } );
    }

    $self->tasks( [ @{ $self->tasks }, @new_tasks ] );
    return \@new_tasks;
}

sub run {
    my $self = shift;

    foreach my $task ( @{ $self->tasks } ) {
        my ( $stdout, $stderr, $return ) = $task->run;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Oink - Throwing perls before swine.

=head1 SYNOPSIS

  use Oink;

  my $oink = Oink->new(@Args);
  $oink->run;

=head1 DESCRIPTION

Oink is a test runner. Throw them perls before swine and know whether they like them...

=head1 METHODS

=head2 run

C<run> will run the configured Oink instance with all it's plugins etc.

=head2 load_tasks_from_dirs

C<load_tasks_from_dirs> will add all tasks from the objects C<task_dirs> attribute.

=head1 AUTHOR

Sean Zellmer E<lt>sean@lejeunerenard.comE<gt>

=head1 COPYRIGHT

Copyright 2015- Sean Zellmer

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=over

=item *

L<Grunt|http://gruntjs.com/>

=item *

L<Test::Unit>

=back

=cut
