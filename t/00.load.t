use Test::More tests => 19;

BEGIN {
use_ok( 'Getopt::Param::Tiny' );
}

diag( "Testing Getopt::Param::Tiny $Getopt::Param::Tiny::VERSION" );

my @cst = qw(
    --alone
    --empty-equals=
    --equals-string=foo
    --multi=1
    --multi=2
    --multi=3
    invalid
);

push @cst, '--equals-phrase=foo bar baz'; # its called like this: --equals-phrase="foo bar baz"
    
my $par = Getopt::Param::Tiny->new({
    'array_ref' => \@cst,
    'quiet'     => 1, # Gauranteed a 'Argument 6 did not match (?-xism:^--)'
});

my $inc;
{ 
    local @ARGV = @cst;
    $inc = Getopt::Param::Tiny->new({ 'quiet' => 1 });
}

my %val = (
    'alone'         => '--alone',
    'empty-equals'  => '', 
    'equals-string' => 'foo',
    'equals-phrase' => 'foo bar baz',
);

my %tst = (
    '1' => ' - from array_ref key in new()',
    '2' => ' - from @ARGV',
);

my $prm = 1;

    my $scalar = $par->param('multi');
    ok($scalar eq '1', 'scalar context' . $tst{ $prm });

    my $array = join ',', sort $par->param('multi');
    ok($array eq '1,2,3', 'array context' . $tst{ $prm });

    my $keys = join ',', sort $par->param();

    ok($keys eq 'alone,empty-equals,equals-phrase,equals-string,multi', 'no args' . $tst{ $prm });
    
    $par->param('new', 1,2,3);
    my $new = join ',', sort $par->param('new');
    ok($new eq '1,2,3', 'new param' . $tst{ $prm });

    $par->param('new', 'n1', 'n2');
    my $edit = join ',', sort $par->param('new');
    ok($edit eq 'n1,n2', 'update param' . $tst{ $prm });

    for my $key ( sort keys %val ){
        ok($par->param($key) eq $val{ $key }, "proper value: $key");
    }

{    
my $prm = 2;

    my $scalar = $inc->param('multi');
    ok($scalar eq '1', 'scalar context' . $tst{ $prm });

    my $array = join ',', sort $inc->param('multi');
    ok($array eq '1,2,3', 'array context' . $tst{ $prm });

    my $keys = join ',', sort $inc->param();
    ok($keys eq 'alone,empty-equals,equals-phrase,equals-string,multi', 'no args' . $tst{ $prm });

    $inc->param('new', 1,2,3);
    my $new = join ',', sort $inc->param('new');
    ok($new eq '1,2,3', 'new param' . $tst{ $prm });

    $inc->param('new', 'n1', 'n2');
    my $edit = join ',', sort $inc->param('new');
    ok($edit eq 'n1,n2', 'update param' . $tst{ $prm });

    for my $key ( sort keys %val ){
        ok($inc->param($key) eq $val{ $key }, "proper value: $key" . $tst{ $prm });
    }   
}