/*****************************************************************************/
/*																			 */
/*  CONSTRUCTION OF VARIABLES FROM ELECTORAL RESULTS: PRESIDENTIELLES        */
/*																			 */
/*****************************************************************************/
set more off

//cd "$ec_source"

cd "C:\Users\natha\Desktop\Crime_and_the_city_Nathan\ANALYSE\data_election\Municipales"

/****************************************************************************/
/****************************************************************************/
/* 1. Append municipal data to create a common database                  */
/****************************************************************************/
/****************************************************************************/
//{ }




************* AT THE BUREAU DE VOTE LEVEL **************************

* 2014

import delimited "MN14_BVot_T1T2.txt", delimiter(";") varnames(nonames) rowrange(18) clear

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
rename v12 partyaffiliation
rename v13 voix_candidat


replace partyaffiliation="" if partyaffiliation=="NC"
replace partyaffiliation=substr(partyaffiliation,2,.)

drop v9

gen year=2014

tostring cod_com, replace
cap tostring bdv, replace
//cap tostring , replace

save tempfile, replace






*2008

import delimited "MN08_BVot_T1T2.txt", delimiter(";") rowrange(3) varname(nonames) clear

rename * x*

rename xv2 dep
rename xv3 name_dep
rename xv4 cod_com
rename xv5 name_com
rename xv6 bdv
rename xv7 inscrits
rename xv8 abstentions
rename xv10 votants
rename xv12 blancsnuls
rename xv15 exprimes


forval x=1/12{
	global y1=`x'*9+9
	global y2=`x'*9+10
	global y3=`x'*9+11
	global y4=`x'*9+12
	global y5=`x'*9+13
	global y6=`x'*9+14
	global y7=`x'*9+15
	global y8=`x'*9+16
	global y9=`x'*9+17
	
	rename xv$y1 codenuance`x'
	rename xv$y2 sexe`x'
	rename xv$y3 nom`x'
	rename xv$y4 prenom`x'
	rename xv$y5 liste`x'
	rename xv$y6 sieges`x'
	rename xv$y7 voix`x'	
}

drop xv*

//For later use, we identify the possible different tour

gen numberofcandidate=(nom1!="") + (nom2!="") + (nom3!="") + (nom4!="") + (nom5!="") + (nom6!="") + (nom7!="") + (nom8!="") + (nom9!="") + (nom10!="") + (nom11!="") + (nom12!="")
drop if numberofcandidate==0 | numberofcandidate==. //one empty line
drop sieges*
drop if voix1=="Voix"



preserve	
	keep dep name_dep cod_com name_com numberofcandidate
	duplicates drop
	duplicates tag dep name_dep cod_com name_com, gen(test)
	tab test
	
	/*
	
	
       test |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      1,993       61.42       61.42
          1 |      1,226       37.78       99.20
          2 |          6        0.18       99.38
          4 |          5        0.15       99.54
          5 |          6        0.18       99.72
          8 |          9        0.28      100.00
------------+-----------------------------------
      Total |      3,245      100.00

	  Issue for Paris, Lyon and Marseille....	
	*/
	
	
	
	//Checking
	
	
	bys dep name_dep cod_com name_com: egen maxcandidate=max( numberofcandidate )
	bys dep name_dep cod_com name_com: egen mincandidate=min( numberofcandidate )
	
	gen possibleproblème= ( maxcandidate == mincandidate )
	tab possibleproblème if test!=0 //OK
	
	/*
	
	tab mincandidate if test==1

	mincandidat |
			  e |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  1 |          6        0.49        0.49
			  2 |        734       59.87       60.36
			  3 |        410       33.44       93.80
			  4 |         74        6.04       99.84
			  5 |          2        0.16      100.00
	------------+-----------------------------------
		  Total |      1,226      100.00

	  TO BE PRESENT IN 2ND TURN - NEED 10% ONLY
	
	
	*/
	
	gen tour=1+(numberofcandidate==mincandidate & test==1)
	replace tour=. if test>1
	
	keep dep name_dep cod_com name_com numberofcandidate tour 
	
	save "tourmunic2008.dta", replace
	
restore

//duplicates tag dep name_dep cod_com name_com bdv, gen(tour_dup)

merge m:1 dep name_dep cod_com name_com numberofcandidate using "tourmunic2008.dta" //perfect merge




//It was impossible to reshape since we had duplicates for both tour : which were not indicated... I thus create those

duplicates tag dep name_dep cod_com name_com bdv inscrits abstentions votants blancsnuls exprimes, gen(test)

/*
gen tour=.
replace tour=1 if test==1

replace tour=2 if test==1 & voix3==.
replace tour=2 if test==1 & voix4==. & name_com!="Nangis"

replace tour=2 if test==1 & voix5==. & name_com=="Hyères"
*/


destring voix1, replace
reshape long codenuance sexe nom prenom liste voix, i( dep cod_com name_com bdv inscrits abstentions votants blancsnuls exprimes tour) j(number)

drop numberofcandidate _merge test number
drop if dep==""

drop if sexe=="" & nom=="" & prenom=="" & liste=="" & voix==.


destring inscrits, replace
destring votants, replace
destring abstentions, replace
destring blancsnuls , replace
destring exprimes, replace

rename voix voix_candidat
rename nom nom_candidat
rename prenom prenom_candidat

gen partyaffiliation=substr(codenuance,2,.)
drop codenuance

gen year=2008


append using tempfile


replace abstentions=inscrits-votants if abstentions==.
replace blancsnuls=votants-exprimes if blancsnuls==.


save "munic_bv.dta", replace






********** AT THE COMMUNAL LEVEL 

