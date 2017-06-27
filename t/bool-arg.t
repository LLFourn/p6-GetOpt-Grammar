use Test;

use GetOpt::Grammar;

my @args = <--bool-arg --arg foo>;

}

is-deeply MyOpts.get-opts(@args), { :bool-arg, :arg<foo> }
