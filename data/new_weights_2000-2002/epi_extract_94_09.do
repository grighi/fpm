** use for 94 onward up to 2009 Q4 **

cd "C:\earncps\"

clear

set more off
set memory 500m

forvalues year = 2009/2009 {
	tempfile yearfile
	clear

	forvalues month = 1/12 {
		tempfile monthfile
		clear

		local subyear = substr("`year'",-2,2)
		local submonth = substr(string(`month'+100),-2,2)

		if `year'==2007 & `month'==12 {
			quietly infile using programs\monthly\dictionaries\dict_94_07, using                                (1_rawdata\monthly\dec07pub.dat)		
		}	
		
		else {
		  quietly infile using programs\monthly\dictionaries\dict_94_07, using                       (1_rawdata\monthly\cpsb`subyear'`submonth'.)
		}
		keep if _prpertyp>=1 & _prpertyp<=3

		scalar yrmo=`year'*100+`month'

		if yrmo<199509 replace _hrhhid=_hrhhid_94
		if yrmo<199801 {
			replace _hrmonth=_hrmonth_94
			drop _qstnum _occurnum _pwcmpwgt
		}
		if yrmo<200301 {
			replace _peio1icd=_peio1icd_98
			replace _peio1ocd=_peio1ocd_98
		}
		if yrmo<200405 replace _hrhhid2=_hrhhid2_94
		drop _hrhhid_94 _hrhhid2_94 _hrmonth_94 _peio1icd_98 _peio1ocd_98

		replace _gtco=. if `year'<=1995
		replace _gemsa=. if (`year'==2004 & _hrmonth>=5) | `year'>=2005
		replace _gemsast=. if (`year'==2004 & _hrmonth<=4) | `year'<=2003

		quietly compress
		save `monthfile', replace;;
		clear

		if `year'==2000 | `year'==2001 | `year'==2002 {
			quietly infile using programs\monthly\dictionaries\dict_00_02_update, using (1_rawdata\monthly\rw`subyear'`submonth'.dat)
			merge _qstnum _hrmonth _occurnum using `monthfile', unique sort
			drop if _hrhhid==""
			drop _merge
			quietly compress
			save `monthfile', replace;;
			clear
		}
		
		if `year'==2007 & `month'==12 {
			quietly infile using programs\monthly\dictionaries\dict_dec07_update, using (1_rawdata\monthly\dec07revwgts.dat)
			merge _qstnum _occurnum using `monthfile', unique sort
			*drop if _hrhhid==""
			drop _merge
			replace _pwsswgt=_decwgt
			replace _pwcmpwgt=_declfwgt
			quietly compress
			save `monthfile', replace;;
			clear
		}
		if `month'==1 {
			use `monthfile'
			save `yearfile', replace;;
			clear
		}
			else {
				use `yearfile'
				append using `monthfile'
				save `yearfile', replace;;
				clear
			}
	}

	use `yearfile'
	save 2_extracts\monthly\ext`year', replace;;
	clear
}

#delimit cr
