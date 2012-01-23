/*
 * $Id$
 *
 * Local variables:
 * tab-width: 4
 * c-basic-offset: 4
 * End:
 * vim600: noet sw=4 ts=4 fdm=marker
 * vim<600: noet sw=4 ts=4
 */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "version.h"
#include <krisp.h>


short chkSvRV (short items, short min, short max, SV * sv, char * proto) {
	char	msg[1024] = { 0, };
	short	res = 0;

	sprintf (msg, "Usage: KRISP::%s", proto);

	if ( SvROK (sv) ) {
		if ( ! sv_derived_from (sv, "KR_APIPtr") ) {
			res++;
			min++;
			max++;
		}
	}

	//printf ("######### %d : %d : %d : %d\n", items, res, min, max);

	if ( items > max || items < min )
		Perl_croak (aTHX_ msg);

	return res;
}


MODULE = KRISP		PACKAGE = KRISP

char *
mod_version (...)
	CODE:
		chkSvRV (items, 0, 0, ST(0), "mod_version ()");
		RETVAL = MODVER;
	OUTPUT:
		RETVAL

char *
mod_uversion (...)
	CODE:
		chkSvRV (items, 0, 0, ST(0), "mod_uversion ()");
		RETVAL = MODUVER;
	OUTPUT:
		RETVAL

char *
version (...)
	CODE:
		chkSvRV (items, 0, 0, ST(0), "version ()");
		RETVAL = krisp_version ();
	OUTPUT:
		RETVAL

char *
uversion (...)
	CODE:
		chkSvRV (items, 0, 0, ST(0), "uversion ()");
		RETVAL = krisp_uversion ();
	OUTPUT:
		RETVAL

unsigned int
ip2long (...)
	PREINIT:
		char *	addr;
		short	argno = 0;

	CODE:
		if ( chkSvRV (items, 1, 1, ST(0), "ip2long (addr)") )
			argno++;
		addr = (char *) SvPV_nolen (ST(argno));
		RETVAL = ip2long (addr);

	OUTPUT:
		RETVAL

char *
long2ip (...)
	PREINIT:
		ulong	laddr;
		char *	ip;
		char	sip[16] = { 0, };
		short	argno = 0;

	CODE:
		if ( chkSvRV (items, 1, 1, ST(0), "long2ip (long_ip)") )
			argno++;
		laddr = (ulong) SvUV (ST(argno));
		long2ip_r (laddr, sip);
		RETVAL = sip;

	OUTPUT:
		RETVAL

char *
netmask (...)
	PREINIT:
		char *	start;
		char *	end;
		ulong	lstart;
		ulong	lend;
		char	mask[16] = { 0, };
		short	argno = 0;

	CODE:
		if ( chkSvRV (items, 2, 2, ST(0), "netmask (start, end)") )
			argno++;
		start = (char *) SvPV_nolen (ST(argno));
		end   = (char *) SvPV_nolen (ST(argno + 1));

		lstart = ip2long (start);
		lend   = ip2long (end);
		long2ip_r (guess_netmask (lstart, lend), mask);
		RETVAL = mask;

	OUTPUT:
		RETVAL

short
mask2prefix (...)
	PREINIT:
		char *	mask;
		ulong	lmask;
		short	prefix;
		short	argno = 0;

	CODE:
		if ( chkSvRV (items, 1, 1, ST(0), "mask2prefix (mask)") )
			argno++;
		mask = (char *) SvPV_nolen (ST(argno));
		lmask = ip2long (mask);
		RETVAL = long2prefix (lmask);

	OUTPUT:
		RETVAL

char *
prefix2mask (...)
	PREINIT:
		short	prefix;
		char	mask[16] = { 0, };
		short	argno = 0;

	CODE:
		if ( chkSvRV (items, 1, 1, ST(0), "prefix2mask (prefix)") )
			argno++;
		prefix = (short) SvIV (ST(argno));
		long2ip_r (prefix2long (prefix), mask);
		RETVAL = mask;

	OUTPUT:
		RETVAL

char *
network (...)
	PREINIT:
		char *	ip;
		char *	mask;
		ulong	lip;
		ulong	lmask;
		char	net[16] = { 0, };
		short	argno = 0;

	CODE:
		if ( chkSvRV (items, 2, 2, ST(0), "network (ip, mask)") )
			argno++;
		ip = (char *) SvPV (ST(argno), PL_na);
		mask = (char *) SvPV (ST(argno + 1), PL_na);

		lip = ip2long (ip);
		lmask = ip2long (mask);
		long2ip_r (network (lip, lmask), net);
		RETVAL = net;

	OUTPUT:
		RETVAL

