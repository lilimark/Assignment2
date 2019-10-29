* Clea, ning data
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
