* cd should be set to obesity folder
clear 

forvalues  y = 1999/2007{
	if `y'!=2000 {
		use data/raw/SchoolData`y'.dta
		merge 1:1 schoolcode using data/raw/RestaurantData`y'.dta, nogen 
		merge 1:1 schoolcode using data/raw/SchoolCensusData`y'.dta, nogen
		destring ffood afood, replace
		save data/raw/merged_`y'.dta, replace
	}
}

* panel structure
use data/raw/merged_1999.dta, clear
forvalues y = 2001/2007 {
	append using data/raw/merged_`y'.dta
	erase data/raw/merged_`y'.dta
}
erase data/raw/merged_1999.dta

* defining value label to be used 
label var ffood "Fast food"
label define fast ///
	0 "No ffood" /// 
	1 "fast food within 0.1 miles" ///
	2 "fast food 0.10-0.25 miles" ///
	3 "fast food within 0.25-0.5 miles"
label values ffood fast

label var afood "Any restaurant"
label define any ///
	0 "No afood" ///
	1 "any restaurant within 0.1 miles" ///
	2 "any restaurant 0.10-0.25 miles" ///
	3 "any restaurant within 0.25-0.5 miles"
label values afood any

save data/derived/panel.dta, replace
