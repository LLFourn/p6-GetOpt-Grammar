use Test;
use GetOpt::Grammar;

my @args = <--arg=foo.txt>;

my %opts = (
    opts => (
        {
            name => 'arg',
            shortname => 'a',
        },
        {
            name => 'arg1',
        },
        {
            name => 'arg2',
        }
    ),
);

my $parser = GetOpt::Grammar.new: :%opts;

is-deeply $parser.get-opts('--arg=foo.txt'), { arg => 'foo.txt' };
is-deeply $parser.get-opts(<--arg foo.txt>, :%opts), { arg => 'foo.txt' };
is-deeply $parser.get-opts(<-a foo.txt>), { arg => 'foo.txt' };
is-deeply $parser.get-opts(<--arg1 arg1.txt --arg2 arg2.txt>),
  { arg1 => 'arg1.txt', arg2 => 'arg2.txt'};
