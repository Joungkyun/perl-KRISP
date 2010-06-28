# This file was created automatically by SWIG 1.3.29.
# Don't modify this file, modify the SWIG interface instead.
package KRISP;
require Exporter;
require DynaLoader;
@ISA = qw(Exporter DynaLoader);
package KRISPc;
bootstrap KRISP;
package KRISP;
@EXPORT = qw( );
use strict;

my $revsion = '$Id: KRISP.pm,v 1.8 2010-06-28 19:37:17 oops Exp $';

# ---------- BASE METHODS -------------

package KRISP;

sub TIEHASH {
    my ($classname,$obj) = @_;
    return bless $obj, $classname;
}

sub CLEAR { }

sub FIRSTKEY { }

sub NEXTKEY { }

sub FETCH {
    my ($self,$field) = @_;
    my $member_func = "swig_${field}_get";
    $self->$member_func();
}

sub STORE {
    my ($self,$field,$newval) = @_;
    my $member_func = "swig_${field}_set";
    $self->$member_func($newval);
}

sub this {
    my $ptr = shift;
    return tied(%$ptr);
}


# ------- FUNCTION WRAPPERS --------

package KRISP;

#*version = *KRISPc::version;
#*uversion = *KRISPc::uversion;
#*kopen = *KRISPc::kopen;
#*search = *KRISPc::search;
#*search_ex = *KRISPc::search_ex;
#*free_search = *KRISPc::free_search;
#*free_search_ex = *KRISPc::free_search_ex;
#*kclose = *KRISPc::kclose;
#*kip2long = *KRISPc::kip2long;
#*knetmask = *KRISPc::knetmask;
#*knetwork = *KRISPc::knetwork;
#*kbroadcast = *KRISPc::kbroadcast;
#*kprefix2long = *KRISPc::kprefix2long;
#*klong2prefix = *KRISPc::klong2prefix;

# -- joungkyun modificate $Id: KRISP.pm,v 1.8 2010-06-28 19:37:17 oops Exp $ --
our $VERSION = '2.0.0';
our $UVERSION = '002000000';

my @KRISP_SEARCH_EX_KEY = (
	'ip', 'start', 'end', 'size', 'dummydata'
);

sub new {
	my $self = {};
	return bless $self;
}

sub mod_version {
	my $self = shift if ref ($_[0]);
	return $VERSION;
}

sub mod_uversion {
	my $self = shift if ref ($_[0]);
	return $UVERSION;
}

sub version {
	my $self = shift if ref ($_[0]);
	return KRISPc::version ();
}

sub uversion {
	my $self = shift if ref ($_[0]);
	return KRISPc::uversion ();
}

sub ip2long {
	my $self = shift if ref ($_[0]);
	my ($ipaddr) = @_;

	return KRISPc::kip2long ($ipaddr);
}

sub long2ip {
	my $self = shift if ref ($_[0]);
	my ($longip) = @_;

	my @ip = qw ( 0, 0, 0, 0 );
	my $i;

	for ( $i=3; $i>=0; $i-- ) {
		$ip[$i] = $longip % 256;
		$longip /= 256
	}

	return join '.' , @ip;
}

sub netmask {
	my $self = shift if ref ($_[0]);
	my ($start, $end) = @_;

	my $lstart = KRISPc::kip2long ($start);
	my $lend   = KRISPc::kip2long ($end);

	my $mask = KRISPc::knetmask ($lstart, $lend);

	return KRISP::long2ip ($mask);
}

sub mask2prefix {
	my $self = shift if ref ($_[0]);
	my ($mask) = @_;

	my $lmask = KRISPc::kip2long ($mask);
	return KRISPc::klong2prefix ($lmask);
}

sub prefix2mask {
	my $self = shift if ref ($_[0]);
	my ($prefix) = @_;

	my $lmask = KRISPc::kprefix2long ($prefix);
	return KRISP::long2ip ($lmask);
}

sub network {
	my $self = shift if ref ($_[0]);
	my ($ip, $mask) = @_;

	my $lip = KRISPc::kip2long ($ip);
	my $lmask = KRISPc::kip2long ($mask);

	return KRISP::long2ip (KRISPc::knetwork ($lip, $lmask));
}

