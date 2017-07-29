use Test;

plan 6;

use GetOpt::Parse;

my @opts = (
        opt( name => 'arg1' ),
        opt( name => 'arg2' )
);

my $parser = GetOpt::Parse.new(
    :@opts,
    mark-invalid => :{ :before('✘'), :after('✘')},
);


is-deeply $parser.get-opts(<--arg1>), { :arg1 };
is-deeply $parser.get-opts(<--arg1=0>), { :!arg1 };
is-deeply $parser.get-opts(<--arg1=false>), { :!arg1 };
is-deeply $parser.get-opts(<--arg1 --arg2>), { :arg1, :arg2 };
is-deeply $parser.get-opts(<--arg1 --arg2=false>), { :arg1, :!arg2 };

{
    my $gist = Q:to/END/.subst(/\n$/,'');
    Invalid value for arg1. Expected a true/false value but got: ‘foo’.
    >> t/bool-arg.t --arg1=✘foo✘

    Usage:
      --arg1
    END
    throws-like { $parser.get-opts(<--arg1=foo>) },
      GetOpt::Parse::X,
      :$gist;
}