** IN 1983 - +9000hab

import excel "cdsp_muni1983t1_commp9000-ag.xls", sheet("cdsp_muni1983t1_commp9000-ag") cellrange(A5:T904) firstrow clear
rename * x*

gen year=1983
gen tour=1

rename xCodedépartement dep
rename xDépartement dep_name
rename xCodecommune cod_com
rename xCommune name_com
rename xInscrits inscrits
rename xVotants votants
rename xExprimés exprimes
rename xBlancsetnuls blancsetnuls

reshape long x, i(year tour dep dep_name cod_com name_com inscrits votants exprimes blancsetnuls) j(political_party, string)

rename x voix_party



save tempfile, replace

import excel "C:\Users\natha\Desktop\Crime_and_the_city_Nathan\ANALYSE\data_election\Municipales\cdsp_muni1983t2_commp9000-ag.xls", sheet("cdsp_muni1983t2_commp9000-ag") cellrange(A3:R153) firstrow clear

rename * x*


gen year=1983
gen tour=2


rename xCodedépartement dep
rename xDépartement dep_name
rename xCodecommune cod_com
rename xCommune name_com
rename xInscrits inscrits
rename xVotants votants
rename xExprimés exprimes
rename xBlancsetnuls blancsetnuls

reshape long x, i(year tour dep dep_name cod_com name_com inscrits votants exprimes blancsetnuls) j(political_party, string)

rename x voix_party

append using tempfile
save tempfile, replace





** IN 1989

import excel "cdsp_muni1989t1_commp9000-ag.xls", sheet("cdsp_muni1989t1_commp9000-ag") cellrange(A5:T931) firstrow clear

rename * x*

gen year=1989
gen tour=1


rename xCodedépartement dep
rename xDépartement dep_name
rename xCodecommune cod_com
rename xCommune name_com
rename xInscrits inscrits
rename xVotants votants
rename xExprimés exprimes
rename xBlancsetnuls blancsetnuls

reshape long x, i(year tour dep dep_name cod_com name_com inscrits votants exprimes blancsetnuls) j(political_party, string)

rename x voix_party

append using tempfile
save tempfile, replace


import excel "cdsp_muni1989t2_commp9000-ag.xls", sheet("cdsp_muni1989t2_commp9000-ag") cellrange(A5:S404) firstrow clear

rename * x*

gen year=1989
gen tour=2


rename xCodedépartement dep
rename xDépartement dep_name
rename xCodecommune cod_com
rename xCommune name_com
rename xInscrits inscrits
rename xVotants votants
rename xExprimés exprimes
rename xBlancsetnuls blancsetnuls

reshape long x, i(year tour dep dep_name cod_com name_com inscrits votants exprimes blancsetnuls) j(political_party, string)

rename x voix_party

append using tempfile
save tempfile, replace




** IN 1995
import excel "cdsp_muni1995t1_commp9000-ag.xls", sheet("cdsp_muni1995t1_commp9000-ag") cellrange(A6:U967) firstrow clear

rename * x*

gen year=1995
gen tour=1


rename xCodedépartement dep
rename xDépartement dep_name
rename xCodecommune cod_com
rename xCommune name_com
rename xInscrits inscrits
rename xVotants votants
rename xExprimés exprimes

gen blancsetnuls=votants-exprimes

reshape long x, i(year tour dep dep_name cod_com name_com inscrits votants exprimes blancsetnuls) j(political_party, string)

rename x voix_party

append using tempfile
save tempfile, replace


import excel "cdsp_muni1995t2_commp9000-ag.xls", sheet("cdsp_muni1995t2_commp9000-ag") cellrange(A7:U577) clear firstrow


rename * x*

gen year=1995
gen tour=2


rename xCodedépartement dep
rename xDépartement dep_name
rename xCodecommune cod_com
rename xCommune name_com
rename xInscrits inscrits
rename xVotants votants
rename xExprimés exprimes

gen blancsetnuls=votants-exprimes

reshape long x, i(year tour dep dep_name cod_com name_com inscrits votants exprimes blancsetnuls) j(political_party, string)

rename x voix_party

append using tempfile

tostring cod_com, replace
save tempfile, replace



** IN 2001

import excel "cdsp_muni2001t1_commp9000-ag.xls", sheet("cdsp_muni2001t1_commp9000-ag") cellrange(A6:U1048) firstrow clear

rename * x*

gen year=2001
gen tour=1


rename xCodedépartement dep
rename xDépartement dep_name
rename xCodecommune cod_com
rename xCommune name_com
rename xPopulation population
rename xInscrits inscrits
rename xAbstentions abstentions
rename xVotants votants
rename xBlancsetnuls blancsetnuls
rename xExprimés exprimes


reshape long x, i(year tour dep dep_name cod_com name_com inscrits votants exprimes blancsetnuls) j(political_party, string)

rename x voix_party


append using tempfile
save tempfile, replace


import excel "cdsp_muni2001t2_commp9000-ag.xls", sheet("cdsp_muni2001t2_commp9000-ag") cellrange(A6:U519) firstrow clear

rename * x*

gen year=2001
gen tour=2


rename xCodedépartement dep
rename xDépartement dep_name
rename xCodecommune cod_com
rename xCommune name_com
rename xPopulation population
rename xInscrits inscrits
rename xAbstentions abstentions
rename xVotants votants
rename xBlancsetnuls blancsetnuls
rename xExprimés exprimes


reshape long x, i(year tour dep dep_name cod_com name_com inscrits votants exprimes blancsetnuls) j(political_party, string)

rename x voix_party


append using tempfile

save "munic_comm9000.dta", replace







** IN 2008



** IN 2014