sub broadcast {
	my $self = shift if ref ($_[0]);
	my ($ip, $mask) = @_;

	my $lip = KRISPc::kip2long ($ip);
	my $lmask = KRISPc::kip2long ($mask);

	return KRISP::long2ip (KRISPc::kbroadcast ($lip, $lmask));
}

sub open {
	my $self = shift if ref ($_[0]);
	my ($database, $err) = @_;

	return KRISPc::kopen ($database);
}

sub close {
	my $self = shift if ref ($_[0]);
	my ($handle) = @_;

	return KRISPc::kclose ($handle);
}

sub search_key {
	my $self = shift if ref ($_[0]);

	return qw (
		ip netmask start end icode iname ccode cname network broadcast
	);
}

sub search {
	my $self = shift if ref ($_[0]);
	my ($dbh, $host) = @_;
	my $v = undef;

	my $r = KRISPc::search ($dbh, $host);
	if ( $r->{'err'} ) {
		$_[2] = sprintf "kr_search:: %s", $r->{'err'};
		return undef;
	}

	foreach my $k (KRISP::search_key ()) {
		if ( $k eq 'netmask' or $k eq 'start' or $k eq 'end' ) {
			$v->{$k} = KRISP::long2ip ($r->{$k});
		} else {
			next if ( $k eq 'network' or $k eq 'broadcast' );
			$v->{$k} = $r->{$k};
		}
	}

	$v->{'network'} = KRISP::long2ip (KRISPc::knetwork ($r->{'start'}, $r->{'netmask'}));
	$v->{'broadcast'} = KRISP::long2ip (KRISPc::kbroadcast ($r->{'start'}, $r->{'netmask'}));

	#$v->{'ip'} = $r->swig_ip_get ();
	#$v->{'netmask'} = KRISP::long2ip ($r->swig_netmask_get ());
	#$v->{'network'} = KRISP::long2ip (KRISPc::knetwork ($r->swig_start_get (), $r->swig_netmask_get ()));
	#$v->{'broadcast'} = KRISP::long2ip (KRISPc::kbroadcast ($r->swig_start_get (), $r->swig_netmask_get ()));
	#$v->{'start'} = KRISP::long2ip ($r->swig_start_get ());
	#$v->{'end'} = KRISP::long2ip ($r->swig_end_get ());
	#$v->{'icode'} = $r->swig_icode_get ();
	#$v->{'iname'} = $r->swig_iname_get ();
	#$v->{'ccode'} = $r->swig_ccode_get ();
	#$v->{'cname'} = $r->swig_cname_get ();

	KRISPc::free_search ($r);

	return $v;
}

sub search_key_ex {
	my $self = shift if ref ($_[0]);
	return qw (ip start end size dummy);
}

sub search_ex {
	my $self = shift if ref ($_[0]);
	my ($dbh, $host, $table) = @_;
	my $v = undef;

	my $r = KRISPc::search_ex ($dbh, $host, $table);
	if ( $r->{'err'} ) {
		$_[3] = sprintf "kr_search_ex:: %s", $r->{'err'};
		return undef;
	}

	$v->{'ip'} = $r->{'ip'};
	$v->{'start'} = KRISP::long2ip ($r->{'start'});
	$v->{'end'} = KRISP::long2ip ($r->{'end'});
	$v->{'size'} = $r->{'size'};

	my @p = split ':', $r->{'dummydata'};
	my $i;
	for ( $i=0; $i<@p; $i++ ) {
		$v->{'dummy'}[$i] = $p[$i];
	}

	KRISPc::free_search_ex ($r);

	return $v;
}
# -- joungkyun modificate --

############# Class : KRISP::KRNET_API ##############

