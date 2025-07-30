
*************************************************************************************
ssc install fre

* Arthur 
if "`c(username)'" == "a.reutler" {
	global dropbox "XXXXXX"

}

* Camille bureau * A Contacter
if "`c(username)'" == "c.hemet" {
	global dropbox "C:\Users\c.hemet\Nextcloud\PNRU_vote_Arthur\"
}

* Nina Maison: 
if "`c(username)'" == "ninag" {
	global dropbox "A CHANGER"
}

* Nina Bis : 
if "`c(username)'" == "nguyon" {
	global dropbox "A CHANGER"
}


* Location of the stata datasets created and used for the project: 
global output "${dropbox}Analyse/output/"

*************************************************************************************

**************************************************************************************
* 1. Import Base des Préfectures
**************************************************************************************

clear
import excel "${dropbox}A Contacter/Préfectures_à_appeler_Priorite1", sheet("Prefectures") firstrow case(lower)

rename deppréfecture dep

*Checks la base
bys dep : assert _N==1 //Ok

rename mailenvoyé0non1oui mail_envoye_pref
rename statut1toutestbon2rés statut_pref
rename dateenvoi1ermail date_envoi_pref
rename datede1èreréponse date_reponse_pref
rename emailsderéponsedelapréfe emails_reponse_pref
rename dateduderniercontactouéchan date_dernier_contact_pref
rename presid_881sidonnéespourto pref_presid_88
rename presid_951sidonnéespourto pref_presid_95
rename municip_891sidonnéespourt pref_municip_89
rename municip_951sidonnéespourt pref_municip_95
rename municip_011sidonnéespourt pref_municip_01
rename si2listecommunesmanquante presid_liste_communes_manquantes
rename w muni_liste_communes_manquantes
rename cartes_881listedesadresse pref_cartes_88
rename cartes_89 pref_cartes_89
rename cartes_95 pref_cartes_95
rename cartes_01 pref_cartes_01
rename cartes_02 pref_cartes_02
rename cartes_post_02 pref_cartes_post_02
rename informationscollectéesdétail infos_collectees_pref
rename listedesdocumentsenvoyés docs_envoyés_pref
rename cotesmunicipales2001 pref_cotes_municip_01
rename cotesmunicipales1995 pref_cotes_municip_95
rename cotesmunicipales1989 pref_cotes_municip_89
rename cotespr1995 pref_cotes_presid_95
rename cotespr1988 pref_cotes_presid_88
rename cotesdécoupageélectoral pref_cotes_decoupage_electoral
rename prixapproximatifpourunbillet prix_billet


fre statut_pref 

/* 
Variables Présidentielles
*/

fre pref_presid_88 

*Présidentielles 88

// Créer la variable "pref_presid_88_toutes" prenant la valeur 1 si "pref_presid_88" est égal à 1, sinon 0
gen pref_presid_88_toutes = (pref_presid_88 == 1)
label variable pref_presid_88_toutes "Données élections présidentielles 1988 dispos pour toutes les communes"

// Créer la variable "pref_presid_88_certaines" prenant la valeur 1 si "pref_presid_88" est égal à 2, sinon 0
gen pref_presid_88_certaines = (pref_presid_88 == 2)
label variable pref_presid_88_certaines "Données élections présidentielles 1988 dispos pour certaines communes"

*Présidentielles 95

gen pref_presid_95_toutes = (pref_presid_95 == 1)
label variable pref_presid_95_toutes "Données élections présidentielles 1995 dispos pour toutes les communes"
gen pref_presid_95_certaines = (pref_presid_95 == 2)
label variable pref_presid_95_certaines "Données élections présidentielles 1995 dispos pour certaines communes"

/*
drop pref_presid88
drop pref_presid95
*/

/* 
Variables Municipales
*/

*Municipales 89

gen pref_municip_89_toutes = (pref_municip_89 == 1)
label variable pref_municip_89_toutes "Données pour toutes les communes dispos en 1989"
gen pref_municip_89_certaines = (pref_municip_89 == 2)
label variable pref_municip_89_certaines "Données pour certaines communes en 1989"

*Municipales 95

gen pref_municip_95_toutes = (pref_municip_95 == 1)
label variable pref_municip_95_toutes "Données pour toutes les communes dispos en 1995"
gen pref_municip_95_certaines = (pref_municip_95 == 2)
label variable pref_municip_95_certaines "Données pour certaines communes en 1995"

