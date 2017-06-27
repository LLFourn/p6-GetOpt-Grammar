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

    method gist {
        my $str = apply-markers($!match.orig.subst("\x[1f]"," ", :g), self.markers);
        "$.message\n$str"
    }

    method markers {
        ${ :before(color('on_red')) , :after(reset), :$!match},
    }

}
