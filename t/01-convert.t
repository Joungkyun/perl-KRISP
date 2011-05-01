# $Id$

BEGIN { unshift(@INC, "./blib/arch/auto/KRISP") }
use lib './lib';
#use Test::More 'no_plan';
use Test::More tests => 14;
use strict;
use KRISP;

my $ipv4 = '192.168.1.100';
my $longip = KRISP::ip2long ($ipv4);

ok ($longip, "Convert IPv4 address to long address");
cmp_ok ($longip, '==', 3232235876, "Convert address is 3232235876");

$longip = '3232235876';
$ipv4 = KRISP::long2ip ($longip);

ok ($ipv4, 'Convert long address to IPv4 address');
cmp_ok ($ipv4, 'eq', '192.168.1.100', 'Converted address is 192.168.1.100');

my $start = '192.168.1.13';
my $end   = '192.168.1.100';
my $mask  = KRISP::netmask ($start, $end);

ok ($mask, "Get netmask include between $start and $end");
cmp_ok ($mask, 'eq', '255.255.255.128', 'check netmask 255.255.255.128');

my $network = KRISP::network ($start, $mask);
my $broadcast = KRISP::broadcast ($start, $mask);

ok ($network, "Get netowrk include between $start and $end");
cmp_ok ($network, 'eq', '192.168.1.0', 'check network 192.168.1.0');
ok ($broadcast, "Get broadcast include between $start and $end");
cmp_ok ($broadcast, 'eq', '192.168.1.127', 'check broadcast 192.168.1.127');

$mask = '255.255.255.224';
my $prefix = KRISP::mask2prefix ($mask);

ok ($prefix, "convert prefix from $mask");
cmp_ok ($prefix, '==', 27, "Prefix of $mask is 27");

$prefix = 27;
$mask = KRISP::prefix2mask ($prefix);

ok ($mask, "convert netmask from $prefix");
cmp_ok ($mask, 'eq', '255.255.255.224', "Netmask of $prefix is 255.255.255.224");

__END__
