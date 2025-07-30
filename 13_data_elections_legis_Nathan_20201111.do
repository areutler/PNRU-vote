/*****************************************************************************/
/*																			 */
/*  CONSTRUCTION OF VARIABLES FROM ELECTORAL RESULTS: LEGISLATIVES           */
/*																			 */
/*****************************************************************************/
set more off

//cd "$ec_source"

cd "C:\Users\natha\Desktop\Crime_and_the_city_Nathan\ANALYSE\data_election\Législatives"

/****************************************************************************/
/****************************************************************************/
/* 1. Append legislative data to create a common database                  */
/****************************************************************************/
/****************************************************************************/
//{ }


// 2002 & 2007

foreach year in 02 07{ 

	import delimited "LG`year'_BVot_T1T2.txt", delimiter(";") varnames(nonames) rowrange(18) clear

	rename v1 tour
	rename v2 dep
	rename v3 cod_com
	rename v4 name_com
	rename v5 bdv
	rename v6 inscrits
	rename v7 votants
	rename v8 exprimes
	rename v10 nom_candidat
	rename v11 prenom_candidat
	rename v12 code_nuance_candidat
	rename v13 voix_candidat

	drop v9 //Numéro de dépots

	gen year=2000+`year'

	save "legis20`year'.dta", replace
}

//2012

import delimited "LG12_BVot_T1T2.txt", delimiter(";") varnames(nonames) rowrange(19) clear

rename v1 tour
rename v2 dep
rename v3 cod_com
rename v4 name_com
rename v7 bdv
rename v8 inscrits
rename v9 votants
rename v10 exprimes
rename v12 nom_candidat
rename v13 prenom_candidat
rename v14 code_nuance_candidat
rename v15 voix_candidat

drop v5 v6 v11

gen year=2012

save "legis2012.dta"


//2017

import delimited "Leg_2017_Resultats_BVT_T1_c.txt", delimiter(";") rowrange(2) varnames(nonames) clear

rename v1 dep
rename v2 name_dep
rename v3 cod_circo
rename v4 name_circo
rename v5 cod_com
rename v6 name_com
rename v7 bdv
rename v8 inscrits
rename v9 abstentions
rename v11 votants
rename v13 blancs
rename v16 nuls
rename v19 exprimes


forval x=1/27{
	local x1=16+8*`x'
	local x2=17+8*`x'
	local x3=18+8*`x'
	local x4=19+8*`x'
  
	rename v`x1' nom_candidat`x'
	rename v`x2' prenom_candidat`x'
	rename v`x3' code_nuance_candidat`x'
	rename v`x4' voix_candidat`x'  
}

rename votants xvotants
rename voix_candidat* xvoix_candidat*

drop v*
rename xvotants votants
rename xvoix_candidat* voix_candidat*


reshape long nom_candidat prenom_candidat code_nuance_candidat voix_candidat, i(dep name_dep cod_circo cod_com bdv inscrits votants blancs nuls exprimes) j(k)
drop k
drop if voix_candidat==.

gen year=2017
gen tour=1

save "legis2017_t1.dta", replace

**T2

import delimited "Leg_2017_Resultats_BVT_T2_c.txt", delimiter(";") rowrange(2) varnames(nonames) clear

rename v1 dep
rename v2 name_dep
rename v3 cod_circo
rename v4 name_circo
rename v5 cod_com
rename v6 name_com
rename v7 bdv
rename v8 inscrits
rename v9 abstentions
rename v11 votants
rename v13 blancs
rename v16 nuls
rename v19 exprimes



forval x=1/3{
	local x1=16+8*`x'
	local x2=17+8*`x'
	local x3=18+8*`x'
	local x4=19+8*`x'
  
	rename v`x1' nom_candidat`x'
	rename v`x2' prenom_candidat`x'
	rename v`x3' code_nuance_candidat`x'
	rename v`x4' voix_candidat`x'  
}

rename votants xvotants
rename voix_candidat* xvoix_candidat*

drop v*
rename xvotants votants
rename xvoix_candidat* voix_candidat*

reshape long nom_candidat prenom_candidat code_nuance_candidat voix_candidat, i(dep name_dep cod_circo cod_com bdv inscrits votants blancs nuls exprimes) j(k)
drop k
drop if voix_candidat==.


gen year=2017
gen tour=2

save "legis2017_t2.dta", replace

append using "legis2017_t1.dta"

save "legis2017.dta", replace

erase "legis2017_t1.dta"
erase "legis2017_t2.dta"


import excel "partyaffiliation.xlsx", sheet("partyaffiliation20022017") cellrange(A3:B40) firstrow clear
	
save "partyaffiliation20022017.dta", replace



use "legis2002.dta", clear

foreach year in 07 12 17{ 
	append using "legis20`year'.dta"
}

foreach year in 02 07 12 17{ 
	erase "legis20`year'.dta"
}

merge m:1 code_nuance_candidat using "partyaffiliation20022017.dta", nogen


/*

    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                         3,900,025  
    -----------------------------------------

*/

drop 

save "legis_bv.dta", replace

use "legis_bv.dta", clear

/*

Previous communal change to be accounted

*/


