set more off
clear all

*cd should be set to obesity folder
*cd "C:\Users\bozai\Documents\PHD\EmpiricalResearch\Assignment2"  
*use "data/derived/finaldata.dta", clear
use "data/derived/panel.dta", clear

*Place to save tables
cap mkdir "tables"
*cd "tables"

*Variables to include
global schoolvars "rttitlei rtnostud rtpupiltc rtblack rtasian rthispanic rtindian rtmigrant rtfemale rtfreelcelig rtfteteachers rttestsc9 rtdmtestsc9 "
global sdvars "rtpupiltcds rtmigrantds rtlepellds rtiepds rtstaffds rtdiplomarecds rtdmdiplomarecds "
global censusvars "medhhinc medearn avghhsize medcontrent medgrossrent medvalue pctwhite pctblack pctasian pctmale pctnevermarried pctmarried pctdivorced pctHSdiponly pctsomecollege pctassociate pctbachelors pctgraddegree pctinlaborforce  pctunemployed pctincunder10k pctincover200k pcthhwithwages pctoccupied pctpopownerocc pcturban "
global outcomevars "fit9Obes "


*Stand in variables for empty rows + titles
gen outcomes=. 
lab var outcomes "Outcomes"
gen census=.
lab var census "Census Demographics of nearest block"
gen school=.
lab var school "School Characteristics"
gen schoolds=.
lab var schoolds "School district characteristics"

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

	*Write cells("mean" fmt(3))
	bysort ffood_excl: eststo: quietly estpost summarize Nobs rtnostud school $schoolvars schoolds $sdvars 	census $censusvars outcomes $outcomevars
	esttab using tables/Table1A.txt, cells("mean(fmt(%12.3g))") label replace mtitles("All" "<0.5 miles FF" "<0.25 miles FF" "<0.1 miles FF") ///
	nonumber title("Summary Statistics for California School Data")
	esttab using tables/Table1A.tex, cells("mean(fmt(%12.3g))") label replace tex mtitles("All" "<0.5 miles FF" "<0.25 miles FF" "<0.1 miles FF") ///
	nonumber

restore

*The number of observations and some variables are totally off, maybe I use wrong categories or weights?

