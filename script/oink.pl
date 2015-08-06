#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use Oink;

my $pig = Oink->new(@ARGV);
$pig->run;