** Let's first check if we don't have two similar bdv for the same communes 
isid year tour dep cod_com bdv nom_candidat prenom_candidat


** Following discussion with Camille, I drop Outre-mer communes which are not in the analysis
drop if dep=="ZA" | dep=="ZB" | dep=="ZC" | dep=="ZD" | dep=="ZM" | dep=="ZN" | dep=="ZP" | dep=="ZS" | dep=="ZW" | dep=="ZX" | dep=="ZZ"

** For Corse departments, the INSEE code is not well coded - we need to change 2A and 2B into 20
replace dep="20" if dep=="2A" | dep=="2B"

destring dep, replace

gen x=1000*dep+cod_com
gen str5 depcom = string(x,"%05.0f")

drop x



//TAKING INTO ACCOUNT PREVIOUS COMMUNAL CHANGES


preserve

		import excel "C:\Users\natha\Desktop\Crime_and_the_city_Nathan\ANALYSE\data_EtatCivil\table_passage_geo2003_geo2019.xls", sheet("Table_passage") cellrange(A6:C36726) firstrow clear

		rename CODGEO_INI depcom
		rename CODGEO_2019 cog

		drop if substr(depcom,1,2)=="97" //I drop all the outremer communes

		replace depcom=subinstr(depcom,"2A","20",1) if substr(depcom,1,2)=="2A" //Similarly for Corse
		replace depcom=subinstr(depcom,"2B","20",1) if substr(depcom,1,2)=="2B"

		replace cog=subinstr(cog,"2A","20",1) if substr(cog,1,2)=="2A" //Similarly for Corse
		replace cog=subinstr(cog,"2B","20",1) if substr(cog,1,2)=="2B"

		save "cog2019", replace

restore



////// SOME PREVIOUS COMMUNAL CHANGES HAVE NOT BEEN REPORTED IN THE ELECTIONAL DATA

*61022 - 01/01/2000 : Bagnoles-de-l'Orne est rattachée à Tessé-la-Madeleine (61483) qui devient Bagnoles-de-l'Orne (fusion simple).
replace depcom = "61483" if depcom=="61022"               

*71211 - 01/01/2003 : Géanges est rattachée à Saint-Loup-de-la-Salle (71443) qui devient Saint-Loup-Géanges (fusion simple).					 
replace depcom = "71443" if depcom=="71211"

*88034 - 01/07/1995 : Ban-sur-Meurthe est rattachée à Clefcy (88106) qui devient Ban-sur-Meurthe-Clefcy (fusion simple).
replace depcom = "88106" if depcom=="88034"

*55227 - 01/01/1997 : Han-devant-Pierrepont est rattaché au département de Meurthe-et-Moselle (54602).
replace depcom = "54602" if depcom=="55227" 

/*I assumed here that if the fusion is done for a given year, i.e we don't have in 
the same year the merged commune + the old one (this would in this case lead to a 
double addition of the var.).

Seems to be true for the commune which only changed from code.

The fusion of those cities would be done through the collapse below.

Still some issues

tab depcom if _merge==1

     depcom |      Freq.     Percent        Cum.
------------+-----------------------------------
      26383 |         36      100.00      100.00
------------+-----------------------------------
      Total |         62      100.00

No information for 26383
*/

merge m:1 depcom using cog2019

/*

  Result                           # of obs.
    -----------------------------------------
    not matched                            47
        from master                        36  (_merge==1)
        from using                         11  (_merge==2)

    matched                         3,792,964  (_merge==3)
    -----------------------------------------

*/

drop if _merge==2


/* In line with what we have done for the EC data --> Merging as such would cause an issue for some cog which have merged in 2019
 - data from police only considering change until 2018

We corrected it at least for the police data for the EC so I think we need to do it also for the election data

	
tab police if _merge==2

 1 if PN, 0 |
      if GN |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        438       98.65       98.65
          1 |          6        1.35      100.00
------------+-----------------------------------
      Total |        444      100.00


tab cog if _merge==2 & police==1

CODGEO_2019 |      Freq.     Percent        Cum.
------------+-----------------------------------
      77028 |          1       16.67       16.67
      78251 |          1       16.67       33.33
      78524 |          1       16.67       50.00
      85060 |          1       16.67       66.67
      85166 |          1       16.67       83.33
      91182 |          1       16.67      100.00
------------+-----------------------------------
      Total |          6      100.00

Ceci est dû à des modifications communales de 2019 - je vais changer ça.
-77028: 01/01/2019 : Beautheil devient commune déléguée au sein de Beautheil-Saints (77433) (commune nouvelle). 	  
  --> La base de correspondance INSEE a pris en compte ce merging - est-ce que l'on change ça ?  

-78251: 01/01/2019 : Fourqueux devient commune déléguée au sein de Saint-Germain-en-Laye (78551) (commune nouvelle).	  
-78524: 01/01/2019 : Rocquencourt devient commune déléguée au sein du Chesnay-Rocquencourt (78158) (commune nouvelle).
-85060: 01/01/2019 : Château-d'Olonne devient commune déléguée au sein des Sables-d'Olonne (85194) (commune nouvelle). 	  
-85166: 01/01/2019 : Olonne-sur-Mer devient commune déléguée au sein des Sables-d'Olonne (85194) (commune nouvelle).	  
-91182: 01/01/2019 : Courcouronnes devient commune déléguée au sein d'Évry-Courcouronnes (91228) (commune nouvelle).	  

I change this now before merging - fortunately, we have all the observations for those cog*/

