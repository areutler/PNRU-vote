/*****************************************************************************/
/*																			 */
/*  CONSTRUCTION OF VARIABLES FROM ELECTORAL RESULTS: PRESIDENTIELLES        */
/*																			 */
/*****************************************************************************/
set more off

//cd "$ec_source"

cd "C:\Users\natha\Desktop\Crime_and_the_city_Nathan\ANALYSE\data_election\Présidentielles"

/****************************************************************************/
/****************************************************************************/
/* 1. Append presidential data to create a common database                  */
/****************************************************************************/
/****************************************************************************/
//{ }



// 2002 & 2007

foreach year in 02 07{ 

	import delimited "PR`year'_BVot_T1T2.txt", delimiter(";") varnames(nonames) rowrange(18) clear

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
	rename v13 voix_candidat

	drop v9 v12 //Numéro de dépots & Code sigle/nuance du candidat

	gen year=2000+`year'

	save "pres20`year'.dta", replace
}

//2012

import delimited "PR12_BVot_T1T2.txt", delimiter(";") varnames(nonames) clear

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
rename v15 voix_candidat

drop v5 v6 v11 v14

gen year=2012

save "pres2012.dta"


//2017


import delimited "PR17_BVot_T1_FE.txt", delimiter(";") varnames(nonames) rowrange(18) clear

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

rename v24 nom_candidatDUPONTAIGNAN
rename v25 prenom_candidatDUPONTAIGNAN
rename v26 voix_candidatDUPONTAIGNAN
rename v31 nom_candidatLEPEN
rename v32 prenom_candidatLEPEN
rename v33 voix_candidatLEPEN
rename v38 nom_candidatMACRON
rename v39 prenom_candidatMACRON
rename v40 voix_candidatMACRON
rename v45 nom_candidatHAMON
rename v46 prenom_candidatHAMON
rename v47 voix_candidatHAMON
rename v52 nom_candidatARTHAUD
rename v53 prenom_candidatARTHAUD
rename v54 voix_candidatARTHAUD
rename v59 nom_candidatPOUTOU
rename v60 prenom_candidatPOUTOU
rename v61 voix_candidatPOUTOU
rename v66 nom_candidatCHEMINADE
rename v67 prenom_candidatCHEMINADE
rename v68 voix_candidatCHEMINADE
rename v73 nom_candidatLASSALLE
rename v74 prenom_candidatLASSALLE
rename v75 voix_candidatLASSALLE
rename v80 nom_candidatMELENCHON
rename v81 prenom_candidatMELENCHON
rename v82 voix_candidatMELENCHON
rename v87 nom_candidatASSELINEAU
rename v88 prenom_candidatASSELINEAU
rename v89 voix_candidatASSELINEAU
rename v94 nom_candidatFILLON
rename v95 prenom_candidatFILLON
rename v96 voix_candidatFILLON

drop v1* v2* v3* v4* v5* v6* v7* v8* v9*

preserve
	clear
	
	gen zzzz=.
	save "pres2017_t1.dta", replace
restore
	
foreach name in DUPONTAIGNAN LEPEN MACRON HAMON ARTHAUD POUTOU CHEMINADE LASSALLE MELENCHON ASSELINEAU FILLON{ 
	preserve
		local voix_name="voix_candidat`name'"
		local nom_name="nom_candidat`name'"
		local prenom_name="prenom_candidat`name'"
		
		keep dep name_dep cod_circo name_circo cod_com name_com bdv inscrits abstentions votants blancs nuls exprimes `nom_name' `prenom_name' `voix_name'
	
		rename `prenom_name' prenom_candidat
		rename `nom_name' nom_candidat
		rename `voix_name' voix_candidat
		
		gen tour=1
		
		append using "pres2017_t1.dta"
		
		cap drop zzzz
		
		save "pres2017_t1.dta", replace
	restore
}

**T2

import delimited "PR17_BVot_T2_FE.txt", delimiter(";") varnames(nonames) rowrange(18) clear

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

rename v24 nom_candidatMACRON
rename v25 prenom_candidatMACRON
rename v26 voix_candidatMACRON
rename v31 nom_candidatLEPEN
rename v32 prenom_candidatLEPEN
rename v33 voix_candidatLEPEN

drop v1* v2* v3* 


preserve
	clear
	
	gen zzzz=.
	save "pres2017_t2.dta", replace
restore
	
foreach name in LEPEN MACRON { 
	preserve
		local voix_name="voix_candidat`name'"
		local nom_name="nom_candidat`name'"
		local prenom_name="prenom_candidat`name'"
		
		keep dep name_dep cod_circo name_circo cod_com name_com bdv inscrits abstentions votants blancs nuls exprimes `nom_name' `prenom_name' `voix_name'
	
		rename `prenom_name' prenom_candidat
		rename `nom_name' nom_candidat
		rename `voix_name' voix_candidat
		
		gen tour=2
		
		append using "pres2017_t2.dta"
		
		cap drop zzzz
		
		save "pres2017_t2.dta", replace
	restore
}

use "pres2017_t1.dta", replace
append using "pres2017_t2.dta"


gen year=2017


save "pres2017.dta", replace

erase "pres2017_t1.dta"
erase "pres2017_t2.dta"



//FINAL APPEND
import excel "party_afilliation.xlsx", sheet("partyaffiliation20022017") cellrange(A3:E52) firstrow clear
	
save "partyaffiliation20022017.dta", replace



use "pres2002.dta", replace

foreach year in 07 12 17{ 
	append using "pres20`year'.dta"
}

