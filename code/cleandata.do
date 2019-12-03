* cd should be set to obesity folder
clear 	clear 


cd data/raw/	* defining value label to be used 
lab def counting 0"zero" 1"one" 2"two" 3"three"

* merge and add value label
forvalues y = 1999/2007 {	forvalues y = 1999/2007 {
	use SchoolData`y'.dta		use data/raw/SchoolData`y'.dta
	cap merge 1:1 schoolcode using RestaurantData`y'.dta, nogen 		cap merge 1:1 schoolcode using data/raw/RestaurantData`y'.dta, nogen 
	cap merge 1:1 schoolcode using SchoolCensusData`y'.dta, nogen		cap merge 1:1 schoolcode using data/raw/SchoolCensusData`y'.dta, nogen
	save merged_`y'.dta, replace		cap label variable ffood "var label of ffood"
	cap label variable afood "var label of afood"
	cap tabmiss afood ffood
	cap destring ffood afood, replace
	cap tabmiss afood ffood
	cap lab val ffood afood counting
	save data/raw/merged_`y'.dta, replace
}	}


* value labels	* panel structure
use merged_1999.dta, clear	use data/raw/merged_1999.dta, clear
label variable ffood "var label of ffood"	forvalues y = 2000/2007 {
label variable afood "var label of afood"		append using data/raw/merged_`y'.dta
lab def counting 0"zero" 1"one" 2"two" 3"three"	}
//tabmiss ffood afood	save data/raw/panel.dta, replace
destring ffood afood, replace	
//tabmiss ffood afood	