*Municipales 2001

gen pref_municip_01_toutes = (pref_municip_01 == 1)
label variable pref_municip_01_toutes "Données pour toutes les communes dispos en 2001"
gen pref_municip_01_certaines = (pref_municip_01 == 2)
label variable pref_municip_01_certaines "Données pour certaines communes en 2001"



*drop pref_municip_89
*drop pref_municip_95
*drop pref_municip_01


/* 
Variables Carto

Jessica : Je fais en variables à choix multiples parce que si je divise il y aura beaucoup trop de variables
*/


// Étiquettes pour pref_cartes_88
label value pref_cartes_88 pref_cartes_88_label
label def pref_cartes_88_label 1 "Cartographie ou Liste des adresses disponibles" ///
                           2 "Localisation des bureaux de vote" ///
                           3 "Données non disponibles"

						   
// Étiquettes pour pref_cartes_89
label value pref_cartes_89 pref_cartes_89_label
label def pref_cartes_89_label 1 "Cartographie ou Liste des adresses disponibles" ///
                           2 "Localisation des bureaux de vote" ///
                           3 "Données non disponibles"
						   
// Étiquettes pour pref_cartes_95
label value pref_cartes_95 pref_cartes_95_label
label def pref_cartes_95_label 1 "Cartographie ou Liste des adresses disponibles" ///
                           2 "Localisation des bureaux de vote" ///
                           3 "Données non disponibles"
						   
						   
// Étiquettes pour pref_cartes_01
label value pref_cartes_01 pref_cartes_01_label
label def pref_cartes_01_label 1 "Cartographie ou Liste des adresses disponibles" ///
                           2 "Localisation des bureaux de vote" ///
                           3 "Données non disponibles"
						   

// Étiquettes pour pref_cartes_02
label value pref_cartes_02 pref_cartes_02_label
label def pref_cartes_02_label 1 "Cartographie ou Liste des adresses disponibles" ///
                           2 "Localisation des bureaux de vote" ///
                           3 "Données non disponibles"					   

						   
// Étiquettes pour pref_cartes_post_02
label value pref_cartes_post_02 pref_cartes_post_02_label
label def pref_cartes_post_02_label 1 "Cartographie ou Liste des adresses disponibles" ///
                           2 "Localisation des bureaux de vote" ///
                           3 "Données non disponibles"					   






label var reg "Région de la commune"
label var regold "Ancienne région de la commune"
label var libdep "Nom du département"
label var dep "Code du département"
label var nb_com "Nombre de commune dans le département"

label var presid_liste_communes_manquantes "Liste des communes n'ayant pas de données pour les élections présidentielles"
label var muni_liste_communes_manquantes "Liste des communes n'ayant pas de données pour les élections municipales"


// Attribuer des étiquettes aux valeurs de la variable "statut_pref"

fre statut_pref 

ta statut_pref, m

label value statut_pref statut_pref_label
label def statut_pref_label 1 "Toutes les données sont disponibles à savoir les résultats des élections et l'emplacement des BdV" 2 "Résultats élections tous dispos mais pas de cartes des BdV" 3 "Données partielles dispos" 4 "Pas de réponse/à relancer" 5 "Pas données disponibles"


*order pref*, after(statut_pref)

*keep reg regold dep libdep nb_com pop99_dep nb_qru_dep nb_znqru_dep pref* statut_pref

sort dep

*br if statut_pref==1

save "${output}synthese_data_prefectures.dta", replace



/*********************************************************
1.1 Stat desc données Préfectures
*/*******************************************************

*fre pref_presid_88

fre pref_presid_88_toutes pref_presid_95_toutes

/*

pref_presid_88_toutes -- Données élections présidentielles 1988 dispos pour toutes les commu
> nes
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         36      40.45      40.45      40.45
        1     |         53      59.55      59.55     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------

pref_presid_95_toutes -- Données élections présidentielles 1995 dispos pour toutes les commu
> nes
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         38      42.70      42.70      42.70
        1     |         51      57.30      57.30     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------



*/

fre pref_presid_88_certaines pref_presid_95_certaines