foreach year in 02 07 12 17{ 
	erase "pres20`year'.dta"
}


merge m:1 year nom_candidat using "partyaffiliation20022017.dta", nogen


/*

   Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                         3,788,298  (_merge==3)
    -----------------------------------------

*/


save "pres_bv.dta", replace

use "pres_bv.dta", clear

/*

Previous communal change to be accounted

*/


** Let's first check if we don't have two similar bdv for the same communes 
isid year tour dep cod_com bdv nom_candidat


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


/*I assumed here that if the fusion is done for a given year, i.e we don't have in 
the same year the merged commune + the old one (this would in this case lead to a 
double addition of the var.).

Seems to be true for the commune which only changed from code.

The fusion of those cities would be done through the collapse below.

Still some issues

tab depcom if _merge==1

     depcom |      Freq.     Percent        Cum.
------------+-----------------------------------
      26383 |         32       51.61       51.61
------------+-----------------------------------
      Total |         62      100.00

No information for 26383
*/

merge m:1 depcom using cog2019

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                            43
        from master                        32  (_merge==1)
        from using                         11  (_merge==2)

    matched                         3,681,466  (_merge==3)
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

duplicates tag year tour cog bdv nom_candidat, gen(dupbdv)

gen bdv2= bdv + name_com
replace bdv2=bdv if dupbdv==0

isid year tour cog bdv2 nom_candidat

drop _merge dep name_dep cod_com name_com depcom bdv dupbdv

rename bdv2 bdv

order year tour cog LIBGEO_2019 bdv  


save "pres_bdv_merged.dta", replace


use "pres_bv.dta", clear

gen missing_abstentions = (abstentions==.)
gen missing_blancs = (blancs==.)
gen missing_nuls = (nuls==.)


collapse (sum) voix_candidat, by(tour dep cod_com name_com year bdv name_dep cod_circo name_circo pol_orisim missing_abstentions missing_blancs missing_nuls inscrits votants exprimes abstentions blancs nuls)

replace abstentions=. if missing_abstentions==1
replace blancs=. if missing_blancs==1
replace nuls=. if missing_nuls==1

rename voix_candidat voix_movement

save "pres_bv_polorisim.dta", replace




** 

use "pres_bv.dta", clear

order year tour dep name_dep cod_com name_com bdv
sort year tour dep cod_com name_com bdv



gen missing_abstentions = (abstentions==.)
gen missing_blancs = (blancs==.)
gen missing_nuls = (nuls==.)

drop name*

collapse (sum) inscrits votants exprimes abstentions blancs nuls voix_candidat, by(tour dep cod_com year cod_circo nom_candidat prenom_candidat pol_ori pol_orisim missing_abstentions missing_blancs missing_nuls)

replace abstentions=. if missing_abstentions==1
replace blancs=. if missing_blancs==1
replace nuls=. if missing_nuls==1


//Checking quality of the collapse
duplicates tag year tour dep cod_com nom_candidat, gen(dup)
tab dup

/*

To be checked - looking rapidly we have sometimes for the same dep and dep_com different circo

        dup |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |  2,078,017       99.82       99.82
          1 |      2,470        0.12       99.94
          2 |        468        0.02       99.96
          3 |        260        0.01       99.97
          4 |        260        0.01       99.98
          6 |         91        0.00       99.99
         17 |        234        0.01      100.00
------------+-----------------------------------
      Total |  2,081,800      100.00


*/




save "pres_comm_tobeappended.dta", replace





********************************************************************************
**																			  **
**								COMMUNAL LEVEL DATAFRAME					  **
**																			  **
********************************************************************************



*** 1981
import delimited "cdsp_presi1981t1_commp9000.csv", clear 

rename * x*

gen year=1981
gen tour=1

rename xcodedãpartement dep
rename xdãpartement name_dep
rename xnumãrocommune cod_com
rename xcommune name_com
rename xexprimãs exprimes
rename xvotants votants
rename xinscrits inscrits

reshape long x, i(dep name_dep cod_com name_com exprimes inscrits votants) j(nom_candidat, string)

rename x voix_candidat

*Nom candidat

