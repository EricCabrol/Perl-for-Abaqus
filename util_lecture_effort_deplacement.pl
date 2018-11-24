#!C:\Perl\bin
#
# Cette moulinette lit un .dat Abaqus pour tracer la composante donnée de l'effort de réaction RF 
# d'un noeud donné en fonction de son déplacement, afin de tracer des courbes effort-déplacement
# sous Excel. 
# Attention : 
# - dans le fichier de sortie RF est écrit avant U ...
# - cette moulinette suppose qu'un seul noeud est post-traité
#
#
# E. Cabrol
# 13/10/2009
#
#
# LIGNES A MODIFIER
#
$noeud=215472;
$composante=3;
#
#
# nom du fichier à lire
#
open(fic,"44r2.dat");
open(fic2,">courbe_eff_depl.txt");
#
# NE RIEN MODIFIER CI-DESSOUS (... sauf si ça plante ...)
#
#
@tab=<fic>;
$num_ligne=0;
#
foreach $ligne (@tab) {
   $num_ligne++;	
   if ($ligne=~/\s+NODE.+RF1\s+RF2/) {
	$tmp1=$ligne;
	for ($i=1;$i<17;$i++) {
#		print fic2 $tab[$num_ligne+$i],"\n";
		if ($tab[$num_ligne+$i] =~/^ +$noeud/) {
#			print "oui\n";
			@tmp2=split(/\s+/,$tab[$num_ligne+$i]);
			print fic2 $tmp2[$composante+1]," ";
		}
	}
   }	
   if ($ligne=~/\s+NODE.+U1\s+U2/) {
	$tmp1=$ligne;
	for ($i=1;$i<17;$i++) {
		if ($tab[$num_ligne+$i] =~/^ +$noeud/) {
			@tmp2=split(/\s+/,$tab[$num_ligne+$i]);
			print fic2 $tmp2[$composante+1],"\n";
		}
	}
   }
}
