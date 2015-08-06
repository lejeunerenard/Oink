# NAME

Oink - Throwing perls before swine.

# SYNOPSIS

    use Oink;

    my $oink = Oink->new(@Args);
    $oink->run;

# DESCRIPTION

Oink is a test runner. Throw them perls before swine and know whether they like them...

# METHODS

## run

`run` will run the configured Oink instance with all it's plugins etc.

## load\_tasks\_from\_dirs

`load_tasks_from_dirs` will add all tasks from the objects `task_dirs` attribute.

# AUTHOR

Sean Zellmer <sean@lejeunerenard.com>

# COPYRIGHT

Copyright 2015- Sean Zellmer

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

- [Grunt](http://gruntjs.com/)
- [Test::Unit](https://metacpan.org/pod/Test::Unit)
