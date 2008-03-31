package Getopt::Param::Tiny;

$VERSION = 0.3;

sub new {
    my ($self, $arg_ref) = @_;
    $self = bless {}, $self;
    
    $arg_ref->{'quiet'}  ||= 0;
    $arg_ref->{'strict'} ||= 0;
     
    my $args_ar         = ref $arg_ref->{'array_ref'} ne 'ARRAY' ? \@ARGV : $arg_ref->{'array_ref'};
    my @nodestruct      = @{ $args_ar };
    
    $self->{'opts'} = {};
    
    my $idx = 0;
    for my $arg ( @nodestruct ) {

        my $rg = $arg_ref->{'strict'} ? qr{^--([^-])} : qr{^--(.)};
        
        if( $arg =~ s/$rg/$1/ ) {
            my($flag, $value) = split /=/, $arg, 2;
            push @{ $self->{'opts'}{ $flag } }, defined $value ? $value : '--' . $flag;
        }
        else {
            warn( sprintf('Argument %s did not match %s', $idx, $rg) ) if !$arg_ref->{'quiet'};
        }
        $idx++;
    }
    
    if( $self->{'opts'}{'help'} && $arg_ref->{'help_coderef'} ) {
         $arg_ref->{'help_coderef'}->();
    }
    
    return $self;
}

sub param {
    my ($self, $name, @val) = @_;
    return wantarray ? keys %{ $self->{'opts'} } : [ keys %{ $self->{'opts'} } ] if !$name;
    $self->{'opts'}{$name} = \@val if @val;
    return wantarray ? @{ $self->{'opts'}{$name} } : $self->{'opts'}{$name}->[0];    
}

1; 

__END__

=head1 NAME

Getopt::Param::Tiny - Subset of Getopt::Param functionality with smaller memory footprint

=head1 VERSION

This document describes Getopt::Param::Tiny version 0.3

=head1 SYNOPSIS

    use Getopt::Param::Tiny;
    my $prm = Getopt::Param::Tiny->new();
    print "Starting..." if $prm->param('verbose');

=head1 DESCRIPTION

Like L<Getopt::Param> but using a simple hash based object instead of L<Class::Std>, no 
localization for single error message, and only supplying the single, flexible, param() method.

=head1 INTERFACE 

=head2 new()

Same use as L<Getopt::Param>'s new.

=head2 param()

Same use as L<Getopt::Param>'s param.

=head1 DIAGNOSTICS

See L<Getopt::Param>'s DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

Getopt::Param::Tiny requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-getopt-param-tiny@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Daniel Muey  C<< <http://drmuey.com/cpan_contact.pl> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Daniel Muey C<< <http://drmuey.com/cpan_contact.pl> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.