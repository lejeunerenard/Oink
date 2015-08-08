requires 'perl', '5.008005';

requires 'Capture::Tiny';
requires 'File::Temp';
requires 'File::Copy::Recursive';
requires 'Git::Repository';
requires 'Moo';
requires 'Path::Tiny';

on test => sub {
    requires 'Test::More', '0.96';
};