/*

pref_presid_88_certaines -- Données élections présidentielles 1988 dispos pour certaines com
> munes
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         88      98.88      98.88      98.88
        1     |          1       1.12       1.12     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------

pref_presid_95_certaines -- Données élections présidentielles 1995 dispos pour certaines com
> munes
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         88      98.88      98.88      98.88
        1     |          1       1.12       1.12     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------
*/



fre pref_municip_89_toutes pref_municip_95_toutes pref_municip_01_toutes

/* 

pref_municip_89_toutes -- Données pour toutes les communes dispos en 1989
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         38      42.70      42.70      42.70
        1     |         51      57.30      57.30     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------

pref_municip_95_toutes -- Données pour toutes les communes dispos en 1995
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         40      44.94      44.94      44.94
        1     |         49      55.06      55.06     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------

pref_municip_01_toutes -- Données pour toutes les communes dispos en 2001
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         46      51.69      51.69      51.69
        1     |         43      48.31      48.31     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------

*/

fre pref_municip_89_certaines pref_municip_95_certaines pref_municip_01_certaines


/*

pref_municip_89_certaines -- Données pour certaines communes en 1989
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         87      97.75      97.75      97.75
        1     |          2       2.25       2.25     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------

pref_municip_95_certaines -- Données pour certaines communes en 1995
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         86      96.63      96.63      96.63
        1     |          3       3.37       3.37     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------

pref_municip_01_certaines -- Données pour certaines communes en 2001
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |         87      97.75      97.75      97.75
        1     |          2       2.25       2.25     100.00
        Total |         89     100.00     100.00           
-----------------------------------------------------------

*/



fre pref_cartes*

/*

pref_cartes_88 -- Cartes_88 : 1. si fichier excel des adresses disponibles ; 2. si pas fichi
> er exc
-------------------------------------------------------------------------------------------
                                              |      Freq.    Percent      Valid       Cum.
----------------------------------------------+--------------------------------------------
Valid   0                                     |         48      53.93      84.21      84.21
        1 Fichier Excel ou liste des adresses |          1       1.12       1.75      85.96
          disponibles                         |                                            
        4 Localisation des bureaux de vote    |          8       8.99      14.04     100.00
        Total                                 |         57      64.04     100.00           
Missing .                                     |         32      35.96                      
Total                                         |         89     100.00                      
-------------------------------------------------------------------------------------------

pref_cartes_89 -- Cartes_89
-------------------------------------------------------------------------------------------
                                              |      Freq.    Percent      Valid       Cum.
----------------------------------------------+--------------------------------------------
Valid   0                                     |         48      53.93      82.76      82.76
        1 Fichier Excel ou liste des adresses |          1       1.12       1.72      84.48
          disponibles                         |                                            
        4 Localisation des bureaux de vote    |          9      10.11      15.52     100.00
        Total                                 |         58      65.17     100.00           
Missing .                                     |         31      34.83                      
Total                                         |         89     100.00                      
-------------------------------------------------------------------------------------------

pref_cartes_95 -- Cartes_95
-------------------------------------------------------------------------------------------
                                              |      Freq.    Percent      Valid       Cum.
----------------------------------------------+--------------------------------------------
Valid   0                                     |         47      52.81      81.03      81.03
        1 Fichier Excel ou liste des adresses |          1       1.12       1.72      82.76
          disponibles                         |                                            
        4 Localisation des bureaux de vote    |         10      11.24      17.24     100.00
        Total                                 |         58      65.17     100.00           
Missing .                                     |         31      34.83                      
Total                                         |         89     100.00                      
-------------------------------------------------------------------------------------------

pref_cartes_01 -- Cartes_01
-------------------------------------------------------------------------------------------
                                              |      Freq.    Percent      Valid       Cum.
----------------------------------------------+--------------------------------------------
Valid   0                                     |         45      50.56      77.59      77.59
        1 Fichier Excel ou liste des adresses |          1       1.12       1.72      79.31
          disponibles                         |                                            
        4 Localisation des bureaux de vote    |         12      13.48      20.69     100.00
        Total                                 |         58      65.17     100.00           
Missing .                                     |         31      34.83                      
Total                                         |         89     100.00                      
-------------------------------------------------------------------------------------------

pref_cartes_02 -- Cartes_02
-------------------------------------------------------------------------------------------
                                              |      Freq.    Percent      Valid       Cum.
----------------------------------------------+--------------------------------------------
Valid   0                                     |         47      52.81      81.03      81.03
        1 Fichier Excel ou liste des adresses |          1       1.12       1.72      82.76
          disponibles                         |                                            
        4 Localisation des bureaux de vote    |         10      11.24      17.24     100.00
        Total                                 |         58      65.17     100.00           
Missing .                                     |         31      34.83                      
Total                                         |         89     100.00                      
-------------------------------------------------------------------------------------------

pref_cartes_post_02 -- Cartes_post_02
-------------------------------------------------------------------------------------------
                                              |      Freq.    Percent      Valid       Cum.
----------------------------------------------+--------------------------------------------
Valid   0                                     |         45      50.56      78.95      78.95
        1 Fichier Excel ou liste des adresses |          1       1.12       1.75      80.70
          disponibles                         |                                            
        4 Localisation des bureaux de vote    |         11      12.36      19.30     100.00
        Total                                 |         57      64.04     100.00           
Missing .                                     |         32      35.96                      
Total                                         |         89     100.00                      
-------------------------------------------------------------------------------------------


*/





