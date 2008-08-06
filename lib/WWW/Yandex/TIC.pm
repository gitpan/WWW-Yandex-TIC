package WWW::Yandex::TIC;

# -*- perl -*-

use strict;
use warnings;

use vars qw($VERSION);

use LWP::UserAgent;

$VERSION = '0.04';

my $regexps = [
	qr|(?is)<p class="errmsg">.*?<b>[^<]+? &#151; (\d+)|,
	qr|(?is)<p class="errmsg">.*?<b>[^<]+? 1(\d+).|, # zero -)
	qr|(?is)<tr valign="top"[^<]+<td class="current".+?\/td>[^<]+(?:<td .+?\/td>[^<]+){2}?<td\D+(\d+)|,
];

sub new {
	my $class = shift;
	my %par = @_;
	my $self;

	$self->{ua} = LWP::UserAgent->new(agent => $par{agent} || 'Bond, James Bond/0.07') or return;
	$self->{ua}->proxy('http', $par{proxy}) if $par{proxy};
	bless($self, $class);
}

sub get {
	my ($self, $domain) = @_;
	return unless defined $domain;

	my $resp = $self->{ua}->get(sprintf('http://search.yaca.yandex.ru/yca/cy/ch/%s/', $domain));
	my $tic = undef;

	if ($resp->is_success) {
		foreach my $rx (@$regexps) {
			if ($resp->content =~ /$rx/) {
				$tic = $1;
				last;
			}
		}
	}

	if (wantarray) {
		return ($tic, $resp);
	}
	else {
		return $tic;
	}
}

1;


__END__

=head1 NAME

WWW::Yandex::TIC - Query Yandex Thematic Index of Citing (TIC) for domain

=head1 SYNOPSIS

 use WWW::Yandex::TIC;
 my $ytic = WWW::Yandex::TIC;
 print $ytic->get('www.yandex.ru'), "\n";

=head1 DESCRIPTION

The C<WWW::Yandex::TIC> is a class implementing a interface for
querying Yandex Thematic Index of Citing (TIC) for domain.

To use it, you should create C<WWW::Yandex::TIC> object and use its
method get(), to query TIC for domain.

It uses C<LWP::UserAgent> for making request to Google.

=head1 CONSTRUCTOR METHOD

=over 4

=item  $tic = WWW::Yandex::TIC->new(%options);

This method constructs a new C<WWW::Yandex::TIC> object and returns it.
Key/value pair arguments may be provided to set up the initial state.
The following options is correspond to attribute methods described below:

   KEY                     DEFAULT
   -----------             --------------------
   agent                   "Bond, James Bond/0.07"
   proxy                   undef

C<agent> specifies the header 'User-Agent' when querying Yandex.  If
the C<proxy> option is passed in, requests will be made through
specified proxy. 

=back

=head1 QUERY METHOD

=over 4

=item  $tic = $ytic->get('www.yandex.ru');

Queries Yandex for a specified Yandex Thematic Index of Citing (TIC) for domain and returns TIC. If
query successfull, integer value from 0 to over 0 returned. If query fails
for some reason (Yandex unreachable, domain does not in Yandex catalog) it return C<undef>.

In list context this function returns list from two elements where
first is the result as in scalar context and the second is the
C<HTTP::Response> object (returned by C<LWP::UserAgent::get>). This
can be usefull for debugging purposes and for querying failure
details.

=back

=head1 BUGS

If you find any, please report ;)

=head1 AUTHOR

Dmitry Bashlov F<E<lt>bashlov@cpan.orgE<gt>> http://bashlov.ru.
Ivan Baktsheev F<E<lt>dot.and.thing@gmail.comE<gt>>.


=head1 COPYRIGHT

Copyright 2005, Dmitry Bashlov,
Copyright 2008, Ivan Baktsheev

You may use, modify, and distribute this package under the
same terms as Perl itself.
