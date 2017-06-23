use Terminal::ANSIColor;

sub apply-markers($orig, @markers) {
    my @orig = $orig.comb;
    for @markers -> (:$before, :$after, :$from is copy, :$to is copy, :$match) {
        if $before {
            @orig[$from] = $before ~ @orig[$from];
        }

        if $after {
            @orig[$to] ~= $after
        }

    }
    @orig.join;
}

class GetOpt::Grammar::X is Exception is rw {
    has Match:D $.match is required;
    has $.message;

    method gist {
        my $str = apply-markers($match.orig, self.markers);
        "$.message\n$str"
    }

    method markers {
        ${ :before(color('red')), }
    }

}