replace nom_candidat="LAGUILLER" if nom_candidat=="laguillerlo"
replace nom_candidat="BOUCHARDEAU" if nom_candidat=="bouchardeaupsu"
replace nom_candidat="CHIRAC" if nom_candidat=="chiracrpr"
replace nom_candidat="CREPEAU" if nom_candidat=="crepeaumrg"
replace nom_candidat="DEBRE" if nom_candidat=="debredvd"
replace nom_candidat="GARAUD" if nom_candidat=="garauddvd"
replace nom_candidat="GISCARDDESTAING" if nom_candidat=="giscarddestaingudf"
replace nom_candidat="LALONDE" if nom_candidat=="lalondeeco"
replace nom_candidat="MARCHAIS" if nom_candidat=="marchaispcf"
replace nom_candidat="MITTERRAND" if nom_candidat=="mitterrandps"

save tempfile, replace




*** 1988
**T1
import delimited "cdsp_presi1988t1_commp9000.csv", clear 

rename * x*

gen year=1988
gen tour=1

rename xcodedãpartement dep
rename xdãpartement name_dep
rename xnumãrocommune cod_com
rename xcommune name_com
rename xexprimãs exprimes
rename xvotants votants
rename xinscrits inscrits

reshape long x, i(dep name_dep cod_com name_com exprimes inscrits votants) j(nom_candidat, string)

rename x voix_candidat

*Nom candidat

replace nom_candidat="BARRE" if nom_candidat=="barreudf"
replace nom_candidat="BOUSSEL" if nom_candidat=="bousselmpt"
replace nom_candidat="CHIRAC" if nom_candidat=="chiracrpr"
replace nom_candidat="JUQUIN" if nom_candidat=="juquin"
replace nom_candidat="LAGUILLER" if nom_candidat=="laguillerlo"
replace nom_candidat="LAJOINIE" if nom_candidat=="lajoiniepcf"
replace nom_candidat="LEPEN" if nom_candidat=="lepenfn"
replace nom_candidat="MITTERRAND" if nom_candidat=="mitterrandps"
replace nom_candidat="WAECHTER" if nom_candidat=="waechterv"

append using tempfile
save tempfile, replace



**T2
import delimited "cdsp_presi1988t2_commp9000.csv", clear 

rename * x*

gen year=1988
gen tour=2

rename xcodedãpartement dep
rename xdãpartement name_dep
rename xnumãrocommune cod_com
rename xcommune name_com
rename xexprimãs exprimes
rename xvotants votants
rename xinscrits inscrits

reshape long x, i(dep name_dep cod_com name_com exprimes inscrits votants) j(nom_candidat, string)

rename x voix_candidat

*Nom candidat

replace nom_candidat="CHIRAC" if nom_candidat=="chiracrpr"
replace nom_candidat="MITTERRAND" if nom_candidat=="mitterrandps"

append using tempfile
save tempfile, replace





*** 1995
import delimited "cdsp_presi1995t1_commp9000.csv", clear 

//there is a duplication for Bastia... It is kinda weird
rename * x*

gen year=1995
gen tour=1

rename xcodedãpartement dep
rename xdãpartement name_dep
rename xnumãrocommune cod_com
rename xcommune name_com
rename xexprimãs exprimes
rename xvotants votants
rename xinscrits inscrits

rename xvoy* xxvoy*

drop xv*

rename xxvo* xvo*

reshape long x, i(dep name_dep cod_com name_com exprimes inscrits votants) j(nom_candidat, string)

rename x voix_candidat

*Nom candidat - there does not seem to have voynet in the database 3,32 %

replace nom_candidat="BALLADUR" if nom_candidat=="balladurudf"
replace nom_candidat="CHEMINADE" if nom_candidat=="cheminadepoe"
replace nom_candidat="CHIRAC" if nom_candidat=="chiracrpr"
replace nom_candidat="DEVILLIERS" if nom_candidat=="devilliersmpf"
replace nom_candidat="HUE" if nom_candidat=="huepcf"
replace nom_candidat="JOSPIN" if nom_candidat=="jospinps"
replace nom_candidat="LAGUILLER" if nom_candidat=="laguillerlo"
replace nom_candidat="LEPEN" if nom_candidat=="lepenfn"
replace nom_candidat="VOYNET" if nom_candidat=="voynetverts"


append using tempfile
save tempfile, replace


//append using "pres_comm_tobeappended.dta"


****************************************************************

** 2002

*T1

import excel "presi2002t1_comm.xls", sheet("Tour 1") firstrow clear


rename Codedudépartement dep
rename Libellédudépartement name_dep
rename Codedelacommune cod_com
rename Libellédelacommune name_com
rename Inscrits inscrits
rename Abstentions abstentions
rename Votants votants
rename Blancsetnuls blancsetnuls
rename Exprimés exprimes



rename Nom nom_candidatMEGRET
rename Prénom prenom_candidatMEGRET
rename Voix voix_candidatMEGRET