replace cog=depcom if depcom=="77028" | depcom=="78251" | depcom=="78524" | depcom=="85060" | depcom=="85166" | depcom=="91182" 
replace LIBGEO_2019=name_com if depcom=="77028" | depcom=="78251" | depcom=="78524" | depcom=="85060" | depcom=="85166" | depcom=="91182"

label var cog "INSEE communal code (2019 - 2018 if police)"

replace cog=depcom if _merge==1 //For La Répara - Auriples
replace LIBGEO_2019=name_com if _merge==1

** We now need to account for the fact that bdv may have not been merged with each other -> we thus change their name

duplicates tag year tour cog bdv nom_candidat prenom_candidat, gen(dupbdv)

gen bdv2= bdv + name_com
replace bdv2=bdv if dupbdv==0

isid year tour cog bdv2 nom_candidat prenom_candidat

drop _merge dep name_dep cod_com name_com bdv dupbdv

rename bdv2 bdv

order year tour cog LIBGEO_2019 bdv  


save "legis_bdv_merged.dta", replace


use "legis_bdv_merged.dta", clear

gen blancsetnuls=votants-exprimes

gen test=(blancsetnuls==blancs+nuls)

/*

tab test if blancs!=. OKKKKK

       test |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |  1,004,194      100.00      100.00
------------+-----------------------------------
      Total |  1,004,194      100.00

*/

drop test

replace abstentions=inscrits-votants if abstentions==.

preserve
	keep year tour cog inscrits votants exprimes blancsetnuls abstentions depcom
	
	duplicates drop

	collapse (sum) inscrits votants exprimes blancsetnuls abstentions, by(year tour cog)

	save "tobemerged.dta", replace
restore

keep year tour cog voix_candidat pol_orisim
collapse (sum) voix_candidat, by (year tour cog pol_orisim)

rename voix_candidat voix_movement

merge m:m year tour cog using "tobemerged.dta", nogen //ok

save "legis_comm_tobeappended.dta", replace


********************************************************************************
**																			  **
**								COMMUNAL LEVEL DATAFRAME					  **
**																			  **
********************************************************************************

*** 1986 --> WARNING : it was proportional vote by the time
import delimited "cdsp_legi1986_commp9000.csv", clear 


rename particommuniste COM
rename extrãªmegauche EXG
rename partisocialistediversgauche PSDVG
rename ecolo ECO
rename unionpourladãmocratiefranãaise UDF
rename rassemblementpourlarãpublique RPR
rename unionpourladãmocratiefranãaisera UDFRPR
rename diversdroite DVD
rename extrãªmedroite EXD

drop if votants==. //The first observation is not one

rename * x*

gen year=1986
gen tour=1

rename xcodedãpartement dep
rename xdãpartement name_dep
rename xnumãrodecommune cod_com
rename xcommune name_com
rename xexprimãs exprimes
rename xvotants votants
rename xinscrits inscrits

reshape long x, i(dep name_dep cod_com name_com inscrits votants exprimes) j(code_nuance_candidat, string)

rename x voix_candidat

destring voix_candidat, replace

save tempfile, replace




*** 1988
**T1
import delimited "cdsp_legi1988t1_commp9000.csv", clear 

rename extrãªmegauche EXG
rename particommuniste COM
rename partisocialiste PS
rename mouvementdesradicauxdegauche MRG
rename diversgauche DVG
rename ecolo ECO
rename rãgionaliste REG
rename unionpourladãmocratiefranãaise UDF
rename rassemblementpourlarãpublique RPR
rename extrãªmedroite EXD
rename diversdroite DVD

rename * x*

gen year=1988
gen tour=1

rename xcodedãpartement dep
rename xdãpartement name_dep
rename xcodecommune cod_com
rename xcommune name_com
rename xexprimãs exprimes
rename xvotants votants
rename xinscrits inscrits

reshape long x, i(dep name_dep cod_com name_com inscrits votants exprimes) j(code_nuance_candidat, string)

rename x voix_candidat

append using tempfile
save tempfile, replace



**1993 and 1998

