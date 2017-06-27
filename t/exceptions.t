use Test;
use GetOpt::Grammar;

my %opts = (
    opts => (
        {
            name => 'arg',
            shortname => 'a',
            doc => 'an argument'
        },
    ),
);

my $parser = GetOpt::Grammar.new: :%opts;

note $parser.get-opts(<--arg1 arg1.txt>, command => 'goof');