rename W nom_candidatLEPAGE
rename X prenom_candidatLEPAGE
rename Y voix_candidatLEPAGE

rename AC nom_candidatGLUCKSTEIN
rename AD prenom_candidatGLUCKSTEIN
rename AE voix_candidatGLUCKSTEIN

rename AI nom_candidatBAYROU
rename AJ prenom_candidatBAYROU
rename AK voix_candidatBAYROU

rename AO nom_candidatCHIRAC
rename AP prenom_candidatCHIRAC
rename AQ voix_candidatCHIRAC

rename AU nom_candidatLEPEN
rename AV prenom_candidatLEPEN
rename AW voix_candidatLEPEN

rename BA nom_candidatTAUBIRA
rename BB prenom_candidatTAUBIRA
rename BC voix_candidatTAUBIRA

rename BG nom_candidatSAINTJOSSE
rename BH prenom_candidatSAINTJOSSE
rename BI voix_candidatSAINTJOSSE

rename BM nom_candidatMAMERE
rename BN prenom_candidatMAMERE
rename BO voix_candidatMAMERE

rename BS nom_candidatJOSPIN
rename BT prenom_candidatJOSPIN
rename BU voix_candidatJOSPIN

rename BY nom_candidatBOUTIN
rename BZ prenom_candidatBOUTIN
rename CA voix_candidatBOUTIN

rename CE nom_candidatHUE
rename CF prenom_candidatHUE
rename CG voix_candidatHUE

rename CK nom_candidatCHEVENEMENT
rename CL prenom_candidatCHEVENEMENT
rename CM voix_candidatCHEVENEMENT

rename CQ nom_candidatMADELIN
rename CR prenom_candidatMADELIN
rename CS voix_candidatMADELIN

rename CW nom_candidatLAGUILLER
rename CX prenom_candidatLAGUILLER
rename CY voix_candidatLAGUILLER

rename DC nom_candidatBESANCENOT
rename DD prenom_candidatBESANCENOT
rename DE voix_candidatBESANCENOT

keep dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes voix_candidat*

reshape long voix_candidat, i(dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes) j(nom_candidat, string)

gen year=2002
gen tour=1

append using tempfile

save tempfile, replace



*T2
import excel "presi2002t2_comm.xls", sheet("Tour 2") firstrow clear


rename Codedudépartement dep
rename Libellédudépartement name_dep
rename Codedelacommune cod_com
rename Libellédelacommune name_com
rename Inscrits inscrits
rename Abstentions abstentions
rename Votants votants
rename Blancsetnuls blancsetnuls
rename Exprimés exprimes


rename Nom nom_candidatCHIRAC
rename Prénom prenom_candidatCHIRAC
rename Voix voix_candidatCHIRAC

rename W nom_candidatLEPEN
rename X prenom_candidatLEPEN
rename Y voix_candidatLEPEN

keep dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes voix_candidat*

reshape long voix_candidat, i(dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes) j(nom_candidat, string)

gen year=2002
gen tour=2

append using tempfile

save tempfile, replace





** 2007

*T1
import excel "presi2007t1t2_comm.xls", sheet("Tour 1") firstrow clear

rename Codedudépartement dep
rename Libellédudépartement name_dep
rename Codedelacommune cod_com
rename Libellédelacommune name_com
rename Inscrits inscrits
rename Abstentions abstentions
rename Votants votants
rename Blancsetnuls blancsetnuls
rename Exprimés exprimes

rename Nom nom_candidatBESANCENOT
rename Prénom prenom_candidatBESANCENOT
rename Voix voix_candidatBESANCENOT

rename W nom_candidatBUFFET
rename X prenom_candidatBUFFET
rename Y voix_candidatBUFFET

rename AC nom_candidatSCHIVARDI
rename AD prenom_candidatSCHIVARDI
rename AE voix_candidatSCHIVARDI

rename AI nom_candidatBAYROU
rename AJ prenom_candidatBAYROU
rename AK voix_candidatBAYROU

rename AO nom_candidatBOVE
rename AP prenom_candidatBOVE
rename AQ voix_candidatBOVE

rename AU nom_candidatVOYNET
rename AV prenom_candidatVOYNET
rename AW voix_candidatVOYNET

rename BA nom_candidatDEVILLERS
rename BB prenom_candidatDEVILLIERS
rename BC voix_candidatDEVILLIERS

rename BG nom_candidatROYAL
rename BH prenom_candidatROYAL
rename BI voix_candidatROYAL

rename BM nom_candidatNIHOUS
rename BN prenom_candidatNIHOUS
rename BO voix_candidatNIHOUS

rename BS nom_candidatLEPEN
rename BT prenom_candidatLEPEN
rename BU voix_candidatLEPEN

rename BY nom_candidatLAGUILLER
rename BZ prenom_candidatLAGUILLER
rename CA voix_candidatLAGUILLER

