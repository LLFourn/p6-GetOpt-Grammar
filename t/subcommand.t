use Test;
use GetOpt::Parse;

plan 3;

my @opts = (
    opt(
        name => 'non-sc',
        match => 'str',
    ),
);

my @pos = (
    pos(
        :name<non-sc-pos>,
        :!required
    ),
);

my @subcommands = (
    {
        name => 'subc',
        opts => [
            opt(
                name => 'sc1',
                match => 'str',
            ) => [
            pos( name => "pos-arg" ),
        ]
    },
);


my $parser = GetOpt::Parse.new(:@opts, :@pos, :@subcommands, command => "goof");

is-deeply $parser.get-opts(<--non-sc foo subc --sc1 bar possy>),
  { :non-sc<foo>, :subcommands(["subc"]), :sc1<bar>, :pos-arg<possy> };

is-deeply $parser.get-opts(<--non-sc foo non_sc_possy>),
  { :non-sc<foo>, :non-sc-pos<non_sc_possy> },
  'non-required pos is still recognised with a subcommand';


throws-like {  $parser.get-opts(<--non-sc foo subc>) },
  GetOpt::Parse::X;
