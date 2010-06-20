# File: Makefile.PL
# $Id: Makefile.PL,v 1.2 2010-06-20 18:33:36 oops Exp $

use ExtUtils::MakeMaker;

my @ppd;

my @SEARCHPATHS = ("/bin", "/sbin",
				"/usr/bin", "/usr/sbin",
				"/usr/local/bin", "/usr/local/sbin",
				"/usr/local/krisp/bin", "/usr/local/libkrisp/bin");

my $krispconfig;

foreach my $i (@SEARCHPATHS) {
	if ( -f "$i/krisp-config" ) {
		$krispconfig = "$i/krisp-config";
		break;
	}
}

if ( $krispconfig eq "" ) {
	printf "ERROR: krisp-config is not found\n";
	exit (1);
}

my $library = `$krispconfig --libs`;
my $cputype = `uname -m`;
my $ostype  = `uname -s`;
my $define  = "";
my $optimize;

if ( $library =~ /sqlite3/ ) {
	$define = "-DHAVE_LIBSQLITE3";
}

if ( $ostype == "Linux" ) {
	$optimize = "3";
} else {
	$optimize = "2";
}

if ($] >= 5.00503) {
	@ppd = (
		AUTHOR    => 'JoungKyun Kim <admin @AT@ oops.org>',
		ABSTRACT  => 'Korea ISP library perl module'
	);
}

WriteMakefile(
	NAME         => 'KRISP',
	DISTNAME     => 'KRISP',
	OPTIMIZE     => "-O$optimize -march=$cputype",
	VERSION_FROM => 'KRISP.pm',
	DEFINE       => "$define",
	LIBS         => ["$library"],
	OBJECT       => 'krisp.o krisp_wrap.o',
	dist         => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	@ppd
);