rename CE nom_candidatSARKOZY
rename CF prenom_candidatSARKOZY
rename CG voix_candidatSARKOZY


keep dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes voix_candidat*

reshape long voix_candidat, i(dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes) j(nom_candidat, string)

gen year=2007
gen tour=1

append using tempfile

save tempfile, replace


*T2
import excel "presi2007t1t2_comm.xls", sheet("Tour 2") firstrow clear

rename Codedudépartement dep
rename Libellédudépartement name_dep
rename Codedelacommune cod_com
rename Libellédelacommune name_com
rename Inscrits inscrits
rename Abstentions abstentions
rename Votants votants
rename Blancsetnuls blancsetnuls
rename Exprimés exprimes

rename Nom nom_candidatSARKOZY
rename Prénom prenom_candidatSARKOZY
rename Voix voix_candidatSARKOZY

rename W nom_candidatROYAL
rename X prenom_candidatROYAL
rename Y voix_candidatROYAL


keep dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes voix_candidat*

reshape long voix_candidat, i(dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes) j(nom_candidat, string)

gen year=2007
gen tour=2

append using tempfile

save tempfile, replace






** 2012

*T1

import excel "presi2012t1t2_comm.xls", sheet("Tour 1") firstrow clear

rename Codedudépartement dep
rename Libellédudépartement name_dep
rename Codedelacommune cod_com
rename Libellédelacommune name_com
rename Inscrits inscrits
rename Abstentions abstentions
rename Votants votants
rename Blancsetnuls blancsetnuls
rename Exprimés exprimes

rename Nom nom_candidatJOLY
rename Prénom prenom_candidatJOLY
rename Voix voix_candidatJOLY

rename W nom_candidatLEPEN
rename X prenom_candidatLEPEN
rename Y voix_candidatLEPEN

rename AC nom_candidatSARKOZY
rename AD prenom_candidatSARKOZY
rename AE voix_candidatSARKOZY

rename AI nom_candidatMELENCHON
rename AJ prenom_candidatMELENCHON
rename AK voix_candidatMELENCHON

rename AO nom_candidatPOUTOU
rename AP prenom_candidatPOUTOU
rename AQ voix_candidatPOUTOU

rename AU nom_candidatARTHAUD
rename AV prenom_candidatARTHAUD
rename AW voix_candidatARTHAUD

rename BA nom_candidatCHEMINADE
rename BB prenom_candidatCHEMINADE
rename BC voix_candidatCHEMINADE

rename BG nom_candidatBAYROU
rename BH prenom_candidatBAYROU
rename BI voix_candidatBAYROU

rename BM nom_candidatDUPONTAIGNAN
rename BN prenom_candidatDUPONTAIGNAN
rename BO voix_candidatDUPONTAIGNAN

rename BS nom_candidatHOLLANDE
rename BT prenom_candidatHOLLANDE
rename BU voix_candidatHOLLANDE


keep dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes voix_candidat*

reshape long voix_candidat, i(dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes) j(nom_candidat, string)

gen year=2012
gen tour=1

append using tempfile

save tempfile, replace


*T2

import excel "presi2012t1t2_comm.xls", sheet("Tour 2") firstrow clear

rename Codedudépartement dep
rename Libellédudépartement name_dep
rename Codedelacommune cod_com
rename Libellédelacommune name_com
rename Inscrits inscrits
rename Abstentions abstentions
rename Votants votants
rename Blancsetnuls blancsetnuls
rename Exprimés exprimes

rename Nom nom_candidatHOLLANDE
rename Prénom prenom_candidatHOLLANDE
rename Voix voix_candidatHOLLANDE

rename W nom_candidatSARKOZY
rename X prenom_candidatSARKOZY
rename Y voix_candidatSARKOZY

keep dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes voix_candidat*

reshape long voix_candidat, i(dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes) j(nom_candidat, string)

gen year=2012
gen tour=2

append using tempfile

save tempfile, replace




** 2017

