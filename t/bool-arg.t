use Test;

use GetOpt::Grammar;

my %opts = (
    opts => (
        {
            name => 'arg',
            shortname => 'a',
            type => 'bool',
        },
    ),
);

my $parser = GetOpt::Grammar.new: :%opts;

my @args = <--arg>;

note $parser.get-opts(@args);