package KRISP::KRNET_API;
use vars qw(@ISA %OWNER %ITERATORS %BLESSEDMEMBERS);
@ISA = qw( KRISP );
%OWNER = ();
%ITERATORS = ();
*swig_err_get = *KRISPc::KRNET_API_err_get;
*swig_err_set = *KRISPc::KRNET_API_err_set;
*swig_ip_get = *KRISPc::KRNET_API_ip_get;
*swig_ip_set = *KRISPc::KRNET_API_ip_set;
*swig_icode_get = *KRISPc::KRNET_API_icode_get;
*swig_icode_set = *KRISPc::KRNET_API_icode_set;
*swig_iname_get = *KRISPc::KRNET_API_iname_get;
*swig_iname_set = *KRISPc::KRNET_API_iname_set;
*swig_cname_get = *KRISPc::KRNET_API_cname_get;
*swig_cname_set = *KRISPc::KRNET_API_cname_set;
*swig_ccode_get = *KRISPc::KRNET_API_ccode_get;
*swig_ccode_set = *KRISPc::KRNET_API_ccode_set;
*swig_netmask_get = *KRISPc::KRNET_API_netmask_get;
*swig_netmask_set = *KRISPc::KRNET_API_netmask_set;
*swig_start_get = *KRISPc::KRNET_API_start_get;
*swig_start_set = *KRISPc::KRNET_API_start_set;
*swig_end_get = *KRISPc::KRNET_API_end_get;
*swig_end_set = *KRISPc::KRNET_API_end_set;
*swig_verbose_get = *KRISPc::KRNET_API_verbose_get;
*swig_verbose_set = *KRISPc::KRNET_API_verbose_set;
sub new {
    my $pkg = shift;
    my $self = KRISPc::new_KRNET_API(@_);
    bless $self, $pkg if defined($self);
}

sub DESTROY {
    return unless $_[0]->isa('HASH');
    my $self = tied(%{$_[0]});
    return unless defined $self;
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        KRISPc::delete_KRNET_API($self);
        delete $OWNER{$self};
    }
}

sub DISOWN {
    my $self = shift;
    my $ptr = tied(%$self);
    delete $OWNER{$ptr};
}

sub ACQUIRE {
    my $self = shift;
    my $ptr = tied(%$self);
    $OWNER{$ptr} = 1;
}


############# Class : KRISP::KRNET_API_EX ##############

package KRISP::KRNET_API_EX;
use vars qw(@ISA %OWNER %ITERATORS %BLESSEDMEMBERS);
@ISA = qw( KRISP );
%OWNER = ();
%ITERATORS = ();
*swig_err_get = *KRISPc::KRNET_API_EX_err_get;
*swig_err_set = *KRISPc::KRNET_API_EX_err_set;
*swig_ip_get = *KRISPc::KRNET_API_EX_ip_get;
*swig_ip_set = *KRISPc::KRNET_API_EX_ip_set;
*swig_dummy_get = *KRISPc::KRNET_API_EX_dummy_get;
*swig_dummy_set = *KRISPc::KRNET_API_EX_dummy_set;
*swig_dummydata_get = *KRISPc::KRNET_API_EX_dummydata_get;
*swig_dummydata_set = *KRISPc::KRNET_API_EX_dummydata_set;
*swig_start_get = *KRISPc::KRNET_API_EX_start_get;
*swig_start_set = *KRISPc::KRNET_API_EX_start_set;
*swig_end_get = *KRISPc::KRNET_API_EX_end_get;
*swig_end_set = *KRISPc::KRNET_API_EX_end_set;
*swig_verbose_get = *KRISPc::KRNET_API_EX_verbose_get;
*swig_verbose_set = *KRISPc::KRNET_API_EX_verbose_set;
*swig_size_get = *KRISPc::KRNET_API_EX_size_get;
*swig_size_set = *KRISPc::KRNET_API_EX_size_set;
sub new {
    my $pkg = shift;
    my $self = KRISPc::new_KRNET_API_EX(@_);
    bless $self, $pkg if defined($self);
}

sub DESTROY {
    return unless $_[0]->isa('HASH');
    my $self = tied(%{$_[0]});
    return unless defined $self;
    delete $ITERATORS{$self};
    if (exists $OWNER{$self}) {
        KRISPc::delete_KRNET_API_EX($self);
        delete $OWNER{$self};
    }
}

sub DISOWN {
    my $self = shift;
    my $ptr = tied(%$self);
    delete $OWNER{$ptr};
}

sub ACQUIRE {
    my $self = shift;
    my $ptr = tied(%$self);
    $OWNER{$ptr} = 1;
}


# ------- VARIABLE STUBS --------

package KRISP;

1;
