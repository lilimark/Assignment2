set more off
clear all

cd "C:\Users\bozai\Documents\PHD\EmpiricalResearch\Assignment2"  
use "data/derived/finaldata.dta", clear

*Place to save tables
cap mkdir "tables"
cd "tables"

*Variables to include
global schoolvars "rtblack rtasian rthispanic rtindian rtmigrant rtfemale rtfreelcelig"
global censusvars "medearn pctHSdiponly pctunemployed pcturban "
global outcomevars "fit9Obes "


*Stand in variables for empty rows + titles
gen outcomes=. 
lab var outcomes "Outcomes"
gen census=.
lab var census "Census Demographics of nearest block"
gen school=.
lab var school "School Characteristics"



*As categories are overlapping, we do a little trick
preserve

	*Make 4 rows of each observations
	gen id=_n
	expand 4
	bysort id: gen n2=_n

	*Do overlapping categories
	gen ffood_excl=.
	replace ffood_excl=1 if n2==1
	replace ffood_excl=2 if n2==2 & ffood>=1 & ffood<=3
	replace ffood_excl=3 if n2==3 & ffood>=1 & ffood<=2
	replace ffood_excl=4 if n2==4 & ffood>=1 & ffood<=1

	*Observations by the new groups
	bysort ffood_excl: gen Nobs=_N
	lab var Nobs "Observations"

	*Write
	bysort ffood_excl: eststo: quietly estpost summarize Nobs rtnostud school $schoolvars 	census $censusvars outcomes $outcomevars [aw=no9Obes]
	esttab using Table1A.txt, cells("mean") label replace 

restore

*The number of observations and some variables are totally off, maybe I use wrong categories or weights?

