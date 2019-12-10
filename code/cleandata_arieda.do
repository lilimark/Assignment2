clear all 

*Loop over the file and merge the data sets

* Merge files over a loop.
forvalues year=1999/2007 {

	* Skip 2000.
	if `year'!=2000 {
	
		* Load the school data  
		use "data/raw/SchoolData`year'",clear
		
		* Merge with restaurant data
		merge 1:1 schoolcode using "data/raw/RestaurantData`year'", nogen

		*  Merge with Census
		merge 1:1 schoolcode using "data/raw/SchoolCensusData`year'", nogen

		* Save temporary files to memory.
		tempfile temp`year'_dataset
		save "`temp`year'_dataset'"

	}
	
}


use `temp1999_dataset', clear

* Loop over the remaining years, appending the temporary data sets
forvalues year=2001/2007{

	append using "`temp`year'_dataset'"

}

* Destring variables
destring ffood* afood, replace


* Apply variable labels to the data set
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
	3 "any restaurant within 0.25 0.5 miles"
label values afood any

save "data/derived/finaldata.dta", replace 
