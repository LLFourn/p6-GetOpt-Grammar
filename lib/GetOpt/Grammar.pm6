use GetOpt::Grammar::Exceptions;


grammar GetOpt::Grammar {
    has %.opts;

    proto token subcommand {*}
    proto token opt {*}

    method exception($message, :$match = self.MATCH){
        GetOpt::Grammar::X.new(
            :$match,
            :$message,
            :$*command,
            usage => &*gen-usage(),
        ).throw;
    }

    token bogus($message) {
        <str>
        { self.exception: "$message: ‘{$<str>.Str}’", match => $<str> }
    }

    token TOP(%opts) {
        :my %res;
        :my @opts := %opts<opts>;
        :my @longnames = @opts.map: *<name>;
        :my @shortnames = @opts.map: { .<shortname> // Empty };
        (
            $<opt>=(
                | <.bogus("Unknown option")>
                | '--' » {note "here"} $<name>=@longnames
                | '-'  » $<shortname>=@shortnames
            )
            ['=' || <.sep> ]
            {}
            <value(@opts,%res)>
        )* % <.sep>
        { $/.make: %res }
    }

    token sep  { \x[1f] }

    token str { <-[\x[1f]]>+ }

    method value(@opts, %res) {
        my $opt = do given self.MATCH<opt> {
            with   .<name>  { @opts.first: *<name>.&[eq](.Str)       }
            orwith .<shortname> { @opts.first: *<shortname>.&[eq](.Str)  }
        };

        my $cursor := self.'!cursor_init'(self.orig(), :p(self.pos));
        my $new-cursor;
        if $opt<match> -> $match {
            $new-cursor := try $match.($cursor);
        } else {
            my $type = $opt<type> || 'str';
            $new-cursor := $cursor."$type"();
        }

        if $! and $opt<optional> {
            /<?>/.($cursor)
        } elsif $new-cursor.MATCH -> $match {
            %res{$opt<name>} = $match.ast // $match.Str;
            $new-cursor;
        } else {
            self.bogus("Invalid value for option {$opt<name>}");
        }
    }

    token bool {
        [<?after '='>
         $<bool>=[
             || ['false'|'true'|'0'|'1' | ''] <?before <.sep>>
             || $<bogus('Invalid value true/false value')>
         ]
        ]?
        {
            $/.make: do given $<bool> {
                when !.defined  { True  }
                when 'true'|'1' { True  }
                default         { False }
            }
        }
    }

    method gen-usage {
        join '', flat do for |%.opts<opts> {
            "  ",
            ("-$_ " with .<shortname>),
            ("--{.<name>}"),
            (
                with .<value-desc> {
                    "$_"
                } elsif .<type>.defined and .<type> ne 'bool' {
                    "={.<type>}"
                } elsif .<match> {
                    "={.<match>.gist}"
                } else {
                    ''
                }
            ),
            (
                with .<doc> {
                    "\n    $_\n",
                }
            )
        }
    }

    method get-opts($args = @*ARGS, :%opts = %.opts, :$*command) {
        my $str = $args.join("\x[1f]");
        my &*gen-usage = { self.gen-usage };
        self.parse($str,args => \(%opts)).ast;
    }
}