/*********************************************************************************
2. Import Base des Communes
*/*******************************************************************************

clear
import excel "${dropbox}A Contacter/Communes_à_appeler_Priorite1", sheet("Communes") firstrow case(lower)

bys com: assert _N==1


rename numérotél num_tel_com
rename mail mail_com
rename contactparmail0non1oui mail_envoye_com
rename dateenvoi1ermail date_envoi_com
rename datede1èreréponse date_reponse_com
rename emailsderéponseetemailssuiv emails_reponse_com
rename dateduderniercontactouéchan date_dernier_contact_com
rename statut1donnéesenvoyées2 statut_com
*rename si5dateàlaquellereconta date_recontacter_com
rename presid_881sidonnéesenvoyée com_presid_88
rename presid_951sidonnéesenvoyée com_presid_95
rename municip_891sidonnéesenvoyé com_municip_89
rename municip_951sidonnéesenvoyé com_municip_95
rename municip_011sidonnéesenvoyé com_municip_01
rename cartes_881sifichierexcel com_cartes_88
rename cartes_89 com_cartes_89
rename cartes_95 com_cartes_95
rename cartes_01 com_cartes_01
rename cartes_02 com_cartes_02
rename cartes_post_02 com_cartes_post_02
rename informationscollectéesdétail infos_collectees_com
rename listedesdocumentsenvoyésvi docs_envoyés_com
rename cotesmunicipales2001 com_cotes_municip_01
rename cotesmunicipales1995 com_cotes_municip_95
rename cotesmunicipales1989 com_cotes_municip_89
rename cotespr1995 com_cotes_presid_95
rename cotespr1988 com_cotes_presid_88
rename cotesdécoupageélectoral com_cotes_decoupage_electoral


/* 
Variables Présidentielles
*/

*Présidentielles 88

// Créer la variable "com_presid_88_envoyees" prenant la valeur 1 si "com_presid_88" est égal à 1, sinon 0
gen com_presid_88_envoyees = (com_presid_88 == 1)
label variable com_presid_88_envoyees "Données élections présidentielles 1988 envoyées"

// Créer la variable "com_presid_88_dispos" prenant la valeur 1 si "com_presid_88" est égal à 2, sinon 0
gen com_presid_88_dispos = (com_presid_88 == 2)
label variable com_presid_88_dispos "Données élections présidentielles 1988 dispos mais pas envoyées"

*Présidentielles 95

gen com_presid_95_envoyees = (com_presid_95 == 1)
label variable com_presid_95_envoyees "Données élections présidentielles 1995 envoyées"
gen com_presid_95_dispos = (com_presid_95 == 2)
label variable com_presid_95_dispos "Données élections présidentielles 1995 dispos mais pas envoyées"


*drop com_presid88
*drop com_presid95

/* 
Variables Municipales
*/

*Municipales 89


gen com_municip_89_envoyees = (com_municip_89 == 1)
label variable com_municip_89_envoyees "Données élections municipales 1989 envoyées"
gen com_municip_89_dispos = (com_municip_89 == 2)
label variable com_municip_89_dispos "Données élections municipales 1989 dispos mais pas envoyées"

*Municipales 95

