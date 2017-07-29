use Test;
use GetOpt::Parse;

plan 4;

my @args = <--arg=foo.txt>;

my @opts = (
    opt(
        :name<arg>,
        :alias<a>,
        :match<str>,
    ),
    opt(
        :name<arg1>,
        :match<str>,
    ),
    opt(
        :name<arg2>,
        :match<str>,
    ),
);

my $parser = GetOpt::Parse.new(:@opts);

is-deeply $parser.get-opts(<--arg=foo.txt>), { arg => 'foo.txt' };
is-deeply $parser.get-opts(<--arg foo.txt>), { arg => 'foo.txt' };
is-deeply $parser.get-opts(<-a foo.txt>), { arg => 'foo.txt' };
is-deeply $parser.get-opts(<--arg1 arg1.txt --arg2=arg2.txt>),
  { arg1 => 'arg1.txt', arg2 => 'arg2.txt'};
