use Test;
use GetOpt::Grammar;

class MyOpts is GetOpt::Grammar {
    token opt:sym<arg> {
        <sym> <arg>
    }
}

MyOpts.get-opts(<--arg1 arg1.txt>);
