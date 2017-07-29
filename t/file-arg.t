use Test;
use GetOpt::Parse;

plan 15;

my @opts = (
    opt(
        name => 'path',
        match => 'path',
    ),
    opt(
        name => 'e-file',
        match => 'existing-file'
    ),
    opt(
        name => 'e-path',
        match => 'existing-path'
    ),
    opt(
        name => 'e-directory',
        match => 'existing-directory',
    )
);

my $parser = GetOpt::Parse.new(
    :@opts,
    mark-invalid => :{ :before('✘'), :after('✘')},
    command => 'goof',
);


is $parser.get-opts(<--path foo.txt>)<path>, 'foo.txt',
  'match => foo.txt returns foo.txt';


ok $parser.get-opts(<--path foo.txt>)<path> ~~ IO,
  'match => foo.txt returns an IO::Path';

{
    ok $parser.get-opts( ('--e-path', $*CWD.absolute) ),
      ‘match => 'existing-path'’;

    my $gist = Q:to/END/;
    Invalid value for e-path. Expected a existing directory but got: ‘/NawtExisting/path’.
    >> goof --e-path ✘/NawtExisting/path✘
    END

    throws-like { $parser.get-opts( ('--e-path', '/NawtExisting/path') ) },
      GetOpt::Parse::X,
      gist => *.starts-with($gist);

}

{
    is $parser.get-opts( ('--e-directory', $*CWD.absolute) )<e-directory>, $*CWD.absolute,
      'match => $*CWD.absolute returns $*CWD.absolute';


    ok $parser.get-opts( ('--e-directory', $*CWD.absolute) )<e-directory> ~~ IO,
      'match => $*CWD.absolute returns an IO::Path';

    throws-like {
        $parser.get-opts( ('--e-directory', '/NawtExisting/path') );
    },
    GetOpt::Parse::X, 'existing-directory throws against non-existing path';

    throws-like {
        $parser.get-opts( ('--e-directory', $?FILE.Str) )
    },
    GetOpt::Parse::X, 'existing-directory throws against a file';
}

{
    is $parser.get-opts( ('--e-path', $?FILE.Str) )<e-path>, $?FILE.Str,
      'match => $?FILE.Str returns $?FILE.Str';


    ok $parser.get-opts( ('--e-path', $?FILE.Str) )<e-path> ~~ IO,
      'match => $?FILE.Str returns an IO::Path';


    throws-like {
        $parser.get-opts( ('--e-path', '/NawtExisting/path') )
    },
    GetOpt::Parse::X, 'existing-path throws against a non-existing path';
}


{
    is $parser.get-opts( ('--e-file', $?FILE.Str) )<e-file>, $?FILE.Str,
    'match => $?FILE.Str returns $?FILE.Str';


    ok $parser.get-opts( ('--e-file', $?FILE.Str) )<e-file> ~~ IO,
    'match => $?FILE.Str returns an IO::Path';


    throws-like {
        $parser.get-opts( ('--e-file', '/NawtExisting/path') )
    },
    GetOpt::Parse::X, 'existing-file throws against a non-existing file';


    throws-like {
        $parser.get-opts( ('--e-file', $*CWD.absolute) )
    },
    GetOpt::Parse::X, 'existing-file throws against a non-existing file';
}
