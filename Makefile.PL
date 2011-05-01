# $Id$

use 5.008008;
use ExtUtils::MakeMaker;

my @SEARCHPATHS = (
	"/bin", "/sbin",
	"/usr/bin", "/usr/sbin",
	"/usr/local/bin", "/usr/local/sbin",
	"/usr/local/krisp/bin", "/usr/local/libkrisp/bin"
);

my $krispconfig;

foreach my $i (@SEARCHPATHS) {
	if ( -f "$i/krisp-config" ) {
		$krispconfig = "$i/krisp-config";
		last;
	}
}

if ( $krispconfig eq "" ) {
	printf "ERROR: krisp-config is not found\n";
	exit (1);
}

my $library = `$krispconfig --libs`;
#my $library = '-lkrisp';
my $cputype = `uname -m`;
my $ostype  = `uname -s`;
my $define = '';
my $inc = '';
my $optimize = 2;
my $march = '';

$library = `$krispconfig --link-ld 2> /dev/null`;
if ( ! $library ) {
	$library = `$krispconfig --libs 2> /dev/null`;
	$library = '-lkrisp' if ( ! $library );
}

$inc = `$krispconfig --includes 2> /dev/null`;
$define = `$krispconfig --defs 2> /dev/null`;


chomp ($library);
chomp ($inc);
chomp ($cputype);
chomp ($ostype);
$march = "-march=$cputype" if ( $cputype ne "x86_64" );

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'KRISP',
	DISTNAME          => 'KRISP',
	OPTIMIZE          => "-O$optimize $march",
    VERSION_FROM      => 'lib/KRISP.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/KRISP.pm', # retrieve abstract from module
       AUTHOR         => 'JoungKyun.Kim <http://oops.org>') : ()),
	TYPEMAPS          => ['map/typemap'],
    LIBS              => ["$library"], # e.g., '-lm'
    DEFINE            => "$define", # e.g., '-DHAVE_SOMETHING'
    INC               => "-I. $inc", # e.g., '-I. -I/usr/include/other'
	dist              => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);

# Local variables:
# tab-width: 4
# c-basic-offset: 4
# End:
# vim600: noet sw=4 ts=4 fdm=marker
# vim<600: noet sw=4 ts=4
