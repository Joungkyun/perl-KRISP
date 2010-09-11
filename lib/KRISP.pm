package KRISP;

# Local variables:
# tab-width: 4
# c-basic-offset: 4
# End:
# vim600: noet sw=4 ts=4 fdm=marker
# vim<600: noet sw=4 ts=4

use 5.008008;
use strict;
use warnings;

use constant false => 0;
use constant true  => 1;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );

our $VERSION = '2.1.0';
my $revision = '$Id: KRISP.pm,v 1.7 2010-09-11 09:29:06 oops Exp $';

require XSLoader;
XSLoader::load('KRISP', $VERSION);

# Preloaded methods go here.

# ------- Objects --------

=head1 NAME

KRISP - Perl extension for libkrisp

=head1 SYNOPSIS

    use KRISP;
    my $kr = new KRISP;

    # network convert
    my $start = '192.168.1.3';
    my $end   = '192.168.1.100';

    my $longip    = $kr->ip2long ($start);
    my $ipv4      = $kr->long2ip ($longip);
    my $netmask   = $kr->netmask ($start, $end);
    my $network   = $kr->network ($start, $mask);
    my $broadcast = $kr->broadcast ($start, $mask);
    my $prefix    = $kr->mask2prefix ($mask);
    my $mask      = $kr->prefix2mask ($prefix);

    # search isp/nation information
    my $err;
    my $db = $kr->open ('', $err);
    $kr->set_debug ($db, KRISP::true);
    my $isp = $kr->search ($db, 'some.domain.name', $err);
    my $isp_ex = $kr->search_ex ($db, 'some.domain.name', 'krisp', $err);
    $kr->close ($db);

=head1 DESCRIPTION

KRISP provides network cacluration and searching isp/nation
information for given ip address.

=head1 Constructor

=head2 new KRISP

Returns a new KRISP object.

=cut

sub new {
	my $self = {};
	return bless $self;
}


1;
__END__

=head1 Methods

=head2 $kr->mod_version ()

Returns version of this modules.

=head2 $kr->mod_uversion ()

Returns numeric version of this modules.

=head2 $kr->version ()

Returns version of libkrisp that linked.

=head2 $kr->mod_uversion ()

Returns numeric version of libkrisp that linked.

=head2 $kr->ip2long ($ipv4_address)

Caculates unsigned long value about given IPv4 address.

=over 4

=item ipv4_address

IPv4 address

=back

=head2 $kr->long2ip ($long_ip)

Caculates IPv4 address about given unsigend long address.

=over 4

=item long_ip

Unsigned long ip address

=back

=head2 $kr->netmask ($start, $end);

Caculates network mask that give range between $start and $end.

=over 4

=item start

First IPv4 address of Range

=item end

Last IPv4 address of Range

=back

=head2 $kr->mask2prefix ($mask);

Caculates network prefix about given network mask.

=over 4

=item mask

Network mask address

=back

=head2 $kr->prefix2mask ($prefix);

Caculates network mask about given network prefix.

=over 4

=item prefix

Network prefix

=back

=head2 $kr->network ($ipv4, $mask);

Caculates network address about given IP address and network mask.

=over 4

=item $ipv4

IPv4 address

=item $mask

Network mask

=back

=head2 $kr->broadcast ($ipv4, $mask);

Caculates broadcast address about given IP address and network mask.

=over 4

=item $ipv4

IPv4 address

=item $mask

Network mask

=back

=head2 $kr->open ([$database[, $error]]);

Open the krisp database handle.

=over 4

=item database (optional)

Specifies krisp database file path. If don't given this value,
libkrisp is excutes by default value that set libkrisp compile
times.

=item error (optional)

Set this variable, if occures error on open method, allocates
error messages on this variable.

=back

=head2 $kr->search ($open_handle, $host[, $error]);

Returns network information about given host that includes
netowork informations, nation informations and isp informations.

=over 4

=item open_handle

Return value of open method.

=item host

Searching host

=item error (optional)

Set this variable, if occures error on open method, allocates
error messages on this variable.

=back

=head2 $kr->search_ex ($open_handle, $host, $table[, $error]);

If you want to search your table taht makes by you in krisp database,
you can use this method.

Search on given table and returns network information about given
host that includes netowork informations, nation informations and
isp informations.

=over 4

=item open_handle

Return value of open method.

=item host

Searching host

=item table

Searching table on krisp database

=item error (optional)

Set this variable, if occures error on open method, allocates
error messages on this variable.

=back

=head2 $kr->close ($open_handle);

Closes krisp database handle.

=over 4

=item open_handle

Return value of open method.

=back

=head2 $kr->set_debug ($open_handle, $boolean)

Print libkrisp debug messages to standard out.

=over 4

=item open_handle

Return value of open method.

=item boolean (optional)

Default value is KRISP::true (1). Set KRISP::true or 1, search
method is printed debug messages to standard out. If you want to
no debug messages, set KRISP::false or 0.

If this method has not been called, Default value will be meaningless.

=back

=head2 $kr->set_mtime_interval ($open_handle, $seconds)

From libkrisp 3.1.0, libkrisp is periodically to detect database
changes. If libkrisp detects database changes, internally to close
database and will open database again.

libkrip checks change of database per 3600 seconds.
This method is enabled to change check-peroid of database.

=over 4

=item open_handle

Return value of open method.

=item seconds

Peroid of database check. If you set 0, libkrisp don't check changes
of database.

=back

=head1 AUTHOR

JoungKyun.Kim , E<lt>admin@oops.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by JoungKyun.Kim

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published
by the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU LESSER GENERAL PUBLIC LICENSE for more details.

You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
along with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


=cut
