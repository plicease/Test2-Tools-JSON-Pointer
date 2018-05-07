package Test2::Tools::JSON::Pointer;

use strict;
use warnings;
use utf8;
use 5.008001;
use JSON::MaybeXS qw( JSON );
use Test2::Compare::JSON::Pointer;
use parent 'Exporter';

our @EXPORT = qw( json );

# ABSTRACT: Compare parts of JSON string to data structure using JSON pointers VERSION
# VERSION

=head1 SYNOPSIS

 use utf8;
 use Test2::V0;
 use Test2::Tools::JSON::Pointer;
 
 is(
   '{"a":"龍"}',
   json '/a' => "龍",
 );
 
 is(
   '{"a":[1,2,3],"b":{"x":"y"}',
   json '/a' => [1,2,3],
 );
 
 is(
   '{"a":[1,2,3],"b":{"x":"y"}',
   json '/b' => hash {
     field 'x' => 'y';
   },
 );
 
 done_testing;

=head1 DESCRIPTION

This module provides a comparison for a JSON string with a JSON pointer.  This
module was inspired by L<Test::Mojo>, which provides a mechanism for checking
the JSON response from a HTTP header.  This module provides a generic way to
write tests for JSON using a JSON pointer with or without the context of an
HTTP header.  It also has a L<Test2::Suite> style interface.

This module expects a Perl string in Perl's internal representation (utf-8),
NOT raw encoded bytes.  Thus if you are reading files they need to be read
in with the appropriate encoding.  If you are testing against the content
of a L<HTTP::Response> object you want to use C<decoded_content>.

=head1 FUNCTIONS

=head2 json

 is(
   $json_string,
   json($pointer, $check)
 );
 is(
   $json_string,
   json($check),
 );

Compare the C<$json_string> to the given L<Test2::Suite> C<$check> after
decoding the string into a deep reference (array or hash) and starting
at the position of the given C<$pointer>.

=cut

sub json ($;$)
{
  my($pointer, $json) = @_ == 1 ? ('', $_[0]) : (@_);
  my @caller = caller;
  Test2::Compare::JSON::Pointer->new(
    file    => $caller[1],
    lines   => [$caller[2]],
    input   => $json,
    pointer => $pointer,
    json    => JSON->new->utf8,
  );
}

1;

=head1 SEE ALSO

=over 4

=item L<Test2::Tools::JSON>

Provides a similar check without JSON pointers.

=item L<Test::Deep::JSON>

Provides a similar check in a L<Test::Deep> context.

=item L<Test::Mojo>

Among many other capabilities, this great testing library allows you to make checks against JSON on
an HTTP response object with JSON pointers.

=back

=cut
