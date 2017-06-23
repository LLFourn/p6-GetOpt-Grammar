grammar GetOpt::Grammar {

    proto token subcommand {*}
    proto token opt {*}

    token opt:null {
        {

        }

    }

    token TOP {
        [ <flag> ]* % <.sep>
        { $/.make: Hash.new: $<flag>.map(*.ast) || Empty }
    }

    token flag {
        '--' <opt>
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

    method get-opts($args = @*ARGS) {
        my $str = $args.join("\x[1f]");
        note $str;
        self.parse($str).ast;
    }
}
