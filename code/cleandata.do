* Cleaning data
* Istvan Boza, Lili Mark
* Oct 29, 2019

* cd should be set to obesity folder
clear 

* defining value label to be used 
lab def counting 0"zero" 1"one" 2"two" 3"three"

* merge and add value label
forvalues y = 1999/2007 {
	use data/raw/SchoolData`y'.dta
	cap merge 1:1 schoolcode using data/raw/RestaurantData`y'.dta, nogen 
	cap merge 1:1 schoolcode using data/raw/SchoolCensusData`y'.dta, nogen
	cap label variable ffood "var label of ffood"
	cap label variable afood "var label of afood"
	cap tabmiss afood ffood
	cap destring ffood afood, replace
	cap tabmiss afood ffood
	cap lab val ffood afood counting
	save data/raw/merged_`y'.dta, replace
}

* panel structure
use data/raw/merged_1999.dta, clear
forvalues y = 2000/2007 {
	append using data/raw/merged_`y'.dta
}
save data/raw/panel.dta, replace
