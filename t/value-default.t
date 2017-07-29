use Test;
use GetOpt::Parse;

plan 3;


{
    my @opts = (
        opt(
            :name<vdefault>,
            :alias<a>,
            :match<str>,
            :value-default<foo>
        ),
    );

    my $parser = GetOpt::Parse.new(:@opts, command => 'goof');

    is-deeply $parser.get-opts(), {};
    is-deeply $parser.get-opts(<-a>), { :vdefault<foo> };
    is-deeply $parser.get-opts(<-a bar>), { :vdefault<bar> };
}
