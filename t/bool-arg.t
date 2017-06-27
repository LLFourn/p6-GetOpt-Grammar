use Test;

use GetOpt::Grammar;

my @args = <--bool-arg --arg foo>;

class MyOpts is GetOpt::Grammar {

    token opt:sym<arg> {
        <sym> <arg>
    }

    token opt:sym<bool-arg> {
        <sym> $<arg>=<.bool>
    }

}

is-deeply MyOpts.get-opts(@args), { :bool-arg, :arg<foo> }
