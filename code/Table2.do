*cd should be set to obesity folder
use "data/derived/panel.dta", clear

* Set up panel data
xtset schoolcode year

* Indicators for restaurants within x miles
foreach v of varlist ffood afood{
	forvalues i = 1/3 {
		gen `v'_`i' = (`v'>=1 & `v'<=`i')
	}
}
lab var ffood_1 "Availability of fast food restaurant within 0.1 miles"
lab var ffood_2 "Availability of fast food restaurant within 0.25 miles"
lab var ffood_3 "Availability of fast food restaurant within 0.5 miles"
lab var afood_1 "Availability of other restaurant within 0.1 miles"
lab var afood_2 "Availability of other restaurant within 0.25 miles"
lab var afood_3 "Availability of other restaurant within 0.5 miles"

*Variables to include
global restaurants "ffood_1 afood_1 ffood_2 afood_2 ffood_3 afood_3" 
global schoolvars "rttitlei rtnostud rtpupiltc rtblack rtasian rthispanic rtindian rtmigrant rtfemale rtfreelcelig rtfteteachers rttestsc9 rtdmtestsc9 "
global sdvars "rtpupiltcds rtmigrantds rtlepellds rtiepds rtstaffds rtdiplomarecds rtdmdiplomarecds "
global censusvars "medhhinc medearn avghhsize medcontrent medgrossrent medvalue pctwhite pctblack pctasian pctmale pctnevermarried pctmarried pctdivorced pctHSdiponly pctsomecollege pctassociate pctbachelors pctgraddegree pctinlaborforce  pctunemployed pctincunder10k pctincover200k pcthhwithwages pctoccupied pctpopownerocc pcturban "
global outcomevar "fit9Obes "

eststo m1: reg $outcomevar $restaurants [w=no9Obes]
mat def B = e(b)
local imp = round(B[1,1] + B[1,3] + B[1,5], 0.0001)
outreg2 using tables/Table2.txt, replace excel tex(pretty) ctitle(" ") label dec(4) keep($restaurants) nocons ///
addtext(School fixed effects, ---, Year fixed effects, ---, School controls, ---, Census block controls, ---,  Implied cumulative effect, "`imp'")

eststo m2: reg $outcomevar $restaurants i.year $schoolvars $sdvars $censusvars [w=no9Obes]
mat def B = e(b)
local imp = B[1,1] + B[1,3] + B[1,5]
local imp = round(B[1,1] + B[1,3] + B[1,5], .0001)
outreg2 using tables/Table2.txt, append excel tex(pretty) ctitle(" ")  label dec(4)  keep($restaurants) nocons ///
addtext(School fixed effects, ---, Year fixed effects, Yes, School controls, Yes, Census block controls, Yes,  Implied cumulative effect, "`imp'")

eststo m3: areg $outcomevar $restaurants [w=no9Obes], a(schoolcode)
mat def B = e(b)
local imp = round(B[1,1] + B[1,3] + B[1,5], 0.0001)
outreg2 using tables/Table2.txt, append excel tex(pretty) ctitle(" ")  label dec(4)  keep($restaurants) nocons ///
addtext(School fixed effects, Yes, Year fixed effects, ---, School controls, ---, Census block controls, ---,  Implied cumulative effect, "`imp'")

eststo m4: areg $outcomevar $restaurants i.year $schoolvars $sdvars $censusvars [w=no9Obes], a(schoolcode)
mat def B = e(b)
local imp = round(B[1,1] + B[1,3] + B[1,5], 0.0001)
outreg2 using tables/Table2.txt, append excel tex(pretty) ctitle(" ")  label dec(4)  keep($restaurants) nocons ///
addtext(School fixed effects, Yes, Year fixed effects, Yes, School controls, Yes, Census block controls, Yes,   Implied cumulative effect, "`imp'")
