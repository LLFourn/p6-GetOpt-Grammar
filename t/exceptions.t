use Test;
use GetOpt::Parse;

plan 2;

{
    my @opts = (
        opt(
            name => 'arg',
            match => 'str',
        ),
    );

    my $parser = GetOpt::Parse.new(
        :@opts,
        mark-invalid => :{ :before('✘'), :after('✘')},
        command => "goof"
    );

    my $gist = qq:to/END/.subst(/\n$/,'');
    Unknown option: ‘--arg1’
    >> goof --✘arg1✘ arg1.txt
    END

    throws-like { $parser.get-opts(<--arg1 arg1.txt>, command => 'goof') },
      GetOpt::Parse::X,
      gist => *.starts-with($gist);

}

{
    my @opts = (
        opt(
            name => 'arg',
            match => 'str',
            desc => 'A cool argumenet',
            hint => 'coolness'
        )
    );

    my $parser = GetOpt::Parse.new(
        :@opts,
        command => 'goof',
        mark-missing => { %(after => ' <missing>') },
    );

    my $gist = Q:to/END/.subst(/\n$/,'');
    Value for ‘arg’ is required.
    >> goof --arg <missing>
    END

    throws-like { $parser.get-opts(<--arg>) },
      GetOpt::Parse::X::Missing,
      gist => *.starts-with($gist);
}
