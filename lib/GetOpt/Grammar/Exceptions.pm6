use Terminal::ANSIColor;

constant reset = RESET;

sub apply-markers($orig, @markers) {
    my @orig = $orig.comb;
    for @markers -> (:$before, :$after, :$from is copy, :$to is copy, :$match) {
        $from //= $match.from;
        $to   //= $match.to;
        if $before {
            @orig[$from] = $before ~ @orig[$from];
        }

        if $after {
            @orig[$to-1] ~= $after
        }

    }
    @orig.join;
}

class GetOpt::Grammar::X is Exception is rw {
    has Match:D $.match is required;
    has $.message;
    has $.command;
    has $.usage;

    method gist {
        my $command-line =
          ($.command andthen "$_ ") ~
          ~ apply-markers($!match.orig.subst("\x[1f]"," ", :g), self.markers);

        "$.message\n$command-line" ~ ($.usage andthen "\n$_")
    }

    method markers {
        ${ :before(color('on_red')) , :after(reset), :$!match},
    }

}

class GetOpt::Grammar::X::Missing is GetOpt::Grammar::X {
    has $.hint;
    has $.option;
    has $.type;

    method message {
        "Missing $!type argument for $!option";
    }
    method markers {
        ${ :after(colored("$.hint↩","green")), :$.match }
    }
}
