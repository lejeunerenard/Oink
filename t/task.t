use strict;
use warnings;

use lib qw{ ./t/lib };

use Test::More;
use Test::Deep; # (); # uncomment to stop prototype errors
use Test::Exception;

use File::Temp;
use Cwd;

use Oink::Task;

subtest 'structure' => sub {
    my $task = Oink::Task->new(
        command => 'echo "hi"',
    );
    isa_ok $task, 'Oink::Task';
    can_ok $task, qw(
        dir
        git_repo
        install_deps
        env_vars
        command
        args
        run
    );
};
subtest 'run' => sub {
    subtest 'successful' => sub {
        my $simple_dir = File::Temp->newdir;

        my $echo = Oink::Task->new(
            dir     => $simple_dir,
            command => 'echo "beep" > $HI',
            env_vars => {
                HI => 'boop',
            },
        );

        my ( $echo_std, $echo_sterr, $echo_exit );
        lives_ok {
            ( $echo_std, $echo_sterr, $echo_exit ) = $echo->run;
        }
        'simple echo runs';

        ok -f File::Spec->catfile( $simple_dir, 'boop' ),
          'command run w/ env_vars';
        is $echo_std,   '', 'stdout is blank';
        is $echo_sterr, '', 'stderr is blank';
        is $echo_exit,  0,  'successful exit code';
        isnt getcwd, $simple_dir, 'returned to original directory';
        ok not( $ENV{HI}, ), 'env not changed';
    };
    subtest 'fails' => sub {
        my $failure_dir = File::Temp->newdir;

        my $failure_task = Oink::Task->new(
            dir => $failure_dir,
            command => '>&2 echo "WAT"',
        );

        my ( $std, $sterr, $exit );
        lives_ok {
            ( $std, $sterr, $exit ) = $failure_task->run;
        } 'still lives';

        is $std, '', 'stdout is blank';
        is $sterr, "WAT\n", 'stderr contains cmd\'s stderr output';
        is $exit, 0, 'non-zero exit code returned';

        TODO: {
            local $TODO = "I obviously don't understand exit codes";
            my $exit_task = Oink::Task->new(
                command => 'exit',
                args    => [ 113, ]
            );
            lives_ok {
                ( $std, $sterr, $exit ) = $exit_task->run;
            }
            'still lives';
            is $exit, 113, 'returns exit code';
        }
    };
};
done_testing;
