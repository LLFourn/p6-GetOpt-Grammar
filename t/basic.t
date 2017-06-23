use Test;
use GetOpt::Grammar;
use Grammar::Tracer;

my @args = <--arg=foo.txt>;

class MyOpts is GetOpt::Grammar {
    token opt:sym<arg> {
        <sym> <arg>
    }
}

is-deeply MyOpts.get-opts('--arg=foo.txt'), { arg => 'foo.txt' };
is-deeply MyOpts.get-opts(<--arg foo.txt>), { arg => 'foo.txt' };
is-deeply MyOpts.get-opts(<--arg1 arg1.txt --arg2 arg2.txt>),
  { arg1 => 'arg1.txt', arg2 => 'arg2.txt'};
