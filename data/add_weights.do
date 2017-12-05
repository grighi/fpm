/* This file adds weights for early years to monthly files. 
 * It borrows from the concatenate_cps file on the Stanford sociology AFS.
 * Giovanni Righi
 * 30 May 2017
 */


/* YEAR 2000 */

foreach yr in 00 01 02 {

	foreach month in jan feb mar apr may jun jul aug sep oct nov dec {
		
		use "cps`month'`yr'", clear

		merge 1:1 hrmonth qstnum occurnum using ///
	  	  "new_weights_2000-2002/dta/cps_rev`yr'.dta"
		drop if _merge==2
		drop _merge

		compress
		save "dta/cps`month'`yr'", replace

		label drop _all
}