forval tour=1/2{
	import excel "presi2017t`tour'_comm.xls", sheet("Feuil1") firstrow clear

	rename Codedudépartement dep
	rename Libellédudépartement name_dep
	rename Codedelacommune cod_com
	rename Libellédelacommune name_com
	rename Inscrits inscrits
	rename Abstentions abstentions
	rename Votants votants
	rename Blancs blancs
	rename Nuls nuls
	rename Exprimés exprimes

	gen blancsetnuls=blancs+nuls

	rename Nom nom_candidat1
	rename Prénom premon_candidat1
	rename Voix voix_candidat1
	rename AB  nom_candidat2
	rename AC  prenom_candidat2 
	rename AD  voix_candidat2
	cap rename AI  nom_candidat3
	cap rename AJ  prenom_candidat3
	cap rename AK  voix_candidat3
	cap rename AP  nom_candidat4
	cap rename AQ  prenom_candidat4
	cap rename AR  voix_candidat4
	cap rename AW  nom_candidat5
	cap rename AX  prenom_candidat5
	cap rename AY  voix_candidat5
	cap rename BD  nom_candidat6
	cap rename BE  prenom_candidat6
	cap rename BF  voix_candidat6
	cap rename BK  nom_candidat7
	cap rename BL  prenom_candidat7
	cap rename BM  voix_candidat7
	cap rename BR  nom_candidat8
	cap rename BS  prenom_candidat8
	cap rename BT  voix_candidat8
	cap rename BY  nom_candidat9
	cap rename BZ  prenom_candidat9
	cap rename CA  voix_candidat9
	cap rename CF  nom_candidat10
	cap rename CG  prenom_candidat10
	cap rename CH  voix_candidat10
	cap rename CM  nom_candidat11
	cap rename CN  prenom_candidat11
	cap rename CO  voix_candidat11

	keep dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes nom_candidat* voix_candidat*

	reshape long nom_candidat voix_candidat, i(dep name_dep cod_com name_com inscrits abstentions votants blancsetnuls exprimes) j(k)

	drop k

	cap replace nom_candidat="DUPONTAIGNAN" if nom_candidat=="DUPONT-AIGNAN"
	cap replace nom_candidat="LEPEN" if nom_candidat=="LE PEN"
	cap replace nom_candidat="MELENCHON" if nom_candidat=="MÉLENCHON"

	gen year=2017
	gen tour=`tour'
	
	append using tempfile

	save tempfile, replace
}


preserve
	**Importation of party affiliation
	import excel "party_afilliation.xlsx", sheet("partyaffiliation") cellrange(A3:E80) firstrow clear
	
	save "partyaffiliation1981-2017.dta", replace
restore

merge m:1 year nom_candidat using "partyaffiliation1981-2017.dta", nogen //perfect merge


replace blancsetnuls=votants-exprimes if blancsetnuls==.
replace abstentions=inscrits-votants if abstentions==.


order year tour


save "pres_comm.dta", replace
use "pres_comm.dta", clear


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


/* We have for 22 communes, previous communal changes that we need to handle before merging 

    Result                           # of obs.
    -----------------------------------------
    not matched                           163
        from master                       159  (_merge==1)
        from using                          4  (_merge==2)

    matched                         1,020,204  (_merge==3)
    -----------------------------------------


tab year if _merge==1

       Year |      Freq.     Percent        Cum.
------------+-----------------------------------
       1990 |         22       13.84       13.84
       1991 |         22       13.84       27.67
       1992 |         22       13.84       41.51
       1993 |         22       13.84       55.35
       1994 |         18       11.32       66.67
       1995 |         14        8.81       75.47
       1996 |          9        5.66       81.13
       1997 |          9        5.66       86.79
       1998 |          9        5.66       92.45
       1999 |          7        4.40       96.86
       2000 |          4        2.52       99.37
       2001 |          1        0.63      100.00
------------+-----------------------------------
      Total |        159      100.00

*/

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



/*I assumed here that if the fusion is done for a given year, i.e we don't have in 
the same year the merged commune + the old one (this would in this case lead to a 
double addition of the var.).

Seems to be true for the commune which only changed from code.

The fusion of those cities would be done through the collapse below.

Still some issues

tab depcom if _merge==1

     depcom |      Freq.     Percent        Cum.
------------+-----------------------------------
      26383 |         32      100.00      100.00
------------+-----------------------------------
      Total |         32      100.00

No information for 26383 but 75100 is Paris for all

*/

merge m:1 depcom using cog2019

/*

Result                           # of obs.
    -----------------------------------------
    not matched                            73
        from master                        62  (_merge==1)
        from using                         11  (_merge==2)

    matched                         2,093,151  (_merge==3)
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


drop _merge dep name_dep cod_com name_com depcom


collapse (sum) inscrits abstentions votants blancsetnuls exprimes voix_candidat, by(year tour cog nom_candidat party pol_ori pol_orisim)
order cog

/*
preserve 
		gen com=cog

		merge m:1 com using "C:\Users\natha\Desktop\Crime_and_the_city_Nathan\ANALYSE\output\base_communes.dta" 

		/*

			    Result                           # of obs.
				-----------------------------------------
				not matched                        22,902
					from master                    22,104  (_merge==1)
					from using                        798  (_merge==2)

				matched                         1,988,893  (_merge==3)
				-----------------------------------------



		tab year if _merge!=3 & qru==1
		no observations


		tab year if _merge!=3 & nb_zus>0 & nb_zus!=.
		no observations



		SEEMS OK AS A TRANSFORMATION

			
		*/
restore
*/

save "pres_comm_merged.dta", replace


//WIDE BASE


use "pres_comm_merged.dta", clear


/* NO MISSINGS (except for the party (we won't use it))
foreach variable in cog year tour nom_candidat party pol_ori pol_orisim inscrits abstentions votants blancsetnuls exprimes voix_candidat{
	cap drop test
	di "`variable'"
	cap gen test=(`variable'==.)
	cap gen test=(`variable'=="")
	tab test
}
drop test
*/


** Collapsing by the number of vote by movement

collapse (sum) voix_candidat, by(year tour cog inscrits abstentions votants blancsetnuls exprimes pol_orisim)

rename voix_candidat voix_movement


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

We do observe change by communes - only +9000habs in 1981-> 1995

tab year

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       1981 |        856        0.60        0.60
       1988 |        857        0.60        1.21
       1995 |        847        0.60        1.80
       2002 |     34,821       24.54       26.35
       2007 |     34,830       24.55       50.89
       2012 |     34,838       24.55       75.45
       2017 |     34,841       24.55      100.00
------------+-----------------------------------
      Total |    141,890      100.00

*/


preserve
	gen test_inscrit=t1_inscrits-t2_inscrits

	gen test_inscrit2=test_inscrit/t1_inscrits
	
	 gen dup=((test_inscrit2>0.05 | test_inscrit2<-0.05) & test_inscrit2!=.)

	/*
	
	tab year if (test_inscrit2>0.05 | test_inscrit2<-0.05) & test_inscrit2!=.

		   year |      Freq.     Percent        Cum.
	------------+-----------------------------------
		   1988 |          5        3.05        3.05
		   2002 |         48       29.27       32.32
		   2007 |         30       18.29       50.61
		   2012 |         49       29.88       80.49
		   2017 |         32       19.51      100.00
	------------+-----------------------------------
		  Total |        164      100.00
	
	Which ones?
	
	count if dup==1 & t1_inscrits>1000
	26

	count if dup==1 & t1_inscrits>3000
	8

	tab year if dup==1 & t1_inscrits>3000

		   year |      Freq.     Percent        Cum.
	------------+-----------------------------------
		   1988 |          5       62.50       62.50
		   2007 |          1       12.50       75.00
		   2017 |          2       25.00      100.00
	------------+-----------------------------------
		  Total |          8      100.00
		  
	tab cog year if dup==1 & t1_inscrits>3000

		 INSEE |
	  communal |
	code (2019 |
	 - 2018 if |               year
	   police) |      1988       2007       2017 |     Total
	-----------+---------------------------------+----------
		 27284 |         0          1          0 |         1 
		 33522 |         1          0          0 |         1 
		 61001 |         1          0          0 |         1 
		 62048 |         1          0          0 |         1 
		 74008 |         0          0          1 |         1 
		 74243 |         0          0          1 |         1 
		 84007 |         1          0          0 |         1 
		 94037 |         1          0          0 |         1 
	-----------+---------------------------------+----------
		 Total |         5          1          2 |         8 
		  
	We have :
	-  27284: Gisors
	-  33522: Talence
	-  61001: Alençon
	-  62048: Auchel
	-  74008: Ambilly
	-  74243: Saint-Julien-en-Genevois
	-  84007: Avignon
	-  94037: Gentilly
	
	5 of them have QRU or ZUS
	 Code de la |
		commune |      Freq.     Percent        Cum.
	------------+-----------------------------------
		  33522 |          1       20.00       20.00
		  61001 |          1       20.00       40.00
		  62048 |          1       20.00       60.00
		  84007 |          1       20.00       80.00
		  94037 |          1       20.00      100.00
	------------+-----------------------------------
		  Total |          5      100.00

	*/


restore



**BY YEAR

reshape wide t1_inscrits t1_abstentions t1_votants t1_exprimes t1_voix_center_left t1_voix_center_right t1_voix_center t1_voix_diverse t1_voix_extreme_left t1_voix_extreme_right t1_voix_left t1_voix_right t1_blancsetnuls t2_inscrits t2_abstentions t2_votants t2_exprimes t2_voix_center_left t2_voix_center_right t2_voix_center t2_voix_diverse t2_voix_extreme_left t2_voix_extreme_right t2_voix_left t2_voix_right t2_blancsetnuls, i(cog) j(year)

foreach variable in t1_inscrits t1_abstentions t1_votants t1_exprimes t1_voix_center_left t1_voix_center_right t1_voix_center t1_voix_diverse t1_voix_extreme_left t1_voix_extreme_right t1_voix_left t1_voix_right t1_blancsetnuls t2_inscrits t2_abstentions t2_votants t2_exprimes t2_voix_center_left t2_voix_center_right t2_voix_center t2_voix_diverse t2_voix_extreme_left t2_voix_extreme_right t2_voix_left t2_voix_right t2_blancsetnuls{
	rename `variable'* y*_`variable'
}


//correction for t2_inscritsbis

foreach year in 1981 1988 1995 2002 2007 2012 2017{
	gen y`year'_t2_inscritsbis=y`year'_t1_inscrits
}	


save "pres_comm_polorisim.dta", replace




use "pres_comm_polorisim.dta", clear


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
    not matched                           469
        from master                        31  (_merge==1)
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

foreach year in 1981 1988 1995 2002 2007 2012 2017{
	
	cap drop test`year'

	gen test`year'=(y`year'_t1_inscrits==.)
	//gen test2`year'=(y`year'_t1_exprimes==.) //Same measure
	
	di "FOR THE ELECTION IN `year'"
	
	tab test`year' if ofinterest==1
}	
	

/*
FOR THE ELECTION IN 1981

   test1981 |      Freq.     Percent        Cum.
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
	  
FOR THE ELECTION IN 1995

   test1995 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        407       84.79       84.79
          1 |         73       15.21      100.00
------------+-----------------------------------
      Total |        480      100.00
	  
FOR THE ELECTION IN 2002

   test2002 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        480      100.00      100.00
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


WHY MORE IN 1995 ?

tab cog if ofinterest==1 & test1988==0 & test1995==1

      INSEE |
   communal |
 code (2019 |
  - 2018 if |
    police) |      Freq.     Percent        Cum.
------------+-----------------------------------
      13078 |          1       20.00       20.00
      25057 |          1       20.00       40.00
      54382 |          1       20.00       60.00
      59654 |          1       20.00       80.00
      64410 |          1       20.00      100.00
------------+-----------------------------------
      Total |          5      100.00
	  
Around 3000-5000 inscrits -> maybe at the threshold ?!	  

*/	


drop test* ofinterest _merge



save "C:\Users\natha\Dropbox\Crime_and_the_city_Nathan\presidentielle_wide.dta", replace








/*


** Checking between BV collapsed data and communal data


use "pres_comm_tobeappended.dta", clear

drop prenom_candidat cod_circo missing_abstentions missing_blancs missing_nuls
gen blancsetnuls=blancs+nuls
drop blancs nuls

replace nom_candidat="BOVE" if nom_candidat=="BOVÉ"
replace nom_candidat="DUPONTAIGNAN" if nom_candidat=="DUPONT-AIGNAN"
replace nom_candidat="LEPEN" if nom_candidat=="LE PEN"
replace nom_candidat="MELENCHON" if nom_candidat=="MÉLENCHON"
replace nom_candidat="SAINTJOSSE" if nom_candidat=="SAINT-JOSSE"
replace nom_candidat="DEVILLIERS" if nom_candidat=="de VILLIERS"

rename * bdv_*

foreach variable in year tour dep cod_com nom_candidat{
	rename bdv_`variable' `variable'
}