foreach year in 1993 1997{ 
	foreach tour in 1 2{ 

		import excel "`year'(par communes).xls", sheet("Tour `tour'") firstrow clear


		rename Codedudépartement dep
		rename Libellédudépartement name_dep
		rename Codedelacommune cod_com
		rename Libellédelacommune name_com
		rename Libellédelacirconscription name_circo
		rename Inscrits inscrits
		rename Abstentions abstentions
		rename Votants votants
		rename Blancsetnuls blancsetnuls
		rename Exprimés exprimes

		drop AbsIns VotIns BlNulsIns BlNulsVot ExpIns ExpVot VoixExp VoixIns

		//DONT KNOW WHAT IS GD? GL? GT? HB? HJ?

		cap rename Nom nom_candidat1
		cap rename Prénom prenom_candidat1
		cap rename Nuance code_nuance_candidat1
		cap rename Voix voix_candidat1

		cap rename 	Z	nom_candidat2
		cap rename 	AA	prenom_candidat2
		cap rename 	AB	code_nuance_candidat2
		cap rename 	AC	voix_candidat2
					
		cap rename 	AG	nom_candidat3
		cap rename 	AH	prenom_candidat3
		cap rename 	AI	code_nuance_candidat3
		cap rename 	AJ	voix_candidat3
					
		cap rename 	AN	nom_candidat4
		cap rename 	AO	prenom_candidat4
		cap rename 	AP	code_nuance_candidat4
		cap rename 	AQ	voix_candidat4
					
		cap rename 	AU	nom_candidat5
		cap rename 	AV	prenom_candidat5
		cap rename 	AW	code_nuance_candidat5
		cap rename 	AX	voix_candidat5
					
		cap rename 	BB	nom_candidat6
		cap rename 	BC	prenom_candidat6
		cap rename 	BD	code_nuance_candidat6
		cap rename 	BE	voix_candidat6
					
		cap rename 	BI	nom_candidat7
		cap rename 	BJ	prenom_candidat7
		cap rename 	BK	code_nuance_candidat7
		cap rename 	BL	voix_candidat7
					
		cap rename 	BP	nom_candidat8
		cap rename 	BQ	prenom_candidat8
		cap rename 	BR	code_nuance_candidat8
		cap rename 	BS	voix_candidat8
					
		cap rename 	BW	nom_candidat9
		cap rename 	BX	prenom_candidat9
		cap rename 	BY	code_nuance_candidat9
		cap rename 	BZ	voix_candidat9
					
		cap rename 	CD	nom_candidat10
		cap rename 	CE	prenom_candidat10
		cap rename 	CF	code_nuance_candidat10
		cap rename 	CG	voix_candidat10
					
		cap rename 	CK	nom_candidat11
		cap rename 	CL	prenom_candidat11
		cap rename 	CM	code_nuance_candidat11
		cap rename 	CN	voix_candidat11
					
		cap rename 	CR	nom_candidat12
		cap rename 	CS	prenom_candidat12
		cap rename 	CT	code_nuance_candidat12
		cap rename 	CU	voix_candidat12
					
		cap rename 	CY	nom_candidat13
		cap rename 	CZ	prenom_candidat13
		cap rename 	DA	code_nuance_candidat13
		cap rename 	DB	voix_candidat13
					
		cap rename 	DF	nom_candidat14
		cap rename 	DG	prenom_candidat14
		cap rename 	DH	code_nuance_candidat14
		cap rename 	DI	voix_candidat14
					
		cap rename 	DM	nom_candidat15
		cap rename 	DN	prenom_candidat15
		cap rename 	DO	code_nuance_candidat15
		cap rename 	DP	voix_candidat15
					
		cap rename 	DT	nom_candidat16
		cap rename 	DU	prenom_candidat16
		cap rename 	DV	code_nuance_candidat16
		cap rename 	DW	voix_candidat16
					
		cap rename 	EA	nom_candidat17
		cap rename 	EB	prenom_candidat17
		cap rename 	EC	code_nuance_candidat17
		cap rename 	ED	voix_candidat17
					
		cap rename 	EH	nom_candidat18
		cap rename 	EI	prenom_candidat18
		cap rename 	EJ	code_nuance_candidat18
		cap rename 	EK	voix_candidat18
					
		cap rename 	EO 	nom_candidat19
		cap rename 	EP	prenom_candidat19
		cap rename 	EQ	code_nuance_candidat19
		cap rename 	ER	voix_candidat19
					
		cap rename 	EV 	nom_candidat20
		cap rename 	EW 	prenom_candidat20
		cap rename 	EX 	code_nuance_candidat20
		cap rename 	EY	voix_candidat20
					
		cap rename 	FC	nom_candidat21
		cap rename 	FD	prenom_candidat21
		cap rename 	FE	code_nuance_candidat21
		cap rename 	FF	voix_candidat21
					
		cap rename 	FJ	nom_candidat22
		cap rename 	FK	prenom_candidat22
		cap rename 	FL	code_nuance_candidat22
		cap rename 	FM	voix_candidat22
					
		cap rename 	FQ	nom_candidat23
		cap rename 	FR	prenom_candidat23
		cap rename 	FS	code_nuance_candidat23
		cap rename 	FT	voix_candidat23
					
		cap rename 	FX	nom_candidat24
		cap rename 	FY	prenom_candidat24
		cap rename 	FZ	code_nuance_candidat24
		cap rename 	GA	voix_candidat24
					
		cap rename 	GF	nom_candidat25
		cap rename 	GG	prenom_candidat25
		cap rename 	GH	code_nuance_candidat25
		cap rename 	GI	voix_candidat25
					
		cap rename 	GN	nom_candidat26
		cap rename 	GO	prenom_candidat26
		cap rename 	GP	code_nuance_candidat26
		cap rename 	GL	voix_candidat26
					
		cap rename 	GV	nom_candidat27
		cap rename 	GW	prenom_candidat27
		cap rename 	GX	code_nuance_candidat27
		cap rename 	GZ	voix_candidat27
					
		cap rename 	HD	nom_candidat28
		cap rename 	HE	prenom_candidat28
		cap rename 	HF	code_nuance_candidat28
		cap rename 	HG	voix_candidat28
					
		cap rename 	HL	nom_candidat29
		cap rename 	HM	prenom_candidat29
		cap rename 	HN	code_nuance_candidat29
		cap rename 	HO	voix_candidat29

		drop Sexe Y A*
		cap drop B* C* D* E*
		cap drop F* G* H*


		reshape long nom_candidat prenom_candidat code_nuance_candidat voix_candidat, i(dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes) j(k)

		drop k

		drop if voix_candidat==.


		gen year=`year'
		gen tour=`tour'
		
		append using tempfile
		save tempfile, replace
	}
}	