char *
broadcast (...)
	PREINIT:
		char *	ip;
		char *	mask;
		ulong	lip;
		ulong	lmask;
		char	net[16] = { 0, };
		short	argno = 0;

	CODE:
		if ( chkSvRV (items, 2, 2, ST(0), "network (ip, mask)") )
			argno++;
		ip = (char *) SvPV (ST(argno), PL_na);
		mask = (char *) SvPV (ST(argno + 1), PL_na);

		lip = ip2long (ip);
		lmask = ip2long (mask);
		long2ip_r (broadcast (lip, lmask), net);
		RETVAL = net;

	OUTPUT:
		RETVAL


KR_API *
open (...)
	PREINIT:
		char *	database = NULL;
		char	err[1024];
		short	argno = 0;
		
	CODE:
		if ( chkSvRV (items, 0, 2, ST(0), "database (dbpath[, error])") )
			argno++;

		if ( items > (argno + 1) ) {
			database = (char *) SvPV_nolen (ST(argno));
			if ( ! strlen (database) )
				database = NULL;
		}

		if ( kr_open_safe (&RETVAL, database, err) == false ) {
			if ( items == (argno + 2) )
				sv_setpv (ST(argno + 1), (char *) err);
			XSRETURN_UNDEF;
		}

	OUTPUT:
		RETVAL

HV *
search (...)
	PREINIT:
		KR_API *	db;
		char *		host;
		KRNET_API	isp;
		HV *		hv;
		char		ip_t[16];
		ulong		net;
		ulong		broad;
		short		argno = 0;

	PPCODE:
		if ( chkSvRV (items, 2, 3, ST(0), "search (db, host[, error])") )
			argno++;

		if ( sv_derived_from (ST(argno), "KR_APIPtr") ) {
			IV tmp = SvIV ((SV *) SvRV (ST(argno)));
			db = INT2PTR (KR_API *, tmp);
		} else
			Perl_croak(aTHX_ "KRISP::Search : first argument is not of type KR_APIPtr");

		host = (char *) SvPV_nolen (ST(argno + 1));

		SAFECPY_256 (isp.ip, host);
		isp.verbose = db->verbose;
		if ( kr_search (&isp, db) != 0 ) {
			if ( items == (3 + argno) )
				sv_setpv (ST(argno + 2), (char *) isp.err);
			XSRETURN_UNDEF;
		}

		net   = network (isp.start, isp.netmask);
		broad = broadcast (isp.start, isp.netmask);

		hv = newHV ();

		hv_store (hv, "ip", 2, newSVpv (isp.ip, 0), 0);
		hv_store (hv, "start", 5, newSVpv (long2ip_r (isp.start, ip_t), 0), 0);
		hv_store (hv, "end", 3, newSVpv (long2ip_r (isp.end, ip_t), 0), 0);
		hv_store (hv, "netmask", 7, newSVpv (long2ip_r (isp.netmask, ip_t), 0), 0);
		hv_store (hv, "network", 7, newSVpv (long2ip_r (net, ip_t), 0), 0);
		hv_store (hv, "broadcast", 9, newSVpv (long2ip_r (broad, ip_t), 0), 0);
		hv_store (hv, "icode", 5, newSVpv (isp.icode, 0), 0);
		hv_store (hv, "iname", 5, newSVpv (isp.iname, 0), 0);
		hv_store (hv, "ccode", 5, newSVpv (isp.ccode, 0), 0);
		hv_store (hv, "cname", 5, newSVpv (isp.cname, 0), 0);

		XPUSHs (sv_2mortal (newRV_noinc ((SV *) hv)));

