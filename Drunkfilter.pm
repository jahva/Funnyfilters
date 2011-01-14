## Drunkfilter 1.0 (2009-01-18)
##
## Simple filter for turning all text look like written in drunk
##
## Author: Jari Jaanto (jaffa)
## Email: jari.jaanto@gmail.com
## License: GNU Gpl v3

package Drunkfilter;

use strict;
use Switch;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw{Exporter AutoLoader};
@EXPORT = qw{

};

$VERSION = '1';

# CONFIG POSSIBILITIES

my $dup = '5';  # % possibility to duplicate current char
my $non = '1';  # % possibility to char missing
my $mis = '25'; # % possibility to press neighbor char + current
my $wro = '10'; # % possibility to press neighbor char
my $shi = '1';  # % possibility to shift on / off

my $keyb = '§1234567890+´qwertyuiopå¨asdfghjklöä\'<zxcvbnm,.-"';
my $x = 1;
my $y = 12;

sub near_char {
	my $pos = index($keyb, $_);
	my $i = 0;
	do {
		my $r = int(rand(5)); 
		if ($r == 0) { $i = $x - $y; } 
		if ($r == 1) { $i = -$x - $y; } 
		if ($r == 2) { $i = $x; } 
		if ($r == 3) { $i = -$x; } 
		if ($r == 4) { $i = -$y; } 
	} while ($pos + $i < 0 && $pos + $i > length($keyb));
	my $near = substr($keyb, $pos+$i, 1);
	return $near;
}

sub filter {
	my $in = $_[0];
	my $out = '';
	my $shift = 0;
	my @in_arr = split('', $in); 
	my $cur = '';

	foreach (@in_arr) {
		if ($_ ne ' ' && index($keyb, $_) > -1) {
			my $i = 0;
			my $r = int(rand(100));
			if ($r >= 0 && $r < 5) 
			{ 
				$cur = ($_ . $_); 
			} 
			elsif ($r >= 6 && $r < 7) 
			{ 
				# nop 
			} 
			elsif ($r >= 7 && $r < 12) 
			{ 
				$cur = ($_ . near_char($_)); 
			} 
			elsif ($r >= 12 && $r < 17) 
			{ 
				$cur = (near_char($_)); 
			} 
			else 
			{ 
				$cur = $_; 
			}
		} else {
			$cur = $_;
		}
		if (rand(10) <= 1) {
			$shift = abs($shift-1); 
		}
		if ($shift) { 
			$cur = uc($cur); 
		}
		$out .= $cur;
	}
	return $out;
}

