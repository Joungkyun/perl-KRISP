# $Id: 02-search.t,v 1.1 2010-07-03 19:57:55 oops Exp $

BEGIN { unshift(@INC, "./blib/arch/auto/KRISP") }
use lib './lib';
#use Test::More 'no_plan';
use Test::More tests => 4;
use strict;
use KRISP;

my $kr = new KRISP;
isa_ok ($kr, 'KRISP');

my $err = '';
my $db;
$db = $kr->open ('', $err);
ok (defined $db, 'connect the krisp database');

my $isp = $kr->search ($db, '192.168.1.100', $err);
ok (defined $isp, 'test search method');

$isp = $kr->search_ex ($db, '192.168.1.100', 'krisp', $err);
ok (defined $isp, 'test search_ex method');

$kr->close ($db);

__END__
