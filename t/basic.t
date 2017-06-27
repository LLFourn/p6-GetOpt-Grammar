use Test;
use GetOpt::Grammar;

my @args = <--arg=foo.txt>;

my %*opts = (
    arg => {
        alias => 'a',
        match => token { <arg> },
    },
    arg1 => { match => token { <arg> } },
    arg2 => { match => token { <arg> } },
);


is-deeply MyOpts.get-opts('--arg=foo.txt'), { arg => 'foo.txt' };
is-deeply MyOpts.get-opts(<--arg foo.txt>), { arg => 'foo.txt' };
is-deeply MyOpts.get-opts('-a foo.txt'), { arg => 'foo.txt' };
is-deeply MyOpts.get-opts(<--arg1 arg1.txt --arg2 arg2.txt>),
  { arg1 => 'arg1.txt', arg2 => 'arg2.txt'};
