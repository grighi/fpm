/* init.do
   Pablo Mitnik and Erin Cumberworth, January 2012
   
   This do-file outputs three DTA files that contain revised weights for the 2000-2002
   CPS monthly files (based on Census 2000 rather than Census 1990) and revised occupation
   and industry variables, together with merging information so that the revised weights 
   can be merged onto the regular files for that month. 
   
   The data files are downloaded from http://www.bls.census.gov/cps_ftp.html#cpsbasic_extract.
   The data dictionary is from the Economic Policy Institute.

*/


clear

set more off

foreach year in 00 01 02 {

	foreach month in jan feb mar apr may jun jul aug sep oct nov dec {
	

		tempfile `month'`year'

		quietly infile using epi_dict_00_02_update, using (`month'`year'pubuse_2000b.dat)
		
		foreach var in qstnum hrmonth occurnum {
			rename _`var' `var'
		}			

		save ``month'`year'', replace
		
		clear
		
	}	

	use `jan`year'', clear
		
		foreach month in feb mar apr may jun jul aug sep oct nov dec {
		
			append using ``month'`year''

	}
	
	compress
	save "dta/cps_rev`year'.dta", replace
	
	label drop _all
	clear


}	





#delimit cr
