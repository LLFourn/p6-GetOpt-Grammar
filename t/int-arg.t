use Test;
use GetOpt::Parse;

plan 6;

my @opts = (
    opt(
        :name<myint>,
        :match<int>,
        :alias<i>,
        hint => 3,
        desc => 'an pretty sick integoo'
    ),
    opt(
        :name<myuint>,
        :match<uint>,
        :alias<u>,
        hint => 4,
        desc => 'an unsigned integer'
    )
);


my $parser = GetOpt::Parse.new(
    :@opts,
    command => 'goof',
    mark-invalid => :{ :before('✘'), :after('✘')},
);

is-deeply $parser.get-opts(<--myint=5>),  { myint => 5  };
is-deeply $parser.get-opts(<-i 5>),       { myint => 5  };
is-deeply $parser.get-opts(<-i -5>),      { myint => -5 };
is-deeply $parser.get-opts(<-i5>),        { myint => 5 };
is-deeply $parser.get-opts(<-u 3>),       {'myuint' => 3};

{
    my $gist = Q:to/END/;
    Invalid value for myint. Expected a integer but got: ‘foo’.
    >> goof -i ✘foo✘
    END

    throws-like { $parser.get-opts(<-i foo>) },
      GetOpt::Parse::X,
      gist => *.starts-with($gist);
}