replace blancsetnuls=votants-exprimes if blancsetnuls==.
replace abstentions=inscrits-votants if abstentions==.

drop name_circo Codedelacirconscription prenom_candidat nom_candidat

order year tour dep cod_com


save "legi_comm_temp.dta", replace

use "legi_comm_temp.dta", clear


** Add pol_ori
preserve
	
	import excel "partyaffiliation.xlsx", sheet("partyaffiliation19861997") cellrange(A3:B24) firstrow clear
		
	save "partyaffiliation19861997.dta", replace


restore

merge m:1 code_nuance_candidat using "partyaffiliation19861997.dta", nogen



** Add previous communal change

** Following discussion with Camille, I drop Outre-mer communes which are not in the analysis
drop if dep=="ZA" | dep=="ZB" | dep=="ZC" | dep=="ZD" | dep=="ZM" | dep=="ZN" | dep=="ZP" | dep=="ZS" | dep=="ZW" | dep=="ZX" | dep=="ZZ"

** For Corse departments, the INSEE code is not well coded - we need to change 2A and 2B into 20
replace dep="20" if dep=="2A" | dep=="2B"

destring dep, replace

gen x=1000*dep+cod_com
gen str5 depcom = string(x,"%05.0f")

drop x

////// GESTION DES 22 COMMUNES OU IL Y A EU DES CHANGEMENTS COMMUNAUX

*02630 - Communes de Quessy - 01/01/1992 : Quessy est rattachée à Tergnier (02738) (fusion association) [INSEE]
replace depcom = "02738" if depcom=="02630"

*14624 - Commune de Saint-Martin-de-Fresnay - Plusieurs changements communaux mais un seul entre 1990 et 2003 (date de la correspondance du fichier INSEE) - 01/02/1990 : Saint-Martin-de-Fresnay est rattachée à Tôtes (14697) qui devient L'Oudon (transfert de chef-lieu). [INSEE]
replace depcom = "14697" if depcom=="14624"

*16022 - Commune d'Auge - 01/01/1994 : Auge est rattachée à Saint-Médard (16339) qui devient Auge-Saint-Médard (fusion simple). [INSEE]
replace depcom = "16339" if depcom=="16022"

*16159 - Commune de Graves - 01/01/1997 : Graves est rattachée à Saint-Amant-de-Graves (16297) qui devient Graves-Saint-Amant (fusion simple).
replace depcom = "16297" if depcom=="16159"

*26158 - Commune de Laux-Montaux - 01/01/2002 : Laux-Montaux est rattachée à Chauvac (26091) qui devient Chauvac-Laux-Montaux (fusion simple).
replace depcom = "26091" if depcom=="26158"

*26265 - Commune de La Répara - 01/05/1992 : La Répara est rattachée à Auriples (26020) qui devient La Répara-Auriples (fusion simple).
replace depcom = "26020" if depcom=="26265"

*27328 - 19/06/1995 : Hellenvilliers est rattachée à Grandvilliers (27297) (fusion simple).
replace depcom = "27297" if depcom=="27328"
                     
*35073 - 01/01/1993 : Châtillon-sur-Seiche est rattachée à Noyal-sur-Seiche (35206) qui devient Noyal-Châtillon-sur-Seiche (fusion simple).
replace depcom = "35206" if depcom=="35073"
                     
*49210 - 29/02/2000 : Montigné-sur-Moine est rattachée à Montfaucon (49206) qui devient Montfaucon-Montigné (fusion simple).
replace depcom = "49206" if depcom=="49210"	

*50383 - 28/02/2000 : Octeville est rattachée à Cherbourg (50129) qui devient Cherbourg-Octeville (fusion simple). 
replace depcom = "50129" if depcom=="50383"				 

*55227 - 01/01/1997 : Han-devant-Pierrepont est rattaché au département de Meurthe-et-Moselle (54602).
replace depcom = "54602" if depcom=="55227"                     
                     
*59355 - 27/02/2000 : Lomme est rattachée à Lille (59350) (fusion association).
replace depcom = "59350" if depcom=="59355" 

*61022 - 01/01/2000 : Bagnoles-de-l'Orne est rattachée à Tessé-la-Madeleine (61483) qui devient Bagnoles-de-l'Orne (fusion simple).
replace depcom = "61483" if depcom=="61022"               