HV *
search_ex (...)
	PREINIT:
		KR_API *		db;
		char *			host;
		char *			table;
		KRNET_API_EX *	isp;
		HV *			hv;
		AV *			av;
		char			ip_t[16];
		ulong			netmask;
		ulong			net;
		ulong			broad;
		short			argno = 0;
		char **			dummy;

	PPCODE:
		if ( chkSvRV (items, 3, 4, ST(0), "search (db, host[, error])") )
			argno++;

		if ( sv_derived_from (ST(argno), "KR_APIPtr") ) {
			IV tmp = SvIV ((SV *) SvRV (ST(argno)));
			db = INT2PTR (KR_API *, tmp);
		} else
			Perl_croak(aTHX_ "KRISP::search_ex : first argument is not of type KR_APIPtr");

		host = (char *) SvPV_nolen (ST(argno + 1));
		table = (char *) SvPV_nolen (ST(argno + 2));

		if ( (isp = (KRNET_API_EX *) malloc (sizeof (KRNET_API_EX))) == NULL ) {
			if ( items == (3 + argno) )
				sv_setpv (
					ST(argno + 3),
					(char *) "KRISP::search_ex : memory allocation error"
				);
			XSRETURN_UNDEF;
		}

		SAFECPY_256 (isp->ip, host);
		db->table = table;
		isp->verbose = db->verbose;
		if ( kr_search_ex (isp, db) != 0 ) {
			if ( items == (3 + argno) )
				sv_setpv (ST(argno + 3), (char *) isp->err);
			XSRETURN_UNDEF;
		}

		netmask = guess_netmask (isp->start, isp->end);
		net     = network (isp->start, netmask);
		broad   = broadcast (isp->start, netmask);

		hv = newHV ();

		hv_store (hv, "ip", 2, newSVpv (isp->ip, 0), 0);
		hv_store (hv, "start", 5, newSVpv (long2ip_r (isp->start, ip_t), 0), 0);
		hv_store (hv, "end", 3, newSVpv (long2ip_r (isp->end, ip_t), 0), 0);
		hv_store (hv, "netmask", 7, newSVpv (long2ip_r (netmask, ip_t), 0), 0);
		hv_store (hv, "network", 7, newSVpv (long2ip_r (net, ip_t), 0), 0);
		hv_store (hv, "broadcast", 9, newSVpv (long2ip_r (broad, ip_t), 0), 0);

		av = newAV ();

		//if ( isp->dummydata != NULL) {
		if ( isp->size > 0 ) {
			isp->size = 0;
			dummy = isp->dummy;
			while ( *dummy != NULL ) {
				av_push (av, newSVpv (*dummy, 0));
				isp->size++;
				*dummy++;
			}
		}
		hv_store (hv, "size", 4, newSViv (isp->size), 0);
		hv_store (hv, "dummy", 5, newRV_noinc ((SV *) av), 0);

		XPUSHs (sv_2mortal (newRV_noinc ((SV *) hv)));

		initStruct_ex (isp, true);
		free (isp);

void
close (...)
	PREINIT:
		KR_API *	db;
		short		argno = 0;

	PPCODE:
		if ( chkSvRV (items, 1, 1, ST(0), "KRISP::close(db)") )
			argno++;

		if ( sv_derived_from (ST(argno), "KR_APIPtr") ) {
			IV tmp = SvIV ((SV *) SvRV (ST(argno)));
			db = INT2PTR (KR_API *,tmp);
		} else
			Perl_croak (aTHX_ "KRISP::close : first argument is not of type KR_APIPtr");

		kr_close (&db);

void
set_debug (...)
	PREINIT:
		KR_API *	db;
		bool		set = true;
		short		argno = 0;

	PPCODE:
		if ( chkSvRV (items, 1, 2, ST(0), "set_debug (db[, boolean = true])") )
			argno++;

		if ( sv_derived_from (ST(argno), "KR_APIPtr") ) {
			IV tmp = SvIV ((SV *) SvRV (ST(argno)));
			db = INT2PTR (KR_API *,tmp);
		} else
			Perl_croak (aTHX_ "KRISP::set_debug : first argument is not of type KR_APIPtr");

		if ( items == (argno + 2) )
			set = (short) SvIV (ST(argno + 1));

		db->verbose = set;

void
set_mtime_interval (...)
	PREINIT:
		KR_API *	db;
		time_t		sec = 0;
		short		argno = 0;

	PPCODE:
		if ( chkSvRV (items, 2, 2, ST(0), "set_mtime_interval (db, sec)") )
			argno++;

		if ( sv_derived_from (ST(argno), "KR_APIPtr") ) {
			IV tmp = SvIV ((SV *) SvRV (ST(argno)));
			db = INT2PTR (KR_API *,tmp);
		} else
			Perl_croak (aTHX_ "KRISP::set_mtime_interval : first argument is not of type KR_APIPtr");

		sec = (short) SvIV (ST(argno + 1));

		db->db_time_stamp_interval = sec;


