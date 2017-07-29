use Test;
use GetOpt::Parse;

plan 3;


my @pos = (
    pos(
        :name<stringer>,
        :match<str>,
        usage => 'A stringy stringoo'
    ),
    pos(
        :name<number>,
        :match<int>,
        :!required,
    )
);


my $parser = GetOpt::Parse.new(:@pos, command => 'goof');

is-deeply $parser.get-opts(<foo 3>), { :stringer<foo>, number => 3 };

is-deeply $parser.get-opts(<foo>), { :stringer<foo> };

throws-like { $parser.get-opts(Empty) },
  GetOpt::Parse::X::Missing,
  opt => *.<name>.&[eq]('stringer');