gen com_municip_95_envoyees = (com_municip_95 == 1)
label variable com_municip_95_envoyees "Données élections municipales 1995 envoyées"
gen com_municip_95_dispos = (com_municip_95 == 2)
label variable com_municip_95_dispos "Données élections municipales 1995 dispos mais pas envoyées"

*Municipales 2001

gen com_municip_01_envoyees = (com_municip_01 == 1)
label variable com_municip_01_envoyees "Données élections municipales 2001 envoyées"

// Créer la variable "municip_01_2" prenant la valeur 1 si "municip_01" est égal à 2, sinon 0
gen com_municip_01_dispos = (com_municip_01 == 2)
label variable com_municip_01_dispos "Données élections municipales 2001 dispos mais pas envoyées"


/*
drop com_municip_89
drop com_municip_95
drop com_municip_01
*/


/* 
Variables Carto

Jessica : Je fais en variables à choix multiples parce que si je divise il y aura beaucoup trop de variables
*/


// Étiquettes pour com_cartes_88
label value com_cartes_88 com_cartes_88_label
label def com_cartes_88_label 1 "Fichier Excel ou liste des adresses disponibles" ///
                           2 "Pas de fichier Excel ou liste, mais cartes PDF" ///
                           3 "Fichier Excel ou liste des adresses + cartes PDF" ///
                           4 "Localisation des bureaux de vote" ///
                           5 "Données non disponibles"

						   
// Étiquettes pour com_cartes_89
label value com_cartes_89 com_cartes_89_label
label def com_cartes_89_label 1 "Fichier Excel ou liste des adresses disponibles" ///
                           2 "Pas de fichier Excel ou liste, mais cartes PDF" ///
                           3 "Fichier Excel ou liste des adresses + cartes PDF" ///
                           4 "Localisation des bureaux de vote" ///
                           5 "Données non disponibles"
						   
						   
// Étiquettes pour com_cartes_95
label value com_cartes_95 com_cartes_95_label
label def com_cartes_95_label 1 "Fichier Excel ou liste des adresses disponibles" ///
                           2 "Pas de fichier Excel ou liste, mais cartes PDF" ///
                           3 "Fichier Excel ou liste des adresses + cartes PDF" ///
                           4 "Localisation des bureaux de vote" ///
                           5 "Données non disponibles"
						   
						   
// Étiquettes pour com_cartes_01
label value com_cartes_01 com_cartes_01_label
label def com_cartes_01_label 1 "Fichier Excel ou liste des adresses disponibles" ///
                           2 "Pas de fichier Excel ou liste, mais cartes PDF" ///
                           3 "Fichier Excel ou liste des adresses + cartes PDF" ///
                           4 "Localisation des bureaux de vote" ///
                           5 "Données non disponibles"
						   

// Étiquettes pour com_cartes_02
label value com_cartes_02 com_cartes_02_label
label def com_cartes_02_label 1 "Fichier Excel ou liste des adresses disponibles" ///
                           2 "Pas de fichier Excel ou liste, mais cartes PDF" ///
                           3 "Fichier Excel ou liste des adresses + cartes PDF" ///
                           4 "Localisation des bureaux de vote" ///
                           5 "Données non disponibles"						   

						   
// Étiquettes pour com_cartes_post_02
label value com_cartes_post_02 com_cartes_post_02_label
label def com_cartes_post_02_label 1 "Fichier Excel ou liste des adresses disponibles" ///
                           2 "Pas de fichier Excel ou liste, mais cartes PDF" ///
                           3 "Fichier Excel ou liste des adresses + cartes PDF" ///
                           4 "Localisation des bureaux de vote" ///
                           5 "Données non disponibles"						   





label var libcom "Nom de la commune"
label var libdep "Nom du département de la commune"
label var com "Code de la commune"


// Attribuer des étiquettes aux valeurs de la variable "statut_com"

ta statut_com, m

label value statut_com statut_com_label
label def statut_com_label 	1 "Toutes les données ont été reçues" ///
							2 "Données partielles reçues/à compléter"  ///
							3 "Côtes envoyées"  /// 
							4 "Pas de réponse/à relancer/en attente"  ///
							5 "En attente"  ///
							6 "Pas de données dispos"  ///
							7 "Données dispos mais rien envoyées (ni données, ni côtes)"

fre statut_com 


