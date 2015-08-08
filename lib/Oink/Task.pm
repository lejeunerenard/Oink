package Oink::Task;

use strict;
use warnings;

use Capture::Tiny 'capture';
use Cwd;
use File::Temp;
use Git::Repository;

use Moo;

has dir => (
    is      => 'rw',
    default => sub {
        getcwd;
    },
);

has git_repo => ( is => 'rw', );

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
    my $repo;
    my $git_dir;

    if ( $self->git_repo ) {
        $git_dir = File::Temp->newdir;

        Git::Repository->run( clone => $self->git_repo, $git_dir, );
        $repo = Git::Repository->new( work_tree => $git_dir );

        chdir $git_dir;
    }
    else {
        chdir $self->dir;
    }

    my %ENV_BEFORE = %ENV;

    my ( $stdout, $stderr, $exit_code ) = capture {
        if ( $self->env_vars ) {
            %ENV = ( %ENV, %{ $self->env_vars } );
        }
        system( $self->command, @{ $self->args } );
    };

    %ENV = %ENV_BEFORE;

    if ( $self->git_repo ) {
        chdir $original_dir;
    }
    else {
        chdir $original_dir;
    }

    return ( $stdout, $stderr, $exit_code );
}

1;