*61254 - 01/01/2002 : Marnefer est rattachée à Couvains (61136) (fusion simple).
replace depcom = "61136" if depcom=="61254"

*62110 - 01/01/1996 : Berguette est rattachée à Isbergues (62473) (fusion association).
replace depcom = "62473" if depcom=="62110"
         
*62575 - 01/01/1996 : Molinghem est rattachée à Isbergues (62473) (fusion association).
replace depcom = "62473" if depcom=="62575"

*70073 - 01/01/1994 : Bithaine-et-le-Val est rattachée à Adelans (70004) qui devient Adelans-et-le-Val-de-Bithaine (fusion simple).
replace depcom = "70004" if depcom=="70073"
                     
*71211 - 01/01/2003 : Géanges est rattachée à Saint-Loup-de-la-Salle (71443) qui devient Saint-Loup-Géanges (fusion simple).					 
replace depcom = "71443" if depcom=="71211"
                     
*71560 - 01/01/1997 : Varenne-sur-le-Doubs est rattachée à Charette (71101) qui devient Charette-Varennes (fusion simple).
replace depcom = "71101" if depcom=="71560"
                     
*79017 - 11/03/2001 : Les Aubiers est rattachée à Nueil-sur-Argent (79195) qui devient Nueil-les-Aubiers (fusion simple).
replace depcom = "79195" if depcom=="79017"

*85068 - 01/01/2000 : La Claye est rattachée à La Bretonnière (85036) (fusion association) qui devient La Bretonnière-la-Claye.
replace depcom = "85036" if depcom=="85068"                    
                     
*88034 - 01/07/1995 : Ban-sur-Meurthe est rattachée à Clefcy (88106) qui devient Ban-sur-Meurthe-Clefcy (fusion simple).
replace depcom = "88106" if depcom=="88034"


*75056 - For years before 2002, Paris cog is 75100 instead of 75056
replace depcom = "75056" if depcom=="75100"


* 01/10/1972 : Auriolles est rattachée à Saint-Alban-sous-Sampzon (07207) (fusion association) qui devient Saint-Alban-Auriolles.
replace depcom = "07207" if depcom=="07021"

*01/12/1972 : Sougères-sur-Sinotte est rattachée à Monéteau (89263) (fusion association).
replace depcom = "89263" if depcom=="89401"


merge m:1 depcom using cog2019

/*

 Result                           # of obs.
    -----------------------------------------
    not matched                           213
        from master                       170  (_merge==1)
        from using                         43  (_merge==2)

    matched                           811,280  (_merge==3)
    -----------------------------------------


WE HAVE AN ISSUE FOR SOME COG in Marne... Could be the code postale instead of cog but it is really unsure

tab depcom if _merge==1

     depcom |      Freq.     Percent        Cum.
------------+-----------------------------------
      07350 |         10        5.88        5.88
      26383 |         10        5.88       11.76
      51700 |          8        4.71       16.47
      51701 |         13        7.65       24.12
      51702 |         10        5.88       30.00
      51703 |          8        4.71       34.71
      51704 |          8        4.71       39.41
      51705 |         13        7.65       47.06
      51706 |         10        5.88       52.94
      51707 |         13        7.65       60.59
      51708 |         10        5.88       66.47
      51709 |         12        7.06       73.53
      51710 |         12        7.06       80.59
      51711 |         12        7.06       87.65
      51712 |         11        6.47       94.12
      51713 |         10        5.88      100.00
------------+-----------------------------------
      Total |        170      100.00

Also 07350 and 26383 - no info on INSEE website for those cog?!

*/

drop if _merge==2

/* In line with what we have done for the EC data --> Merging as such would cause an issue for some cog which have merged in 2019
 - data from police only considering change until 2018

We corrected it at least for the police data for the EC so I think we need to do it also for the election data

	
tab police if _merge==2

 1 if PN, 0 |
      if GN |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        438       98.65       98.65
          1 |          6        1.35      100.00
------------+-----------------------------------
      Total |        444      100.00


tab cog if _merge==2 & police==1

CODGEO_2019 |      Freq.     Percent        Cum.
------------+-----------------------------------
      77028 |          1       16.67       16.67
      78251 |          1       16.67       33.33
      78524 |          1       16.67       50.00
      85060 |          1       16.67       66.67
      85166 |          1       16.67       83.33
      91182 |          1       16.67      100.00
------------+-----------------------------------
      Total |          6      100.00

Ceci est dû à des modifications communales de 2019 - je vais changer ça.
-77028: 01/01/2019 : Beautheil devient commune déléguée au sein de Beautheil-Saints (77433) (commune nouvelle). 	  
  --> La base de correspondance INSEE a pris en compte ce merging - est-ce que l'on change ça ?  

-78251: 01/01/2019 : Fourqueux devient commune déléguée au sein de Saint-Germain-en-Laye (78551) (commune nouvelle).	  
-78524: 01/01/2019 : Rocquencourt devient commune déléguée au sein du Chesnay-Rocquencourt (78158) (commune nouvelle).
-85060: 01/01/2019 : Château-d'Olonne devient commune déléguée au sein des Sables-d'Olonne (85194) (commune nouvelle). 	  
-85166: 01/01/2019 : Olonne-sur-Mer devient commune déléguée au sein des Sables-d'Olonne (85194) (commune nouvelle).	  
-91182: 01/01/2019 : Courcouronnes devient commune déléguée au sein d'Évry-Courcouronnes (91228) (commune nouvelle).	  

I change this now before merging - fortunately, we have all the observations for those cog*/

