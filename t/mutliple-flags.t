use Test;
use GetOpt::Parse;

plan 2;

my @opts = (
    opt(
        :name<arg>,
        :alias<a>,
        :match<str>,
    ),
    opt(
        :name<arg1>,
        :alias<b>
    ),
    opt(
        :name<arg2>,
        :alias<c>,
    ),
);

my $parser = GetOpt::Parse.new(:@opts);

is-deeply $parser.get-opts(<-bc>), { :arg1, :arg2 };

is-deeply $parser.get-opts(<-bac foo>), { :arg1, :arg2, :arg<foo> };
