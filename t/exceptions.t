use Test;
use GetOpt::Grammar;



my %opts = (
    opts => (
        {
            name => 'arg',
            shortname => 'a',
        },
    ),
);

my $parser = GetOpt::Grammar.new: :%opts;

throws-like { $parser.get-opts(<--arg1 arg1.txt>, command => 'goof') },
            GetOpt::Grammar::X;
