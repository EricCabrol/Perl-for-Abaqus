#!/bin/perl
#
# Theme : lois de comportement elasto-plastiques
#
# Objectif : convertir une serie de couples 
# (contrainte - deformation plastique) d'un input Abaqus
# en une carte TABLES1 (deformation totale, contrainte) Nastran _valide_
#
# Pourquoi ? Parce que Nastran ne tolère pas que la pente de la courbe
# sigma = f(epsilon) soit momentanément croissante, il est nécessaire
# de filtrer la serie de données pour retirer les points qui posent 
# problème
# 
# Entree : fichier .txt contenant la serie de donnees Abaqus
# ex.
# 290.,0.
# 314.5713302,0.002622739
# 318.1609699,0.003355792
# 321.97691,0.004222314
# 325.7860331,0.005174843
# 329.0511938,0.006059546
# etc ...
#
# Sortie : fichier tables.txt
#
# (E. Cabrol - Medysys - Avril 2004)
#
print "nom du fichier .txt ?\n";
$nom = <STDIN>;
chop($nom);
print "Module d'Young du materiau ?\n";
$Young = <STDIN>;
chop($Young);
#
open(fic,"$nom");
open (fic2,">tables.txt");
#
# On ecrit la premiere ligne, ainsi que la premiere paire de données qui
# doit passer par l'origine :
# 
print fic2 ("TABLES1,1,,,,,,,,,\n,0.,0.,");
#
$k=1; # compteur pour passage a la ligne
$j=0; # compteur global
$oldYoung=1.e+15; # initialisation module d'Young pour passer le premier if
$oldEps=0.; # initialisation deformation
$oldSig=0.; # initialisation contrainte
#
while (<fic>) {
  $j++;
  @a = split(/,/,$_);
# on calcule la pente de la courbe sigma = f(epsilon total)
  $module = ($a[0]-$oldSig)/($a[1]+$a[0]/$Young-$oldEps);
# si la pente decroit c'est OK
  if (($module-$oldYoung)<0) {
    $k++;
    printf fic2 ("%8f,%8.4f,",$a[1]+$a[0]/$Young,$a[0]);
    if ($k==4) {
       print fic2 ("\n,");
       $k=0;
    }
  }
# sinon on ne traite pas ... et on le dit
  else {
    print "Suppression ligne ",$j,"\n";
  }
  $oldYoung=$module;
  $oldEps=$a[1]+$a[0]/$Young;
  $oldSig=$a[0];
}
print fic2 ("ENDT");
close(fic);
close(fic2);