save tempfile, replace


use "pres_comm.dta", clear

keep if year>2001

forval x=1/9{
	replace dep="0`x'" if dep=="`x'"
}

merge 1:m year tour dep cod_com nom_candidat using tempfile

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                           282
        from master                       282  (_merge==1)
        from using                          0  (_merge==2)

    matched                         2,081,800  (_merge==3)
    -----------------------------------------

CONCERN ONLY COMMUNES: dep=="ZM" | dep=="ZN" | dep=="ZP" | dep=="ZS" | dep=="ZW" | dep=="ZZ"


*/


foreach variable in inscrits abstentions votants blancsetnuls exprimes voix_candidat{
	cap drop test test2
	
	di "--------------------------------------------"
	di "Comparison for `variable' variable between BDV collapsed sum and communal data"

	gen test=(`variable'==bdv_`variable')
	
	di "Equal ?"
	tab test
	
	di "Equal for non duplicated communes ?"
	tab test if bdv_dup==0 
	
	
	gen test2=`variable' - bdv_`variable'
	
	di "Summary of the difference"
	
	su test2
	
	di "Summary of the difference for non duplicated communes"
	
	su test2 if bdv_dup==0

}




*/


















/*
collapse (sum) voix_candidat inscrits votants exprimes, by(tour dep cod_com name_com year name_dep cod_circo name_circo abstentions blancs nuls pol_ori)

reshape wide voix_candidat, i(tour dep cod_com name_com bdv inscrits votants exprimes year name_dep) j(pol_ori) string

//Can't put cod_circo name_circo abstentions blancs nuls due to missings


order year tour dep name_dep cod_com name_com bdv
sort year tour dep cod_com name_com bdv






**

gen missing_abstentions = (abstentions==.)
gen missing_blancs = (blancs==.)
gen missing_nuls = (nuls==.)


collapse (sum) inscrits votants exprimes abstentions blancs nuls voix_candidat, by(tour dep cod_com name_com year name_dep cod_circo name_circo pol_ori missing_abstentions missing_blancs missing_nuls)

*/





/****************************************************************************/
/****************************************************************************/
/* 2. Merge with BDV geolocalisation   		                                */
/****************************************************************************/
/****************************************************************************/


















