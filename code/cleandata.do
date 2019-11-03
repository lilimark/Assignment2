* Cleaning data
* Istvan Boza, Lili Mark
* Oct 29, 2019

* cd should be set to obesity folder
clear 

cd data/raw/
forvalues y = 1999/2007 {
	use SchoolData`y'.dta
	cap merge 1:1 schoolcode using RestaurantData`y'.dta, nogen 
	cap merge 1:1 schoolcode using SchoolCensusData`y'.dta, nogen
	save merged_`y'.dta, replace
}

* value labels
use merged_1999.dta, clear
label variable ffood "var label of ffood"
label variable afood "var label of afood"
lab def counting 0"zero" 1"one" 2"two" 3"three"
//tabmiss ffood afood
destring ffood afood, replace
//tabmiss ffood afood
lab val ffood afood counting

