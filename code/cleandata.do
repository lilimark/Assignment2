* Cleaning data
* Istvan Boza, Lili Mark
* Oct 29, 2019

* cd should be set to obesity folder
clear 

* defining value label to be used 
lab def counting 0"zero" 1"one" 2"two" 3"three"

* merge and add value label
forvalues y = 1999/2007 {

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

*labeling
label variable ffood "var label of ffood"
label variable afood "var label of afood"
lab val ffood afood counting

save data/raw/panel.dta, replace
