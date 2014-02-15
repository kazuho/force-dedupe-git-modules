#! /usr/bin/perl

use strict;

use Cwd qw(getcwd);
use File::Temp qw(tempdir);

use Test::More;

my $CMD = getcwd . "/bin/force-dedupe-git-modules";

my $tempdir = tempdir(CLEANUP => 1);
chdir $tempdir
    or die "could not cd to temporary directory:$!";

system(qw(npm install git+ssh://git@github.com:kazuho/force-dedupe-git-modules.m1.git#v0.2.0)) == 0
    or die "failed to install m1:$?";

system(qw(npm install git+ssh://git@github.com:kazuho/force-dedupe-git-modules.m2.git#v0.1.0)) == 0
    or die "failed to install m2:$?";

is(
    runit(qw(node -e console.log(require("m1").getVersion()))),
    "0.2.0"
);

is(
    runit(qw(node -e console.log(require("m2").getVersionOfM1()))),
    "0.1.0"
);

system("node", $CMD) == 0
    or die "dedupe failed:$?";

is(
    runit(qw(node -e console.log(require("m1").getVersion()))),
    "0.2.0"
);

is(
    runit(qw(node -e console.log(require("m2").getVersionOfM1()))),
    "0.2.0"
);

done_testing;

sub runit {
    my @argv = @_;
    open my $fh, "-|", @argv
        or die "failed to run " . join(" ", @argv) . ":$!";
    my $lines = join "\n", <$fh>;
    close $fh;
    die "command: " .join(" ", @argv) . " existted abnormally:$?"
        if $?;
    chomp $lines;
    $lines;
}
