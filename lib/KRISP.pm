package KRISP;

#
# $Id: KRISP.pm,v 1.1 2010-07-03 19:57:55 oops Exp $
#
# Local variables:
# tab-width: 4
# c-basic-offset: 4
# End:
# vim600: noet sw=4 ts=4 fdm=marker
# vim<600: noet sw=4 ts=4

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use KRISP ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( );

our $VERSION = '2.0.0';
my $revision = '$Id: KRISP.pm,v 1.1 2010-07-03 19:57:55 oops Exp $';

require XSLoader;
XSLoader::load('KRISP', $VERSION);

# Preloaded methods go here.

# ------- FUNCTION WRAPPERS --------
#*mod_version = *KRISPc::mod_version;
#*mod_uversion = *KRISPc::mod_uversion;
#*version = *KRISPc::version;
#*uversion = *KRISPc::uversion;
#*open = *KRISPc::open;
#*search = *KRISPc::search;
#*search_ex = *KRISPc::search_ex;
#*close = *KRISPc::close;
#*ip2long = *KRISPc::ip2long;
#*long2ip = *KRISPc::long2ip;
#*netmask = *KRISPc::netmask;
#*network = *KRISPc::network;
#*broadcast = *KRISPc::broadcast;
#*prefix2mask = *KRISPc::prefix2mask;
#*mask2prefix = *KRISPc::mask2prefix;

# ------- Objects --------

sub new {
	my $self = {};
	return bless $self;
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

KRISP - Perl extension for blah blah blah

=head1 SYNOPSIS

  use KRISP;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for KRISP, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

root, E<lt>root@localdomainE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by root

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
