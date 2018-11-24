#!/net/bin/perl
# 
# Calcul du couple maxi transmissible à l'interface moyeu-disque
# 
# Inputs :
# - coordonnées du point K pour déterminer la distance de chaque
#   noeud esclave à l'axe de rotation de la roue
# - coefficient de frottement moyeu-disque
# - fichier tmp.dat au format nastran contenant les noeuds (et leurs 
#   coordonnées !) de la surface du moyeu
# - efforts nodaux de contact issus du calcul de serrage abaqus
#   (pour obtenir des efforts il faut une surface,type=node)
#
# Output :
# - couple maxi transmissible sans glissement a l'interface moyeu-disque
#
# E. Cabrol 
# 01/10/2007
# (cf. evolutions en fin de fichier)
#
#
print "Nom du fichier de geometrie ?\n(défaut = tmp_5d1.dat)\n";
$file1=<STDIN>;
if (length($file1)>1) {
	chop $file1;}
else {
	$file1="tmp_5d1.dat";}
#
#
print "Nom du fichier de forces de contact ?\n(défaut = data_cpress_5d2bt1.dat)\n";
$file2=<STDIN>;
if (length($file2)>1) {
	chop $file2;}
else {
	$file2="data_cpress_5d2bt1.dat";}
#
#
print "Coordonnees du point K ? \n(défaut : -55.33,-770.84,150.30)\n";
$ptK=<STDIN>;
if (length($ptK)>1) {
	chop $ptK;}
else {
	$ptK="-55.33,-770.84,150.30";}
@ptK=split(/,/,$ptK);
#
#
print "Coefficient de frottement pour le calcul du couple de freinage\n";
$frict=<STDIN>;
chop $frict;
#
# CALCUL DES DISTANCES A L'AXE DE ROUE
#
open(fic1,"$file1")||die("ouverture fichier geometrie impossible\n");
while(<fic1>) {
	if ($_ =~ /^GRID/) {
		$lab = substr($_,8,8)+0;
		$x{$lab}=substr($_,24,8)+0;
#		$y{$lab}=substr($_,32,8)+0;
		$z{$lab}=substr($_,40,8)+0;
	}
}
foreach $noeud (keys(%x)) {
	$dist{$noeud}=sqrt(($x{$noeud}-$ptK[0])**2+($z{$noeud}-$ptK[2])**2);
	$dist_moy+=$dist{$noeud};
	$kk+=1;
}
close(fic1);
#
# LECTURE DES EFFORTS DE CONTACT ET CALCUL DU COUPLE DE FREINAGE
#
open(fic2,"$file2")||die("ouverture fichier de resultats impossible\n");
while(<fic2>) {
	$id=substr($_,4,10)+0;
	$press{$id}=substr($_,20,5)+0;
	$couple=$couple+$press{$id}*$dist{$id}*$frict;
}
close(fic2);
#
print "\nCouple maxi transmissible sans glissement moyeu/disque= ",int($couple/1000)," N.m\n\n";
#
# Afficher un message si la distance moyenne semble anormale
if (abs($dist_moy/$kk-50)>10) {
	print "Attention, la distance moyenne entre les noeuds en contact \net l'axe de roue est de ",int($dist_moy/$kk)," mm. ";
	print "Vérifiez que cela est normal.\n\n";
}
#
#
#
#
# Evolutions
#
# 01/10/2007 : ajout des inputs par défaut