* Détails dans la variable : infos_collectees_com


*order com*, after(statut_com)

*keep pop99 libcom libdep nb_qru nb_znqru com* statut_com

save "${output}synthese_data_communes.dta", replace


/*****************************************************
2.1 Stat desc Communes 
*/****************************************************


use "${output}synthese_data_communes.dta", clear

fre com_*

/*


com_presid_88 -- presid_88 : 1 si données envoyées , 2 si données dispos mais
>  pas envoyées , 0 si
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |          7       1.46      17.95      17.95
        1     |         20       4.17      51.28      69.23
        2     |         12       2.50      30.77     100.00
        Total |         39       8.13     100.00           
Missing .     |        441      91.88                      
Total         |        480     100.00                      
-----------------------------------------------------------

com_presid_95 -- presid_95 : 1 si données envoyées , 2 si données dispos mais
>  pas envoyées , 0 si
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |          3       0.63       7.69       7.69
        1     |         23       4.79      58.97      66.67
        2     |         13       2.71      33.33     100.00
        Total |         39       8.13     100.00           
Missing .     |        441      91.88                      
Total         |        480     100.00                      
-----------------------------------------------------------

com_municip_89 -- municip_89 : 1 si données envoyées , 2 si données dispos ma
> is pas envoyées , 0 s
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |          4       0.83      10.26      10.26
        1     |         22       4.58      56.41      66.67
        2     |         13       2.71      33.33     100.00
        Total |         39       8.13     100.00           
Missing .     |        441      91.88                      
Total         |        480     100.00                      
-----------------------------------------------------------

com_municip_95 -- municip_95 : 1 si données envoyées , 2 si données dispos ma
> is pas envoyées , 0 s
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |          5       1.04      12.82      12.82
        1     |         21       4.38      53.85      66.67
        2     |         13       2.71      33.33     100.00
        Total |         39       8.13     100.00           
Missing .     |        441      91.88                      
Total         |        480     100.00                      
-----------------------------------------------------------

com_municip_01 -- municip_01 : 1 si données envoyées , 2 si données dispos ma
> is pas envoyées , 0 s
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |          6       1.25      15.38      15.38
        1     |         20       4.17      51.28      66.67
        2     |         13       2.71      33.33     100.00
        Total |         39       8.13     100.00           
Missing .     |        441      91.88                      
Total         |        480     100.00                      
-----------------------------------------------------------

com_cartes_88 -- Cartes_88 : 1. si fichier excel des adresses disponibles ; 2
> . si pas fichier exc
--------------------------------------------------------------------------
                             |      Freq.    Percent      Valid       Cum.
-----------------------------+--------------------------------------------
Valid   0                    |         26       5.42      66.67      66.67
        1 Fichier Excel ou   |          7       1.46      17.95      84.62
          liste des adresses |                                            
          disponibles        |                                            
        4 Localisation des   |          6       1.25      15.38     100.00
          bureaux de vote    |                                            
        Total                |         39       8.13     100.00           
Missing .                    |        441      91.88                      
Total                        |        480     100.00                      
--------------------------------------------------------------------------

com_cartes_89 -- Cartes_89
--------------------------------------------------------------------------
                             |      Freq.    Percent      Valid       Cum.
-----------------------------+--------------------------------------------
Valid   0                    |         27       5.63      69.23      69.23
        1 Fichier Excel ou   |          6       1.25      15.38      84.62
          liste des adresses |                                            
          disponibles        |                                            
        4 Localisation des   |          6       1.25      15.38     100.00
          bureaux de vote    |                                            
        Total                |         39       8.13     100.00           
Missing .                    |        441      91.88                      
Total                        |        480     100.00                      
--------------------------------------------------------------------------

com_cartes_95 -- Cartes_95
--------------------------------------------------------------------------
                             |      Freq.    Percent      Valid       Cum.
-----------------------------+--------------------------------------------
Valid   0                    |         24       5.00      61.54      61.54
        1 Fichier Excel ou   |          8       1.67      20.51      82.05
          liste des adresses |                                            
          disponibles        |                                            
        4 Localisation des   |          7       1.46      17.95     100.00
          bureaux de vote    |                                            
        Total                |         39       8.13     100.00           
Missing .                    |        441      91.88                      
Total                        |        480     100.00                      
--------------------------------------------------------------------------

com_cartes_01 -- Cartes_01
--------------------------------------------------------------------------
                             |      Freq.    Percent      Valid       Cum.
-----------------------------+--------------------------------------------
Valid   0                    |         27       5.63      69.23      69.23
        1 Fichier Excel ou   |          7       1.46      17.95      87.18
          liste des adresses |                                            
          disponibles        |                                            
        4 Localisation des   |          5       1.04      12.82     100.00
          bureaux de vote    |                                            
        Total                |         39       8.13     100.00           
Missing .                    |        441      91.88                      
Total                        |        480     100.00                      
--------------------------------------------------------------------------

com_cartes_02 -- Cartes_02
--------------------------------------------------------------------------
                             |      Freq.    Percent      Valid       Cum.
-----------------------------+--------------------------------------------
Valid   0                    |         27       5.63      69.23      69.23
        1 Fichier Excel ou   |          7       1.46      17.95      87.18
          liste des adresses |                                            
          disponibles        |                                            
        4 Localisation des   |          5       1.04      12.82     100.00
          bureaux de vote    |                                            
        Total                |         39       8.13     100.00           
Missing .                    |        441      91.88                      
Total                        |        480     100.00                      
--------------------------------------------------------------------------

com_cartes_post_02 -- Cartes_post_02
----------------------------------------------------------------------------
                               |      Freq.    Percent      Valid       Cum.
-------------------------------+--------------------------------------------
Valid   0                      |         24       5.00      61.54      61.54
        1 Fichier Excel ou     |          8       1.67      20.51      82.05
          liste des adresses   |                                            
          disponibles          |                                            
        2 Pas de fichier Excel |          1       0.21       2.56      84.62
          ou liste, mais       |                                            
          cartes PDF           |                                            
        4 Localisation des     |          6       1.25      15.38     100.00
          bureaux de vote      |                                            
        Total                  |         39       8.13     100.00           
Missing .                      |        441      91.88                      
Total                          |        480     100.00                      
----------------------------------------------------------------------------


com_presid_88_envoyees -- Données élections présidentielles 1988 envoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        460      95.83      95.83      95.83
        1     |         20       4.17       4.17     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

com_presid_88_dispos -- Données élections présidentielles 1988 dispos mais pa
> s envoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        468      97.50      97.50      97.50
        1     |         12       2.50       2.50     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

com_presid_95_envoyees -- Données élections présidentielles 1995 envoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        457      95.21      95.21      95.21
        1     |         23       4.79       4.79     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

com_presid_95_dispos -- Données élections présidentielles 1995 dispos mais pa
> s envoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        467      97.29      97.29      97.29
        1     |         13       2.71       2.71     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

com_municip_89_envoyees -- Données élections municipales 1989 envoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        458      95.42      95.42      95.42
        1     |         22       4.58       4.58     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

com_municip_89_dispos -- Données élections municipales 1989 dispos mais pas e
> nvoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        467      97.29      97.29      97.29
        1     |         13       2.71       2.71     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

com_municip_95_envoyees -- Données élections municipales 1995 envoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        459      95.63      95.63      95.63
        1     |         21       4.38       4.38     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

com_municip_95_dispos -- Données élections municipales 1995 dispos mais pas e
> nvoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        467      97.29      97.29      97.29
        1     |         13       2.71       2.71     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

com_municip_01_envoyees -- Données élections municipales 2001 envoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        460      95.83      95.83      95.83
        1     |         20       4.17       4.17     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

com_municip_01_dispos -- Données élections municipales 2001 dispos mais pas e
> nvoyées
-----------------------------------------------------------
              |      Freq.    Percent      Valid       Cum.
--------------+--------------------------------------------
Valid   0     |        467      97.29      97.29      97.29
        1     |         13       2.71       2.71     100.00
        Total |        480     100.00     100.00           
-----------------------------------------------------------

*/


/****************************************
Merge des deux bases
*/******************************************


use "${output}synthese_data_prefectures.dta" , clear
merge 1:n libdep using "${output}synthese_data_communes.dta"

/*

    Result                      Number of obs
    -----------------------------------------
    Not matched                             0
    Matched                               480  (_merge==3)
    -----------------------------------------

*/

drop _m
	
*order 
	
save "synthese_prefectures_communes.dta", replace





























