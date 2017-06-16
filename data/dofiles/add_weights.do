/* YEAR 2000 */

use "cpsjan00", clear

foreach month in feb mar apr may jun jul aug sep oct nov dec {
	append using "cps`month'00"
}

merge 1:1 hrmonth qstnum occurnum using ///
	"new_weights_2000-2002/dta/cps_rev00.dta"
drop if _merge==2
drop _merge

compress
save "dta/cps_monthly_00", replace

label drop _all



/* YEAR 2001 */

use "cpsjan01", clear

foreach month in feb mar apr may jun jul aug sep oct nov dec {
	append using "cps`month'01"
}

merge 1:1 hrmonth qstnum occurnum using ///
	"new_weights_2000-2002/dta/cps_rev01.dta"
drop if _merge==2
drop _merge

compress
save "dta/cps_monthly_01", replace 

label drop _all



/* YEAR 2002 */

use "cpsjan02", clear

foreach month in feb mar apr may jun jul aug sep oct nov dec {
	append using "cps`month'02"
}


merge 1:1 hrmonth qstnum occurnum using ///
	"new_weights_2000-2002/dta/cps_rev02.dta"
drop if _merge==2
drop _merge

compress
save "dta/cps_monthly_02", replace 

label drop _all


#delimit cr
