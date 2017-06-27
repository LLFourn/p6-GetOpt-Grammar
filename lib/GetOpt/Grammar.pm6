use GetOpt::Grammar::Exceptions;


grammar GetOpt::Grammar {

    proto token subcommand {*}
    proto token opt {*}

    method exception($message, :$match = self.MATCH){
        GetOpt::Grammar::X.new(
            :$match,
            :$message
        ).throw;
    }

    token bogus($message) {
        <value>
        { self.exception: "$message: ‘{$<value>.Str}’", match => $<value> }
    }

    token opt:null {
        {}
        <.bogus("Unknown option")>
    }

    token TOP {
        [ <flag> ]* % <.sep>
        { $/.make: Hash.new: $<flag>.map(*.ast) || Empty }
    }

    token flag {

        {
            $/.make: $<opt>.ast //
                     ($<opt><sym>.Str => $<opt><arg>.ast)
        }
    }

    token sep  { \x[1f] }

    token value { <-[\x[1f]]>+ }

    token arg {
        [
            |<.sep><value>
            |'='<value>
        ]
        {
            $/.make: $<value>.Str
        }
    }

    token bool {
        ['='
         $<bool>=[
             || ['false'|'true'|'0'|'1' | ''] <?before <.sep>>
             || $<bogus('Invalid value true/false value')>

        ]?
        {
            $/.make: do given $<bool> {
                when !.defined  { True  }
                when 'true'|'1' { True  }
                default         { False }
            }
        }
    }

    method get-opts($args = @*ARGS) {
        my $str = $args.join("\x[1f]");
        self.parse($str).ast;
    }
}