replace cog=depcom if depcom=="77028" | depcom=="78251" | depcom=="78524" | depcom=="85060" | depcom=="85166" | depcom=="91182" 
replace LIBGEO_2019=name_com if depcom=="77028" | depcom=="78251" | depcom=="78524" | depcom=="85060" | depcom=="85166" | depcom=="91182"


replace cog=depcom if _merge==1
replace LIBGEO_2019=name_com if _merge==1


label var cog "INSEE communal code (2019 - 2018 if police)"


drop _merge dep name_dep cod_com name_com


//collapse (sum) inscrits abstentions votants blancsetnuls exprimes voix_candidat, by(year tour cog code_nuance_candidat pol_orisim)
order cog


** Add inscrits + ...

replace abstentions=inscrits-votants if abstentions==.
replace blancsetnuls=votants-exprimes if blancsetnuls==.


**ISSUE: when we merged two cog, some had different candidates for the same election --> the merging thus didn't worked well, we need to correct for this


preserve

	keep cog year tour inscrits abstentions votants blancsetnuls exprimes depcom
	
	duplicates drop
	
	collapse (sum) inscrits abstentions votants blancsetnuls exprimes, by(cog year tour)

	save "tobemerged.dta", replace

restore

collapse (sum) voix_candidat, by(cog year tour pol_orisim)

rename voix_candidat voix_movement


merge m:m cog year tour using "tobemerged.dta", nogen //perfect merge

erase "tobemerged.dta"






** Append using BDV level
append using "legis_comm_tobeappended.dta"


/* NO MISSINGS
foreach variable in cog year tour pol_orisim voix_movement inscrits abstentions votants blancsetnuls exprimes{
	cap drop test
	di "`variable'"
	cap gen test=(`variable'==.)
	cap gen test=(`variable'=="")
	tab test
}
drop test
*/




** Wide database

* One observation per year

*First let's reshape by polori_sim 

replace pol_orisim="center_left" if pol_orisim=="center-left"
replace pol_orisim="center_right" if pol_orisim=="center-right"
replace pol_orisim="extreme_left" if pol_orisim=="extreme-left"
replace pol_orisim="extreme_right" if pol_orisim=="extreme-right"

reshape wide voix_movement, i(year tour cog inscrits abstentions votants exprimes) j(pol_orisim, string)

rename voix_movement* voix_*


*Now, let's reshape by turn for each year

reshape wide inscrits abstentions votants exprimes voix_center voix_center_left voix_center_right voix_diverse voix_extreme_left voix_extreme_right voix_left voix_right blancsetnuls, i(year cog) j(tour)

rename inscrits* t*_inscrits
rename abstentions* t*_abstentions
rename votants* t*_votants
rename exprimes* t*_exprimes
rename blancsetnuls* t*_blancsetnuls

foreach var in center_left center_right center diverse extreme_left extreme_right left right{
	rename voix_`var'* t*_voix_`var'
}


/*

We do observe change by communes - only +9000habs in 1986 and 1988

tab year

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       1986 |        857        0.41        0.41
       1988 |        857        0.41        0.81
       1993 |     34,816       16.53       17.35
       1997 |     34,808       16.53       33.88
       2002 |     34,735       16.49       50.37
       2007 |     34,830       16.54       66.91
       2012 |     34,838       16.54       83.45
       2017 |     34,841       16.55      100.00
------------+-----------------------------------
      Total |    210,582      100.00

*/


preserve
	gen test_inscrit=t1_inscrits-t2_inscrits

	gen test_inscrit2=test_inscrit/t1_inscrits
	
	 gen dup=((test_inscrit2>0.05 | test_inscrit2<-0.05) & test_inscrit2!=.)

	/*
	
	tab year if (test_inscrit2>0.05 | test_inscrit2<-0.05) & test_inscrit2!=.

	       year |      Freq.     Percent        Cum.
	------------+-----------------------------------
		   1993 |         94       26.93       26.93
		   1997 |        104       29.80       56.73
		   2002 |         30        8.60       65.33
		   2007 |         55       15.76       81.09
		   2012 |         39       11.17       92.26
		   2017 |         27        7.74      100.00
	------------+-----------------------------------
		  Total |        349      100.00
	
	Which ones?
	
	count if dup==1 & t1_inscrits>1000
	 137
	 
	count if dup==1 & t1_inscrits>9000 
	68 
	 
	 TO BE CHECKED AGAIN!!
	*/


restore



**BY YEAR

