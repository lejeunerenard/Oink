use strict;
use warnings;

use lib qw{ ./t/lib };

use Test::More;
use Test::Deep;
use Test::Exception;

use File::Copy::Recursive qw( dircopy );
use File::Temp;
use FileHandle;

use Oink;


my $dir = File::Temp->newdir;

Git::Repository->run( init => $dir, );
my $r = Git::Repository->new( work_tree => $dir );

# Copy example repo files
dircopy( "t/fake-repo/", $dir ) or fail "Copy failed: $!";
$r->run( add => '.' );
$r->run( commit => '-m', 'init' );

# Create fake repo
my $git_task = Oink::Task->new(
    git_repo => $dir,
    command => 'prove',
    args => [
        '--norc',
        't/test.pl',
    ],
);
my ($stdout, $stderr, $exit_code) = $git_task->run;

like $stdout, qr/All tests successful\./, 'stdout is successful test';
is $stderr, '', 'stderr is blank';
is $exit_code, 0, 'exit code is zero';

done_testing;
