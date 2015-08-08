package Oink::Task;

use strict;
use warnings;

use Capture::Tiny 'capture';
use Cwd;

use Moo;

has dir => (
    is      => 'rw',
    default => sub {
        getcwd;
    },
);

has env_vars => (
    is  => 'rw',
    isa => sub {
        die 'env_vars must be a hashref' unless ref $_[0] eq 'HASH';
    },
);

has command => (
    is       => 'rw',
    required => 1,
);

has args => ( is => 'rw', );

=head2 run

C<run> will well... run the task and return the STDOUT, STDERR and exit code, in that order.

=cut

sub run {
    my $self = shift;


    my $original_dir = getcwd;

    chdir $self->dir;

    my %ENV_BEFORE = %ENV;

    my ( $stdout, $stderr, $exit_code ) = capture {
        if ( $self->env_vars ) {
            %ENV = ( %ENV, %{ $self->env_vars } );
        }
        system( $self->command, @{ $self->args }  );
    };

    %ENV = %ENV_BEFORE;

    chdir $original_dir;

    return ( $stdout, $stderr, $exit_code );
}

1;