reshape wide t1_inscrits t1_abstentions t1_votants t1_exprimes t1_voix_center_left t1_voix_center_right t1_voix_center t1_voix_diverse t1_voix_extreme_left t1_voix_extreme_right t1_voix_left t1_voix_right t1_blancsetnuls t2_inscrits t2_abstentions t2_votants t2_exprimes t2_voix_center_left t2_voix_center_right t2_voix_center t2_voix_diverse t2_voix_extreme_left t2_voix_extreme_right t2_voix_left t2_voix_right t2_blancsetnuls, i(cog) j(year)

foreach variable in t1_inscrits t1_abstentions t1_votants t1_exprimes t1_voix_center_left t1_voix_center_right t1_voix_center t1_voix_diverse t1_voix_extreme_left t1_voix_extreme_right t1_voix_left t1_voix_right t1_blancsetnuls t2_inscrits t2_abstentions t2_votants t2_exprimes t2_voix_center_left t2_voix_center_right t2_voix_center t2_voix_diverse t2_voix_extreme_left t2_voix_extreme_right t2_voix_left t2_voix_right t2_blancsetnuls{
	rename `variable'* y*_`variable'
}


//correction for t2_inscritsbis - NOTE THAT FOR SOME COG IT IS NORMAL TO HAVE MISSINGS IN T2 (candidates elected from tour 1)... it is not accounted here

foreach year in 1986 1988 1993 1997 2002 2007 2012 2017{
	gen y`year'_t2_inscritsbis=y`year'_t1_inscrits
}	


save "legi_comm_polorisim.dta", replace






** MERGING WITH BASE COMMUNE


preserve
	use "C:\Users\natha\Desktop\Crime_and_the_city_Nathan\ANALYSE\output\base_communes.dta", clear
	
	gen cog=com
	replace cog=subinstr(cog,"2A","20",1) if substr(cog,1,2)=="2A" //Similarly for Corse
	replace cog=subinstr(cog,"2B","20",1) if substr(cog,1,2)=="2B"

	save "base_communes.dta", replace
restore

merge 1:1 cog using "base_communes.dta"

gen ofinterest=(qru==1 | nb_znqru>0)
replace ofinterest=. if (qru==. & nb_znqru==0) | (qru==0 & nb_znqru==.) | (qru==. & nb_znqru==.)

tab _merge ofinterest


/*
    Result                           # of obs.
    -----------------------------------------
    not matched                           485
        from master                        47  (_merge==1)
        from using                        438  (_merge==2)

    matched                            34,811  (_merge==3)
    -----------------------------------------


	tab _merge ofinterest --> MERGE IS OK

                      |      ofinterest
               _merge |         0          1 |     Total
----------------------+----------------------+----------
       using only (2) |       438          0 |       438 
          matched (3) |    34,331        480 |    34,811 
----------------------+----------------------+----------
                Total |    34,769        480 |    35,249 
	
*/


//missingness for each election

foreach year in 1986 1988 1993 1997 2002 2007 2012 2017{
	
	cap drop test`year'

	gen test`year'=(y`year'_t1_inscrits==.)
	//gen test2`year'=(y`year'_t1_exprimes==.) //Same measure
	
	di "FOR THE ELECTION IN `year'"
	
	tab test`year' if ofinterest==1
}	
	

/*
FOR THE ELECTION IN 1986

   test1986 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        412       85.83       85.83
          1 |         68       14.17      100.00
------------+-----------------------------------
      Total |        480      100.00

FOR THE ELECTION IN 1988

   test1988 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        412       85.83       85.83
          1 |         68       14.17      100.00
------------+-----------------------------------
      Total |        480      100.00

FOR THE ELECTION IN 1993

   test1993 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        480      100.00      100.00
------------+-----------------------------------
      Total |        480      100.00

FOR THE ELECTION IN 1997

   test1997 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        480      100.00      100.00
------------+-----------------------------------
      Total |        480      100.00

FOR THE ELECTION IN 2002

   test2002 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        473       98.54       98.54
          1 |          7        1.46      100.00
------------+-----------------------------------
      Total |        480      100.00

FOR THE ELECTION IN 2007

   test2007 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        480      100.00      100.00
------------+-----------------------------------
      Total |        480      100.00

FOR THE ELECTION IN 2012

   test2012 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        480      100.00      100.00
------------+-----------------------------------
      Total |        480      100.00

FOR THE ELECTION IN 2017

   test2017 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        480      100.00      100.00
------------+-----------------------------------
      Total |        480      100.00


	  
IN 2002 NO DATA ON T1 FOR DEP 71

tab cog if ofinterest==1 & test2002==1

      INSEE |
   communal |
 code (2019 |
  - 2018 if |
    police) |      Freq.     Percent        Cum.
------------+-----------------------------------
      71014 |          1       14.29       14.29
      71076 |          1       14.29       28.57
      71081 |          1       14.29       42.86
      71153 |          1       14.29       57.14
      71270 |          1       14.29       71.43
      71306 |          1       14.29       85.71
      71540 |          1       14.29      100.00
------------+-----------------------------------
      Total |          7      100.00
  
	  
	  
	  
 */	

drop test* ofinterest _merge



save "C:\Users\natha\Dropbox\Crime_and_the_city_Nathan\legislative_wide.dta", replace



















