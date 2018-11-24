#!/bin/perl
#
print "Coefficients de la loi crash (S = S_el + k.e^n):\n";
print "Limite élastique S_e(en MPa) ?\n";
$S_el = <STDIN>;
chomp($S_el);
print "Coefficient k ?\n";
$k = <STDIN>;
chomp($k);
print "Exposant n ?\n";
$n = <STDIN>;
chomp($n);
print "Contrainte max ?\n";
$S_m=<STDIN>;
chomp($S_m);
open(fic,">loi.txt");
printf fic ("%.2f,%.3f\n",$S_el,0.);
$e=0.;
do {
	$e+=0.005;
	$s = $S_el + $k*$e**$n;
	printf fic ("%.2f,%.3f\n",$s,$e);
} while ($s < $S_m)
