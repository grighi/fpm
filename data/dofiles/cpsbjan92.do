log using cpsbjan92, replace
set mem 50m
*by Jean Roth Wed Apr 18 10:17:06 EDT 2001
*Please report errors to jroth@nber.org
*Change output file name/location as desired
*If you are using a PC, you may need to change the direction of the slashes, as in C:\
*  or "\\Nber\home\data\cps-basic\cpsb9201.raw"

*All items, except those with one character, also can have values 
*of -1, -2, or -3 even if the values are not in the documentation
*The meaning is
*       -1 .Blank or not in universe
*       -2 .Don't know
*       -3 .Refused
* The following changes in variable names have been made: 
*      '$' to 'd';            '-' to '_';              '%' to 'p';
*      ($ = unedited data;     - = edited data;         % = allocated data)
* Note:  Variable names in Stata are case-sensitive             
* This program contains the layout for Adult, Child, and Armed Forces
* records.  They are identical from column 1-161.  Child-only variables
* begin with a 'c' and AF-only variables begin with an 'm'.
* Use h_rectyp to select record types of interest.
clear
quietly infile using cpsbjan92


*All the rest are labels

#delimit ;
;
label values hdcpschk P1L;    
label define P1L     
	1           "ONLY CPS-1 FOR HOUSEHOLD"      
	2           "FIRST CPS-1 OF CONTINUATION HOUSEHOLD"
	3           "SECOND CPS-1 OF CONTINUATION HOUSEHOLD"
	4           "THIRD, FOURTH, ETC. CPS-1"     
;
label values hdlivqrt P2L;    
label define P2L     
	1           "HOUSE, APT., FLAT"             
	2           "HU IN NONTRANSIENT HOTEL, ETC."
	3           "HU, PERM, IN TRANS. HOTEL, MOTEL ETC."
	4           "HU IN ROOMING HOUSE"           
	5           "MOBILE HOME OR TRAILER WITH NO PERMANEN"
	6           "MOBILE HOME OR TRAILER WITH 1 OR MORE P"
	7           "HU NOT SPECIFIED ABOVE"        
	8           "QTRS NOT HU IN ROOMING OR BOARDING HOUS"
	9           "UNIT NOT PERM IN TRANS. HOTEL, MOTEL, E"
	10          "TENT OR TRAILER SITE"          
	11          "STUDENT QUARTERS IN COLLEGE DORMITORY"
	12          "OTHER NOT HU"                  
;
label values hdareasn P3L;    
label define P3L     
	-1          "NOT IN UNIVERSE"               
	1           "NO ONE HOME"                   
	2           "TEMPORARILY ABSENT"            
	3           "REFUSED"                       
	4           "OTHER - OCC."                  
;
label values hdarace  P4L;    
label define P4L     
	-1          "NOT IN UNIVERSE"               
	1           "WHITE"                         
	2           "BLACK"                         
	3           "OTHER"                         
;
label values hdtypebc P5L;    
label define P5L     
	-1          "NOT IN UNIVERSE"               
	1           "VACANT - REGULAR"              
	2           "VACANT - STORAGE OF HHLD FURNITURE"
	3           "TEMP OCC BY PERSONS WITH URE"  
	4           "UNFIT OR TO BE DEMOLISHED"     
	5           "UNDER CONSTRUCTION, NOT READY" 
	6           "CONVERTED TO TEMP BUSINESS OR STORAGE"
	7           "OCC BY AF MEMBERS OR PERSONS UNDER 15"
	8           "UNOCC TENT OR TRAILER SITE"    
	9           "PERMIT GRANTED, CONSTRUCTION NOT STARTE"
	10          "OTHER"                         
	11          "DEMOLISHED"                    
	12          "HOUSE OR TRAILER MOVED"        
	13          "OUTSIDE SEGMENT"               
	14          "CONVERTED TO PERM BUSINESS OR STORAGE"
	15          "MERGED"                        
	16          "CONDEMNED"                     
	17          "BUILT AFTER APRIL 1, 1980"     
	18          "UNUSED LINE OF LISTING SHEET"  
	19          "OTHER"                         
;
label values hdtenure P6L;    
label define P6L     
	-1          "NOT IN UNIVERSE"               
	1           "OWNED OR BEING BOUGHT"         
	2           "RENT"                          
	3           "NO CASH RENT"                  
;
label values hdfaminc P7L;    
label define P7L     
	-1          "NOT IN UNIVERSE"               
	0           "LESS THAN $5,000"              
	1           "$5,000 TO $7,499"              
	2           "$7,500 TO $9,999"              
	3           "$10,000 TO $12,499"            
	4           "$12,500 TO $14,999"            
	5           "$15,000 TO $19,999"            
	6           "$20,000 TO $24,999"            
	7           "$25,000 TO $29,999"            
	8           "$30,000 TO $34,999"            
	9           "$35,000 TO $39,999"            
	10          "$40,000 TO $49,999"            
	11          "$50,000 TO $59,000"            
	12          "$60,000 TO $74,999"            
	13          "$75,000 AND OVER"              
	19          "NOT ANSWERED"                  
;
label values hdstatus P8L;    
label define P8L     
	1           "YES"                           
	2           "NO"                            
;
label values hddaycmp P9L;    
label define P9L     
	1           "SUNDAY"                        
	2           "MONDAY"                        
	3           "TUESDAY"                       
	4           "WEDNESDAY"                     
	5           "THURSDAY"                      
	6           "FRIDAY"                        
	7           "SATURDAY"                      
	8           "AFTER INTERVIEW WEEK"          
;
label values hdrespnm P10L;   
label define P10L    
	7           "NON HHLD RESP"                 
;
label values hdtypint P11L;   
label define P11L    
	1           "NONINTERVIEW"                  
	2           "PERSONAL"                      
	3           "TEL. - REGULAR"                
	4           "TEL. - CALLBACK"               
	5           "ICR FILLED"                    
;
label values hdseason P12L;   
label define P12L    
	-1          "NOT IN UNIVERSE"               
	1           "YEAR ROUND"                    
	2           "BY MIGRATORY WORKERS"          
	3           "SEASONALLY"                    
;
label values hdoccint P13L;   
label define P13L    
	-1          "NOT IN UNIVERSE"               
	1           "SUMMERS ONLY"                  
	2           "WINTERS ONLY"                  
	3           "OTHER"                         
;
label values hdintrv1 P14L;   
label define P14L    
	0           "A"                             
	1           "B"                             
	2           "C"                             
	3           "D"                             
	4           "E"                             
	5           "F"                             
	6           "G"                             
	7           "H"                             
	8           "J"                             
	9           "K"                             
	10          "L"                             
	11          "M"                             
	12          "N"                             
	13          "P"                             
	14          "Q"                             
	15          "R"                             
	16          "S"                             
	17          "T"                             
	18          "U"                             
	19          "V"                             
	20          "W"                             
	21          "X"                             
	22          "Y"                             
	23          "Z"                             
;
label values hdtelhhd P15L;   
label define P15L    
	-1          "NOT IN UNIVERSE (NON-INTERVIEW)"
	1           "YES"                           
	2           "NO"                            
;
label values hdtelavl P16L;   
label define P16L    
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values hdtelint P17L;   
label define P17L    
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values hdtimint P18L;   
label define P18L    
	1           "MIDNIGHT TO 6 A.M."            
	2           "6 TO 9 A.M."                   
	3           "9 A.M. TO NOON"                
	4           "NOON TO 3 P.M."                
	5           "3 TO 6 P.M."                   
	6           "6 TO 9 P.M."                   
	7           "9 P.M. TO MIDNIGHT"            
;
label values h_cpschk P19L;   
label define P19L    
	1           "ONLY CPS-1 FOR HOUSEHOLD"      
	2           "FIRST CPS-1 OF CONTINUATION HOUSEHOLD"
	3           "SECOND CPS-1 OF CONTINUATION HOUSEHOLD"
	4           "THIRD, FOURTH, ETC. CPS-1"     
;
label values h_daycmp P20L;   
label define P20L    
	1           "SUNDAY"                        
	2           "MONDAY"                        
	3           "TUESDAY"                       
	4           "WEDNESDAY"                     
	5           "THURSDAY"                      
	6           "FRIDAY"                        
	7           "SATURDAY"                      
	8           "AFTER INTERVIEW WEEK"          
;
label values h_livqrt P21L;   
label define P21L    
	1           "HOUSE, APT., FLAT"             
	2           "HU IN NONTRANSIENT HOTEL, ETC."
	3           "HU, PERM, IN TRANS. HOTEL, MOTEL ETC."
	4           "HU IN ROOMING HOUSE"           
	5           "MOBILE HOME OR TRAILER WITH NO PERMANEN"
	6           "MOBILE HOME OR TRAILER WITH 1 OR MORE P"
	7           "HU NOT SPECIFIED ABOVE"        
	8           "QTRS NOT HU IN ROOMING OR BOARDING HOUS"
	9           "UNIT NOT PERM IN TRANS. HOTEL, MOTEL, E"
	10          "TENT OR TRAILER SITE"          
	11          "STUDENT QUARTERS IN COLLEGE DORMITORY"
	12          "OTHER NOT HU"                  
;
label values h_farm   P22L;   
label define P22L    
	1           "NONFARM"                       
	2           "FARM"                          
;
label values h_typint P23L;   
label define P23L    
	1           "NONINTERVIEW"                  
	2           "PERSONAL"                      
	3           "TEL. - REGULAR"                
	4           "TEL. - CALLBACK"               
	5           "ICR FILLED"                    
;
label values h_respnm P24L;   
label define P24L    
	7           "NON HHLD RESP"                 
;
label values h_areasn P25L;   
label define P25L    
	-1          "NOT IN UNIVERSE"               
	1           "NO ONE HOME"                   
	2           "TEMPORARILY ABSENT"            
	3           "REFUSED"                       
	4           "OTHER - OCC."                  
;
label values h_arace  P26L;   
label define P26L    
	-1          "NOT IN UNIVERSE"               
	1           "WHITE"                         
	2           "BLACK"                         
	3           "OTHER"                         
;
label values h_typebc P27L;   
label define P27L    
	-1          "NOT IN UNIVERSE"               
	1           "VACANT - REGULAR"              
	2           "VACANT - STORAGE OF HHLD FURNITURE"
	3           "TEMP OCC BY PERSONS WITH URE"  
	4           "UNFIT OR TO BE DEMOLISHED"     
	5           "UNDER CONSTRUCTION, NOT READY" 
	6           "CONVERTED TO TEMP BUSINESS OR STORAGE"
	7           "OCC BY AF MEMBERS OR PERSONS UNDER 15"
	8           "UNOCC TENT OR TRAILER SITE"    
	9           "PERMIT GRANTED, CONSTRUCTION NOT STARTE"
	10          "OTHER"                         
	11          "DEMOLISHED"                    
	12          "HOUSE OR TRAILER MOVED"        
	13          "OUTSIDE SEGMENT"               
	14          "CONVERTED TO PERM BUSINESS OR STORAGE"
	15          "MERGED"                        
	16          "CONDEMNED"                     
	17          "BUILT AFTER APRIL 1, 1980"     
	18          "UNUSED LINE OF LISTING SHEET"  
	19          "OTHER"                         
;
label values h_season P28L;   
label define P28L    
	-1          "NOT IN UNIVERSE"               
	1           "YEAR ROUND"                    
	2           "BY MIGRATORY WORKERS"          
	3           "SEASONALLY"                    
;
label values h_occint P29L;   
label define P29L    
	-1          "NOT IN UNIVERSE"               
	1           "SUMMERS ONLY"                  
	2           "WINTERS ONLY"                  
	3           "OTHER"                         
;
label values h_intrv1 P30L;   
label define P30L    
	0           "A"                             
	1           "B"                             
	2           "C"                             
	3           "D"                             
	4           "E"                             
	5           "F"                             
	6           "G"                             
	7           "H"                             
	8           "J"                             
	9           "K"                             
	10          "L"                             
	11          "M"                             
	12          "N"                             
	13          "P"                             
	14          "Q"                             
	15          "R"                             
	16          "S"                             
	17          "T"                             
	18          "U"                             
	19          "V"                             
	20          "W"                             
	21          "X"                             
	22          "Y"                             
	23          "Z"                             
;
label values h_status P31L;   
label define P31L    
	1           "YES"                           
	2           "NO"                            
;
label values h_tenure P32L;   
label define P32L    
	-1          "NOT IN UNIVERSE"               
	1           "OWNED OR BEING BOUGHT"         
	2           "RENT"                          
	3           "NO CASH RENT"                  
;
label values h_faminc P33L;   
label define P33L    
	-1          "NOT IN UNIVERSE"               
	0           "LESS THAN $5,000"              
	1           "$5,000 TO $7,499"              
	2           "$7,500 TO $9,999"              
	3           "$10,000 TO $12,499"            
	4           "$12,500 TO $14,999"            
	5           "$15,000 TO $19,999"            
	6           "$20,000 TO $24,999"            
	7           "$25,000 TO $29,999"            
	8           "$30,000 TO $34,999"            
	9           "$35,000 TO $39,999"            
	10          "$40,000 TO $49,999"            
	11          "$50,000 TO $59,000"            
	12          "$60,000 TO $74,999"            
	13          "$75,000 AND OVER"              
	19          "NOT ANSWERED"                  
;
label values h_telhhd P34L;   
label define P34L    
	-1          "NOT IN UNIVERSE (NON-INTERVIEW)"
	1           "YES"                           
	2           "NO"                            
;
label values h_telavl P35L;   
label define P35L    
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values h_telint P36L;   
label define P36L    
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values h_timint P37L;   
label define P37L    
	1           "MIDNIGHT TO 6 A.M."            
	2           "6 TO 9 A.M."                   
	3           "9 A.M. TO NOON"                
	4           "NOON TO 3 P.M."                
	5           "3 TO 6 P.M."                   
	6           "6 TO 9 P.M."                   
	7           "9 P.M. TO MIDNIGHT"            
;
label values h_hhtype P38L;   
label define P38L    
	1           "INTERVIEW"                     
	2           "TYPE A NON-INTERVIEW"          
	3           "TYPE B/C NON-INTERVIEW"        
;
label values h_numper P39L;   
label define P39L    
	0           "NONINTERVIEW HOUSEHOLD"        
;
label values h_type   P40L;   
label define P40L    
	0           "NON-INTERVIEW HOUSEHOLD"       
	1           "HUSBAND/WIFE PRIMARY FAMILY (NEITHER"
	2           "HUSBAND/WIFE PRIMARY FAMILY (HUSBAND AN"
	3           "UNMARRIED CIVILIAN MALE PRIMARY FAMILY"
	4           "UNMARRIED CIVILIAN FEMALE PRIMARY FAMIL"
	5           "PRIMARY FAMILY HOUSEHOLD - REFERENCE PE"
	6           "CIVILIAN MALE PRIMARY INDIVIDUAL"
	7           "CIVILIAN FEMALE PRIMARY INDIVIDUAL"
	8           "PRIMARY INDIVIDUAL HOUSEHOLD - REFERENC"
	9           "GROUP"                         
;
label values h_typerp P41L;   
label define P41L    
	0           "NOT IN UNIVERSE"               
	1           "CIVILIAN"                      
	2           "ARMED FORCES"                  
	3           "GROUP QUARTERS"                
;
label values h_numfam P42L;   
label define P42L    
	0           "NOT IN UNIVERSE"               
;
label values h_hhdseq P43L;   
label define P43L    
	0           "NOT IN UNIVERSE"               
;
label values hptenure P44L;   
label define P44L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	4           "ALLOCATED"                     
;
label values hpfaminc P45L;   
label define P45L    
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	6           "REFUSAL TO VALUE, ALLOCATED, NO ERROR"
;
label values hparace  P46L;   
label define P46L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	4           "ALLOCATED"                     
;
label values hpcpschk P47L;   
label define P47L    
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
;
label values hpdaycmp P48L;   
label define P48L    
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
;
label values hphhnum  P49L;   
label define P49L    
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	8           "BLANK TO NA - ERROR"           
;
label values hpintrv  P50L;   
label define P50L    
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
;
label values hplivqrt P51L;   
label define P51L    
	0           "NO CHANGE"                     
	4           "ALLOCATED"                     
	7           "BLANK TO NA - NO ERROR"        
;
label values hpoccint P52L;   
label define P52L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	4           "ALLOCATED"                     
;
label values hprespnm P53L;   
label define P53L    
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
;
label values hpseason P54L;   
label define P54L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	4           "ALLOCATED"                     
;
label values hpstatus P55L;   
label define P55L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	8           "BLANK TO NA - ERROR"           
;
label values hpareasn P56L;   
label define P56L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
;
label values hptypebc P57L;   
label define P57L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
;
label values hptelhhd P58L;   
label define P58L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	4           "ALLOCATED"                     
;
label values hptelavl P59L;   
label define P59L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	4           "ALLOCATED"                     
;
label values hptelint P60L;   
label define P60L    
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	4           "ALLOCATED"                     
;
label values hpprscnt P61L;   
label define P61L    
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
;
label values hptimint P62L;   
label define P62L    
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
;
label values hptelcnt P63L;   
label define P63L    
	0           "NO CHANGE"                     
	7           "BLANK TO NA - NO ERROR"        
;
label values hg_reg   P64L;   
label define P64L    
	1           "NORTHEAST"                     
	2           "MIDWEST"                       
	3           "SOUTH"                         
	4           "WEST"                          
;
label values hg_st60  P65L;   
label define P65L    
	11          "MAINE"                         
	12          "NEW HAMPSHIRE"                 
	13          "VERMONT"                       
	14          "MASSACHUSETTS"                 
	15          "RHODE ISLAND"                  
	16          "CONNECTICUT"                   
	21          "NEW YORK"                      
	22          "NEW JERSEY"                    
	23          "PENNSYLVANIA"                  
	31          "OHIO"                          
	32          "INDIANA"                       
	33          "ILLINOIS"                      
	34          "MICHIGAN"                      
	35          "WISCONSIN"                     
	41          "MINNESOTA"                     
	42          "IOWA"                          
	43          "MISSOURI"                      
	44          "NORTH DAKOTA"                  
	45          "SOUTH DAKOTA"                  
	46          "NEBRASKA"                      
	47          "KANSAS"                        
	51          "DELAWARE"                      
	52          "MARYLAND"                      
	53          "DISTRICT OF COLUMBIA"          
	54          "VIRGINIA"                      
	55          "WEST VIRGINIA"                 
	56          "NORTH CAROLINA"                
	57          "SOUTH CAROLINA"                
	58          "GEORGIA"                       
	59          "FLORIDA"                       
	61          "KENTUCKY"                      
	62          "TENNESSEE"                     
	63          "ALABAMA"                       
	64          "MISSISSIPPI"                   
	71          "ARKANSAS"                      
	72          "LOUISIANA"                     
	73          "OKLAHOMA"                      
	74          "TEXAS"                         
	81          "MONTANA"                       
	82          "IDAHO"                         
	83          "WYOMING"                       
	84          "COLORADO"                      
	85          "NEW MEXICO"                    
	86          "ARIZONA"                       
	87          "UTAH"                          
	88          "NEVADA"                        
	91          "WASHINGTON"                    
	92          "OREGON"                        
	93          "CALIFORNIA"                    
	94          "ALASKA"                        
	95          "HAWAII"                        
;
label values hg_msas  P66L;   
label define P66L    
	1           "IN MSA, IN CC"                 
	2           "IN MSA, NOT IN CC"             
	3           "NOT IN MSA"                    
	4           "NOT IDENTIFIED"                
;
label values hg_msac  P67L;   
label define P67L    
	0           "NOT MSA/PMSA, NOT IDENTIFIED"  
;
label values hg_pmsa  P68L;   
label define P68L    
	0           "NOT A PMSA, NOT IDENTIFIED"    
;
label values hg_msar  P69L;   
label define P69L    
	0           "NOT AN MSA, NOT IDENTIFIED"    
;
label values hg_mssz  P70L;   
label define P70L    
	1           "NOT IDENTIFIED, NOT AN MSA"    
	2           "100,000 - 249,999"             
	3           "250,000 - 499,999"             
	4           "500,000 - 999,999"             
	5           "1 MILLION - 2,499,999"         
	6           "2.5 MILLION - 4,999,999"       
	7           "5 MILLION - 9,999,999"         
	8           "10 MILLION OR MORE"            
;
label values hg_cmsa  P71L;   
label define P71L    
	0           "NOT IN CMSA, NOT IDENTIFIED"   
;
label values l_typint P72L;   
label define P72L    
	1           "NONINTERVIEW"                  
	2           "PERSONAL"                      
	3           "TEL. - REGULAR"                
	4           "TEL. - CALLBACK"               
	5           "ICR FILLED"                    
;
label values l_respnm P73L;   
label define P73L    
	7           "NON HHLD RESP"                 
;
label values l_intrv1 P74L;   
label define P74L    
	0           "A"                             
	1           "B"                             
	2           "C"                             
	3           "D"                             
	4           "E"                             
	5           "F"                             
	6           "G"                             
	7           "H"                             
	8           "J"                             
	9           "K"                             
	10          "L"                             
	11          "M"                             
	12          "N"                             
	13          "P"                             
	14          "Q"                             
	15          "R"                             
	16          "S"                             
	17          "T"                             
	18          "U"                             
	19          "V"                             
	20          "W"                             
	21          "X"                             
	22          "Y"                             
	23          "Z"                             
;
label values lprespnm P75L;   
label define P75L    
	0           "NO CHANGE"                     
	8           "BLANK TO NA - ERROR"           
;
label values lpintrv  P76L;   
label define P76L    
	0           "NO CHANGE"                     
	8           "BLANK TO NA - ERROR"           
;
label values h_metsta P77L;   
label define P77L    
	1           "METROPOLITAN"                  
	2           "NONMETROPOLITAN"               
	3           "NOT IDENTIFIED"                
;
label values h_rectyp P78L;   
label define P78L    
	1           "INTERVIEWED ADULT"             
	2           "TYPE A NONINTERVIEW"           
	3           "TYPE B/C NONINTERVIEW"         
	4           "ARMED FORCES RECORD"           
	5           "CHILDRENS RECORD"              
;
label values adrrp    P79L;   
label define P79L    
	1           "REF PER WITH OTHER RELATIVES IN HHLD"
	2           "REF PER WITH NO OTHER RELATIVES IN HHLD"
	3           "HUSBAND"                       
	4           "WIFE"                          
	5           "NATUAL/ADOPTED CHILD"          
	6           "STEP CHILD"                    
	7           "GRANDCHILD"                    
	8           "PARENT"                        
	9           "BROTHER/SISTER"                
	10          "OTHER RELATIVE OF REF PER"     
	11          "FOSTER CHILD"                  
	12          "NON-REL OF REF PER WITH OWN RELS IN HHL"
	13          "PARTNER/ROOMATE"               
	14          "NON-REL OF REF PER-NO OWN RELS IN HHLD"
;
label values adprntno P80L;   
label define P80L    
	1           "NONE"                          
;
label values admarit  P81L;   
label define P81L    
	1           "MARRIED - SPOUSE PRESENT"      
	2           "MARRIED - SPOUSE ABSENT (EXC SEPARATED)"
	3           "WIDOWED"                       
	4           "DIVORCED"                      
	5           "SEPARATED"                     
	6           "NEVER MARRIED"                 
;
label values adspsnon P82L;   
label define P82L    
	1           "NONE"                          
;
label values adsex    P83L;   
label define P83L    
	1           "MALE"                          
	2           "FEMALE"                        
;
label values advet    P84L;   
label define P84L    
	1           "VIETNAM ERA"                   
	2           "KOREAN WAR"                    
	3           "WORLD WAR II"                  
	4           "WORLD WAR I"                   
	5           "OTHER SERVICE"                 
	6           "NONVETERAN"                    
;
label values adhgc    P85L;   
label define P85L    
	1           "YES"                           
	2           "NO"                            
;
label values adrace   P86L;   
label define P86L    
	1           "WHITE"                         
	2           "BLACK"                         
	3           "AMER INDIAN, ALEUT, ESKIMO"    
	4           "ASIAN OR PACIFIC ISL"          
	5           "OTHER"                         
;
label values admajact P87L;   
label define P87L    
	1           "WORKING"                       
	2           "WITH JOB BUT NOT AT WORK"      
	3           "LOOKING FOR WORK"              
	4           "KEEPING HOUSE"                 
	5           "GOING TO SCHOOL"               
	6           "UNABLE TO WORK"                
	7           "RETIRED"                       
	8           "OTHER"                         
;
label values adanywk  P88L;   
label define P88L    
	1           "YES"                           
	2           "NO"                            
;
label values adhrschk P89L;   
label define P89L    
	1           "49+"                           
	2           "1-34"                          
	3           "35-48"                         
;
label values aduslft  P90L;   
label define P90L    
	1           "YES"                           
	2           "NO"                            
;
label values adftreas P91L;   
label define P91L    
	1           "SLACK WORK"                    
	2           "MATERIAL SHORTAGE"             
	3           "PLANT OR MACHINE REPAIR"       
	4           "NEW JOB STARTED DURING WEEK"   
	5           "JOB TERMINATED DURING WEEK"    
	6           "COULD FIND ONLY PART TIME WORK"
	7           "HOLIDAY"                       
	8           "LABOR DISPUTE"                 
	9           "BAD WEATHER"                   
	10          "OWN ILLNESS"                   
	11          "ON VACATION"                   
	12          "TOO BUSY WITH HOUSE, SCHOOL, ETC."
	13          "DID NOT WANT FULL TIME WORK"   
	14          "FULL-TIME WORK WEEKS < 35 HRS" 
	15          "OTHER"                         
;
label values adlostim P92L;   
label define P92L    
	1           "YES"                           
	2           "NO"                            
;
label values adovrtim P93L;   
label define P93L    
	1           "YES"                           
	2           "NO"                            
;
label values adjobabs P94L;   
label define P94L    
	1           "YES"                           
	2           "NO"                            
;
label values adwhyabs P95L;   
label define P95L    
	1           "OWN ILLNESS"                   
	2           "ON VACATION"                   
	3           "BAD WEATHER"                   
	4           "LABOR DISPUTE"                 
	5           "NEW JOB TO BEGIN WITHIN 30 DAYS"
	6           "TEMPORARY LAYOFF (UNDER 30 DAYS)"
	7           "INDEFINITE LAYOFF (30 DAYS OR MORE)"
	8           "OTHER"                         
;
label values adpayabs P96L;   
label define P96L    
	1           "YES"                           
	2           "NO"                            
	3           "SELF-EMPLOYED"                 
;
label values adftabs  P97L;   
label define P97L    
	1           "YES"                           
	2           "NO"                            
;
label values adlkwk   P98L;   
label define P98L    
	1           "YES"                           
	2           "NO"                            
;
label values admthd1  P99L;   
label define P99L    
	1           "ENTRY"                         
;
label values admthd2  P100L;  
label define P100L   
	1           "ENTRY"                         
;
label values admthd3  P101L;  
label define P101L   
	1           "ENTRY"                         
;
label values admthd4  P102L;  
label define P102L   
	1           "ENTRY"                         
;
label values admthd5  P103L;  
label define P103L   
	1           "ENTRY"                         
;
label values admthd6  P104L;  
label define P104L   
	1           "ENTRY"                         
;
label values admthd7  P105L;  
label define P105L   
	1           "ENTRY"                         
;
label values adwhylk  P106L;  
label define P106L   
	1           "LOST JOB"                      
	2           "QUIT JOB"                      
	3           "LEFT SCHOOL"                   
	4           "WANTED TEMPORARY WORK"         
	5           "CHANGE IN HOME OR FAMILY RESPONSIBILITI"
	6           "LEFT MILITARY SERVICE"         
	7           "OTHER"                         
;
label values adlkftpt P107L;  
label define P107L   
	1           "FULL-TIME"                     
	2           "PART-TIME"                     
;
label values adavail  P108L;  
label define P108L   
	1           "YES"                           
	2           "NO"                            
;
label values adwhyna  P109L;  
label define P109L   
	1           "ALREADY HAS A JOB"             
	2           "TEMPORARY ILLNESS"             
	3           "GOING TO SCHOOL"               
	4           "OTHER"                         
;
label values adwhenlj P110L;  
label define P110L   
	1           "IN LAST 12 MONTHS"             
	2           "1-5 YEARS AGO"                 
	3           "MORE THAN 5 YEARS AGO"         
	4           "NEVER WORKED FULL TIME 2 WEEKS OR MORE"
	5           "NEVER WORKED AT ALL"           
;
label values adindref P111L;  
label define P111L   
	0           "REFERRAL"                      
	1           "UNCODABLE"                     
;
label values adoccref P112L;  
label define P112L   
	0           "REFERRAL"                      
	1           "UNCODABLE"                     
;
label values adclswkr P113L;  
label define P113L   
	1           "PRIVATE"                       
	2           "FEDERAL GOVERNMENT"            
	3           "STATE GOVERNMENT"              
	4           "LOCAL GOVERNMENT"              
	5           "SELF-EMPLOYED-INCORPORATED"    
	6           "SELF-EMPLOYED-NOT INCORPORATED"
	7           "WITHOUT PAY"                   
	8           "NEVER WORKED"                  
;
label values adchkwj  P114L;  
label define P114L   
	1           "ENTRY (OR NA) IN I20A &  P,F,S OR L IN I"
	2           "ENTRY (OR NA) IN I23B &  P,F,S OR L IN I"
	3           "ALL OTHER CASES"               
;
label values adnlfrot P115L;  
label define P115L   
	1           "CONTINUING ROTATIONS"          
	2           "OUTGOING ROTATIONS"            
;
label values adnlflj  P116L;  
label define P116L   
	1           "WITHIN PAST 12 MONTHS"         
	2           "1 UP TO 2 YEARS AGO"           
	3           "2 UP TO 3 YEARS AGO"           
	4           "3 UP TO 4 YEARS AGO"           
	5           "4 UP TO 5 YEARS AGO"           
	6           "5 OR MORE YEARS AGO"           
	7           "NEVER WORKED"                  
;
label values adwhylft P117L;  
label define P117L   
	1           "PERSONAL, FAMILY OR SCHOOL"    
	2           "HEALTH"                        
	3           "RETIREMENT OR OLD AGE"         
	4           "SEASONAL JOB COMPLETED"        
	5           "SLACK WORK OR BUSINESS CONDITIONS"
	6           "TEMPORARY NONSEASONAL JOB COMPLETED"
	7           "UNSATISFACTORY WORK ARRANGEMENTS"
	8           "OTHER"                         
;
label values adwantjb P118L;  
label define P118L   
	1           "YES"                           
	2           "MAYBE-IT DEPENDS"              
	3           "NO"                            
	4           "DON'T KNOW"                    
;
label values adwhynl1 P119L;  
label define P119L   
	1           "ENTRY"                         
;
label values adwhynl2 P120L;  
label define P120L   
	1           "ENTRY"                         
;
label values adwhynl3 P121L;  
label define P121L   
	1           "ENTRY"                         
;
label values adwhynl4 P122L;  
label define P122L   
	1           "ENTRY"                         
;
label values adwhynl5 P123L;  
label define P123L   
	1           "ENTRY"                         
;
label values adwhynl6 P124L;  
label define P124L   
	1           "ENTRY"                         
;
label values adwhynl7 P125L;  
label define P125L   
	1           "ENTRY"                         
;
label values adwhynl8 P126L;  
label define P126L   
	1           "ENTRY"                         
;
label values adwhynl9 P127L;  
label define P127L   
	1           "ENTRY"                         
;
label values adwhynla P128L;  
label define P128L   
	1           "ENTRY"                         
;
label values adwhynlb P129L;  
label define P129L   
	1           "ENTRY"                         
;
label values adintend P130L;  
label define P130L   
	1           "YES"                           
	2           "IT DEPENDS"                    
	3           "NO"                            
	4           "DON'T KNOW"                    
;
label values adearnrt P131L;  
label define P131L   
	1           "MIS 1,2,3,5,6,7"               
	2           "MIS 4, 8"                      
;
label values adhrlywk P132L;  
label define P132L   
	1           "YES"                           
	2           "NO"                            
;
label values adhrpref P133L;  
label define P133L   
	1           "REFUSAL"                       
;
label values adgrsref P134L;  
label define P134L   
	1           "REFUSAL"                       
;
label values adunmem  P135L;  
label define P135L   
	1           "YES"                           
	2           "NO"                            
;
label values aduncov  P136L;  
label define P136L   
	1           "YES"                           
	2           "NO"                            
;
label values adenrchk P137L;  
label define P137L   
	1           "THIS PERSON IS 16-24 YEARS OF AGE"
	2           "ALL OTHERS"                    
;
label values adenrlw  P138L;  
label define P138L   
	1           "YES"                           
	2           "NO"                            
;
label values adhscol  P139L;  
label define P139L   
	1           "HIGH SCHOOL"                   
	2           "COLLEGE OR UNIV."              
;
label values adftpt   P140L;  
label define P140L   
	1           "FULL TIME"                     
	2           "PART TIME"                     
;
label values adslfprx P141L;  
label define P141L   
	1           "SELF"                          
	2           "OTHER"                         
	3           "SELF/OTHER"                    
;
label values a_rrp    P142L;  
label define P142L   
	1           "REF PER WITH OTHER RELATIVES IN HHLD"
	2           "REF PER WITH NO OTHER RELATIVES IN HHLD"
	3           "HUSBAND"                       
	4           "WIFE"                          
	5           "OWN CHILD"                     
	6           "PARENT"                        
	7           "BROTHER/SISTER"                
	8           "OTHER RELATIVE OF REF PER"     
	9           "NON-REL OF REF PER WITH OWN RELS IN HHL"
	10          "NON-REL OF REF PER-NO OWN RELS IN HHLD"
;
label values a_parent P143L;  
label define P143L   
	0           "NONE"                          
;
label values a_maritl P144L;  
label define P144L   
	1           "MARRIED - CIVILIAN SPOUSE PRESENT"
	2           "MARRIED - AF SPOUSE PRESENT"   
	3           "MARRIED - SPOUSE ABSENT (EXC SEPARATED)"
	4           "WIDOWED"                       
	5           "DIVORCED"                      
	6           "SEPARATED"                     
	7           "NEVER MARRIED"                 
;
label values a_spouse P145L;  
label define P145L   
	0           "NONE"                          
;
label values a_sex    P146L;  
label define P146L   
	1           "MALE"                          
	2           "FEMALE"                        
;
label values a_vet    P147L;  
label define P147L   
	1           "VIETNAM ERA"                   
	2           "KOREAN WAR"                    
	3           "WORLD WAR II"                  
	4           "WORLD WAR I"                   
	5           "OTHER SERVICE"                 
	6           "NONVETERAN"                    
;
label values a_hga    P148L;  
label define P148L   
	31          "LESS THAN 1ST GRADE"           
	32          "1ST, 2ND, 3RD, OR 4TH GRADE"   
	33          "5TH OR 6TH GRADE"              
	34          "7TH OR 8TH GRADE"              
	35          "9TH GRADE"                     
	36          "10TH GRADE"                    
	37          "11TH GRADE"                    
	38          "12TH GRADE NO DIPLOMA"         
	39          "HIGH SCHOOL GRADUATE  (HS DIPLOMA OR EQ"
	40          "SOME COLLEGE BUT NO DEGREE"    
	41          "ASSOCIATE DEGREE IN COLLEGE, OCCUPATION"
	42          "ASSOCIATE DEGREE IN COLLEGE, ACADEMIC P"
	43          "BACHELOR'S DEGREE (I.E., BA, AB, BS)"
	44          "MASTER'S DEGREE (I.E., MA, MS, MENG, MB"
	45          "PROFESSIONAL SCHOOL DEGREE (I.E., MD, D"
	46          "DOCTORATE DEGREE (I.E., PHD, EDD)"
;
label values a_race   P149L;  
label define P149L   
	1           "WHITE"                         
	2           "BLACK"                         
	3           "AMER INDIAN, ALEUT ESKIMO"     
	4           "ASIAN OR PACIFIC ISL"          
	5           "OTHER"                         
;
label values a_majact P150L;  
label define P150L   
	1           "WORKING"                       
	2           "WITH JOB BUT NOT AT WORK"      
	3           "LOOKING FOR WORK"              
	4           "KEEPING HOUSE"                 
	5           "GOING TO SCHOOL"               
	6           "UNABLE TO WORK"                
	7           "RETIRED"                       
	8           "OTHER"                         
;
label values a_anywk  P151L;  
label define P151L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_hrs1   P152L;  
label define P152L   
	-1          "NOT IN UNIVERSE"               
;
label values a_hrschk P153L;  
label define P153L   
	-1          "NOT IN UNIVERSE"               
	1           "49+"                           
	2           "1-34"                          
	3           "35-48"                         
;
label values a_uslft  P154L;  
label define P154L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_ftreas P155L;  
label define P155L   
	-1          "NOT IN UNIVERSE"               
	1           "SLACK WORK"                    
	2           "MATERIAL SHORTAGE"             
	3           "PLANT OR MACHINE REPAIR"       
	4           "NEW JOB STARTED DURING WEEK"   
	5           "JOB TERMINATED DURING WEEK"    
	6           "COULD FIND ONLY PART TIME WORK"
	7           "HOLIDAY"                       
	8           "LABOR DISPUTE"                 
	9           "BAD WEATHER"                   
	10          "OWN ILLNESS"                   
	11          "ON VACATION"                   
	12          "TOO BUSY WITH HOUSE, SCHOOL, ETC."
	13          "DID NOT WANT FULL TIME WORK"   
	14          "FULL-TIME WORK WEEKS < 35 HRS" 
	15          "OTHER"                         
;
label values a_lostim P156L;  
label define P156L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_ovrtim P157L;  
label define P157L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_jobabs P158L;  
label define P158L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_whyabs P159L;  
label define P159L   
	-1          "NOT IN UNIVERSE"               
	1           "OWN ILLNESS"                   
	2           "ON VACATION"                   
	3           "BAD WEATHER"                   
	4           "LABOR DISPUTE"                 
	5           "NEW JOB TO BEGIN WITHIN 30 DAYS"
	6           "TEMPORARY LAYOFF (UNDER 30 DAYS)"
	7           "INDEFINITE LAYOFF (30 DAYS OR MORE)"
	8           "OTHER"                         
;
label values a_payabs P160L;  
label define P160L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
	3           "SELF-EMPLOYED"                 
;
label values a_ftabs  P161L;  
label define P161L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_lkwk   P162L;  
label define P162L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_mthd1  P163L;  
label define P163L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_mthd2  P164L;  
label define P164L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_mthd3  P165L;  
label define P165L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_mthd4  P166L;  
label define P166L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_mthd5  P167L;  
label define P167L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_mthd6  P168L;  
label define P168L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_mthd7  P169L;  
label define P169L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whylk  P170L;  
label define P170L   
	-1          "NOT IN UNIVERSE"               
	1           "LOST JOB"                      
	2           "QUIT JOB"                      
	3           "LEFT SCHOOL"                   
	4           "WANTED TEMPORARY WORK"         
	5           "CHANGE IN HOME OR FAMILY RESPONSIBILITI"
	6           "LEFT MILITARY SERVICE"         
	7           "OTHER"                         
;
label values a_wkslk  P171L;  
label define P171L   
	-1          "NOT IN UNIVERSE"               
;
label values a_lkftpt P172L;  
label define P172L   
	-1          "NOT IN UNIVERSE"               
	1           "FULL-TIME"                     
	2           "PART-TIME"                     
;
label values a_avail  P173L;  
label define P173L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_whyna  P174L;  
label define P174L   
	-1          "NOT IN UNIVERSE"               
	1           "ALREADY HAS A JOB"             
	2           "TEMPORARY ILLNESS"             
	3           "GOING TO SCHOOL"               
	4           "OTHER"                         
;
label values a_whenlj P175L;  
label define P175L   
	-1          "NOT IN UNIVERSE"               
	1           "IN LAST 12 MONTHS"             
	2           "1-5 YEARS AGO"                 
	3           "MORE THAN 5 YEARS AGO"         
	4           "NEVER WORKED FULL TIME 2 WEEKS OR MORE"
	5           "NEVER WORKED AT ALL"           
;
label values a_ind    P176L;  
label define P176L   
	-1          "NOT IN UNIVERSE"               
	0           "OLD NOT IN UNIVERSE"           
;
label values a_occ    P177L;  
label define P177L   
	-1          "NOT IN UNIVERSE"               
	0           "OLD NOT IN UNIVERSE"           
;
label values a_clswkr P178L;  
label define P178L   
	-1          "NOT IN UNIVERSE"               
	1           "PRIVATE"                       
	2           "FEDERAL GOVERNMENT"            
	3           "STATE GOVERNMENT"              
	4           "LOCAL GOVERNMENT"              
	5           "SELF-EMPLOYED-INCORPORATED"    
	6           "SELF-EMPLOYED-NOT INCORPORATED"
	7           "WITHOUT PAY"                   
	8           "NEVER WORKED"                  
;
label values a_chkwj  P179L;  
label define P179L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY (OR NA) IN I20A &  P,F,S OR L IN I"
	2           "ENTRY (OR NA) IN I23B &  P,F,S OR L IN I"
	3           "ALL OTHER CASES"               
;
label values a_nlfrot P180L;  
label define P180L   
	-1          "NOT IN UNIVERSE"               
	1           "CONTINUING ROTATIONS"          
	2           "OUTGOING ROTATIONS"            
;
label values a_nlflj  P181L;  
label define P181L   
	-1          "NOT IN UNIVERSE"               
	1           "WITHIN PAST 12 MONTHS"         
	2           "1 UP TO 2 YEARS AGO"           
	3           "2 UP TO 3 YEARS AGO"           
	4           "3 UP TO 4 YEARS AGO"           
	5           "4 UP TO 5 YEARS AGO"           
	6           "5 OR MORE YEARS AGO"           
	7           "NEVER WORKED"                  
;
label values a_whylft P182L;  
label define P182L   
	-1          "NOT IN UNIVERSE"               
	1           "PERSONAL, FAMILY OR SCHOOL"    
	2           "HEALTH"                        
	3           "RETIREMENT OR OLD AGE"         
	4           "SEASONAL JOB COMPLETED"        
	5           "SLACK WORK OR BUSINESS CONDITIONS"
	6           "TEMPORARY NONSEASONAL JOB COMPLETED"
	7           "UNSATISFACTORY WORK ARRANGEMENTS"
	8           "OTHER"                         
;
label values a_wantjb P183L;  
label define P183L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "MAYBE-IT DEPENDS"              
	3           "NO"                            
	4           "DON'T KNOW"                    
;
label values a_whynl1 P184L;  
label define P184L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynl2 P185L;  
label define P185L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynl3 P186L;  
label define P186L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynl4 P187L;  
label define P187L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynl5 P188L;  
label define P188L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynl6 P189L;  
label define P189L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynl7 P190L;  
label define P190L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynl8 P191L;  
label define P191L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynl9 P192L;  
label define P192L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynla P193L;  
label define P193L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_whynlb P194L;  
label define P194L   
	-1          "NOT IN UNIVERSE"               
	1           "ENTRY"                         
;
label values a_intend P195L;  
label define P195L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "IT DEPENDS"                    
	3           "NO"                            
	4           "DON'T KNOW"                    
;
label values a_earnrt P196L;  
label define P196L   
	-1          "NOT IN UNIVERSE"               
	1           "MIS 1,2,3,5,6,7"               
	2           "MIS 4, 8"                      
;
label values a_uslhrs P197L;  
label define P197L   
	-1          "NOT IN UNIVERSE"               
;
label values a_hrlywk P198L;  
label define P198L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_unmem  P199L;  
label define P199L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_uncov  P200L;  
label define P200L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_enrchk P201L;  
label define P201L   
	1           "THIS PERSON IS 16-24 YEARS OF AGE"
	2           "ALL OTHERS"                    
;
label values a_enrlw  P202L;  
label define P202L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values a_hscol  P203L;  
label define P203L   
	-1          "NOT IN UNIVERSE"               
	1           "HIGH SCHOOL"                   
	2           "COLLEGE OR UNIV."              
;
label values a_ftpt   P204L;  
label define P204L   
	-1          "NOT IN UNIVERSE"               
	1           "FULL TIME"                     
	2           "PART TIME"                     
;
label values a_reorgn P205L;  
label define P205L   
	1           "MEXICAN AMERICAN"              
	2           "CHICANO"                       
	3           "MEXICAN (MEXICANO)"            
	4           "PUERTO RICAN"                  
	5           "CUBAN"                         
	6           "CENTRAL OR SOUTH AMERICAN"     
	7           "OTHER SPANISH"                 
	8           "ALL OTHER"                     
	9           "DON'T KNOW"                    
	10          "NA"                            
;
label values a_exprrp P206L;  
label define P206L   
	1           "REFERENCE PERSON WITH RELATIVES"
	2           "REFERENCE PERSON WITHOUT RELATIVES"
	3           "HUSBAND"                       
	4           "WIFE"                          
	5           "NATURAL/ADOPTED CHILD"         
	6           "STEP CHILD"                    
	7           "GRANDCHILD"                    
	8           "PARENT"                        
	9           "BROTHER/SISTER"                
	10          "OTHER RELATIVE"                
	11          "FOSTER CHILD"                  
	12          "NONRELATIVE WITH RELATIVES"    
	13          "PARTNER/ROOMMATE"              
	14          "NONRELATIVE WITHOUT RELATIVES" 
;
label values a_lfsr   P207L;  
label define P207L   
	1           "WORKING"                       
	2           "WITH JOB,NOT AT WORK"          
	3           "UNEMPLOYED, LOOKING FOR WORK"  
	4           "UNEMPLOYED, ON LAYOFF"         
	5           "NILF - WORKING W/O PAY < 15 HRS;"
	6           "NILF - UNAVAILABLE"            
	7           "OTHER NILF"                    
;
label values a_untype P208L;  
label define P208L   
	-1          "NOT IN UNIVERSE"               
	1           "JOB LOSER - ON LAYOFF"         
	2           "OTHER JOB LOSER"               
	3           "JOB LEAVER"                    
	4           "RE-ENTRANT"                    
	5           "NEW ENTRANT"                   
;
label values a_nlfrea P209L;  
label define P209L   
	-1          "NOT IN UNIVERSE"               
	1           "SCHOOL"                        
	2           "ILL, DISABLED"                 
	3           "KEEPING HOUSE"                 
	4           "RETIRED OR OLD AGE"            
	5           "NO DESIRE"                     
	6           "EMPLOYERS THINK TOO YOUNG OR OLD"
	7           "LACKS EDUCATION OR TRAINING"   
	8           "OTHER PERSONAL REASON"         
	9           "COULD NOT FIND WORK"           
	10          "THINKS NO JOB AVAILABLE"       
	11          "OTHER"                         
;
label values a_wkstat P210L;  
label define P210L   
	1           "NOT IN LABOR FORCE"            
	2           "FULL-TIME SCHEDULES"           
	3           "PART-TIME FOR ECONOMIC REASONS, USUALLY"
	4           "PART-TIME FOR NON-ECONOMIC REASONS, USU"
	5           "PART-TIME FOR ECONOMIC REASONS, USUALLY"
	6           "UNEMPLOYED F/T"                
	7           "UNEMPLOYED P/T"                
;
label values a_explf  P211L;  
label define P211L   
	-1          "NOT IN EXPERIENCED LABOR FORCE"
	1           "EMPLOYED"                      
	2           "UNEMPLOYED"                    
;
label values a_wksch  P212L;  
label define P212L   
	-1          "NOT IN UNIVERSE"               
	1           "AT WORK"                       
	2           "WITH JOB, NOT AT WORK"         
	3           "UNEMPLOYED, SEEKS F/T"         
	4           "UNEMPLOYED, SEEKS P/T"         
;
label values a_civlf  P213L;  
label define P213L   
	-1          "NOT IN UNIVERSE"               
	1           "IN UNIVERSE"                   
;
label values a_ftlf   P214L;  
label define P214L   
	-1          "NOT IN UNIVERSE"               
	1           "IN UNIVERSE"                   
;
label values a_emphrs P215L;  
label define P215L   
	-1          "NOT IN UNIVERSE"               
	1           "ILLNESS"                       
	2           "VACATION"                      
	3           "BAD WEATHER"                   
	4           "LABOR DISPUTE"                 
	5           "ALL OTHER"                     
	6           "1-4 HOURS"                     
	7           "5-14 HOURS"                    
	8           "15-21 HOURS"                   
	9           "22-29 HOURS"                   
	10          "30-34 HOURS"                   
	11          "35-39 HOURS"                   
	12          "40 HOURS"                      
	13          "41-47 HOURS"                   
	14          "48 HOURS"                      
	15          "49-59 HOURS"                   
	16          "60 HOURS OR MORE"              
;
label values a_pthrs  P216L;  
label define P216L   
	-1          "NOT IN UNIVERSE"               
	0           "USUALLY F/T, P/T FOR NONECONOMIC REASON"
	1           "1-4 HOURS"                     
	2           "5-14 HOURS"                    
	3           "15-29 HOURS"                   
	4           "30-34 HOURS"                   
	5           "1-4 HOURS"                     
	6           "5-14 HOURS"                    
	7           "15-29 HOURS"                   
	8           "30-34 HOURS"                   
	9           "1-4 HOURS"                     
	10          "5-14 HOURS"                    
	11          "15-29 HOURS"                   
	12          "30-34 HOURS"                   
;
label values a_ptrea  P217L;  
label define P217L   
	-1          "NOT IN UNIVERSE"               
	1           "SLACK WORK"                    
	2           "MATERIAL SHORTAGES, PLANT REPAIR"
	3           "NEW JOB STARTED"               
	4           "JOB TERMINATED"                
	5           "HOLIDAY"                       
	6           "LABOR DISPUTE"                 
	7           "BAD WEATHER"                   
	8           "OWN ILLNESS"                   
	9           "ON VACATION"                   
	10          "ALL OTHER"                     
	11          "SLACK WORK"                    
	12          "COULD FIND ONLY P/T"           
	13          "OWN ILLNESS"                   
	14          "TOO BUSY OR DID NOT WANT F/T"  
	15          "F/T UNDER 35 HOURS"            
	16          "OTHER"                         
;
label values a_absrea P218L;  
label define P218L   
	-1          "NOT IN UNIVERSE"               
	1           "VACATION"                      
	2           "ILLNESS"                       
	3           "ALL OTHER"                     
	4           "VACATION"                      
	5           "ILLNESS"                       
	6           "ALL OTHER"                     
	7           "VACATION"                      
	8           "ILLNESS"                       
	9           "ALL OTHER"                     
	10          "VACATION"                      
	11          "ILLNESS"                       
	12          "ALL OTHER"                     
;
label values a_ag_na  P219L;  
label define P219L   
	-1          "NOT IN UNIVERSE"               
	1           "AGRICULTURE IND"               
	2           "NONAGRICULTURE IND"            
;
label values a_mjind  P220L;  
label define P220L   
	-1          "NOT IN UNIVERSE"               
	1           "AGRICULTURE"                   
	2           "MINING"                        
	3           "CONSTRUCTION"                  
	4           "MANUFACTURING-DURABLE GOODS"   
	5           "MANUFACTURING-NONDURABLE GOODS"
	6           "TRANSPORTATION"                
	7           "COMMUNICATIONS"                
	8           "UTILITIES AND SANITARY SERVICES"
	9           "WHOLESALE TRADE"               
	10          "RETAIL TRADE"                  
	11          "FINANCE,INSURANCE AND REAL ESTATE"
	12          "PRIVATE HOUSEHOLD"             
	13          "BUSINESS AND REPAIR"           
	14          "PERSONAL SERVICES, EXCEPT PRIVATE HOUSE"
	15          "ENTERTAINMENT"                 
	16          "HOSPITAL"                      
	17          "MEDICAL, EXCEPT HOSPITAL"      
	18          "EDUCATIONAL"                   
	19          "SOCIAL SERVICES"               
	20          "OTHER PROFESSIONAL"            
	21          "FORESTRY AND FISHERIES"        
	22          "PUBLIC ADMINISTRATION"         
	23          "ARMED FORCES"                  
;
label values a_mjocc  P221L;  
label define P221L   
	-1          "NOT IN UNIVERSE"               
	1           "EXECUTIVE, ADMIN. &  MANAGERIAL"
	2           "PROFESSIONAL SPECIALTY"        
	3           "TECHNICIANS &  RELATED SUPPORT"
	4           "SALES"                         
	5           "ADMINISTRATIVE SUPPORT, INCL. CLERICAL"
	6           "PRIVATE HOUSEHOLD"             
	7           "PROTECTIVE SERVICE"            
	8           "OTHER SERVICE"                 
	9           "PRECISION PRODUCTION, CRAFT &  REPAIR"
	10          "MACHINE OPERATORS, ASSEMBLERS &  INSPECT"
	11          "TRANSPORTATION &  MATERIAL MOVING"
	12          "HANDLERS, EQUIP. CLEANERS, ETC."
	13          "FARMING, FORESTRY &  FISHING"  
	14          "ARMED FORCES"                  
	15          "NO PREVIOUS EXPERIENCE - NEVER WORKED"
;
label values a_ernel  P222L;  
label define P222L   
	0           "NOT EARNINGS ELIGIBLE"         
	1           "EARNINGS ELIGIBLE"             
;
label values a_ioelig P223L;  
label define P223L   
	0           "NOT I &  O ELIGIBLE"           
	1           "I &  O ELIGIBLE"               
;
label values a_dscwk  P224L;  
label define P224L   
	0           "NON-DISCOURAGED WORKER"        
	1           "DISCOURAGED WORKER"            
;
label values a_dtclwk P225L;  
label define P225L   
	-1          "NOT IN UNIVERSE"               
	0           "OLD NOT IN UNIVERSE"           
	1           "PRIVATE"                       
	2           "GOVERNMENT"                    
	3           "SELF-EMPLOYED"                 
	4           "UNPAID FAMILY"                 
	5           "PRIVATE HOUSEHOLD"             
	6           "OTHER PRIVATE"                 
	7           "FEDERAL"                       
	8           "STATE"                         
	9           "LOCAL"                         
	10          "SELF-EMPLOYED"                 
	11          "UNPAID FAMILY"                 
;
label values a_emp    P226L;  
label define P226L   
	-1          "NOT IN UNIVERSE"               
	1           "IN UNIVERSE"                   
;
label values a_nagws  P227L;  
label define P227L   
	-1          "NOT IN UNIVERSE"               
	1           "IN UNIVERSE"                   
;
label values a_rcow   P228L;  
label define P228L   
	-1          "NOT IN UNIVERSE"               
	1           "PRIVATE"                       
	2           "FEDERAL"                       
	3           "STATE"                         
	4           "LOCAL"                         
	5           "SE-UNINC."                     
	6           "WITHOUT PAY"                   
	7           "NEVER WORKED"                  
;
label values a_nagpws P229L;  
label define P229L   
	-1          "NOT IN UNIVERSE"               
	1           "IN UNIVERSE"                   
;
label values a_herntp P230L;  
label define P230L   
	-1          "NOT IN UNIVERSE"               
;
label values a_werntp P231L;  
label define P231L   
	-1          "NOT IN UNIVERSE"               
;
label values a_herntf P232L;  
label define P232L   
	-1          "NOT IN UNIVERSE"               
	0           "NOT TOP CODED"                 
	1           "TOP CODED"                     
;
label values a_werntf P233L;  
label define P233L   
	-1          "NOT IN UNIVERSE"               
	0           "NOT TOP CODED"                 
	1           "TOP CODED"                     
;
label values a_ferntp P234L;  
label define P234L   
	-1          "NOT IN PRIMARY FAMILY OR NOT IN UNIVERS"
;
label values a_ferntf P235L;  
label define P235L   
	-1          "NOT IN UNIVERSE"               
	0           "NOT TOP CODED"                 
	1           "TOP CODED"                     
;
label values a_famnum P236L;  
label define P236L   
	0           "NOT A FAMILY MEMBER"           
	1           "PRIMARY FAMILY MEMBER ONLY"    
;
label values a_famtyp P237L;  
label define P237L   
	1           "PRIMARY FAMILY"                
	2           "PRIMARY INDIVIDUAL"            
	3           "RELATED SUBFAMILY"             
	4           "UNRELATED SUBFAMILY"           
	5           "SECONDARY INDIVIDUAL"          
;
label values a_famrel P238L;  
label define P238L   
	0           "NOT A FAMILY MEMBER"           
	1           "REFERENCE PERSON"              
	2           "SPOUSE"                        
	3           "CHILD"                         
	4           "OTHER RELATIVE (PRIMARY FAMILY &  UNRELA"
;
label values a_pfnocd P239L;  
label define P239L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO CHILDREN"                   
	2           "1 CHILD"                       
	3           "2 CHILDREN"                    
	4           "3 CHILDREN"                    
	5           "4 CHILDREN"                    
	6           "5 CHILDREN"                    
	7           "6 CHILDREN"                    
	8           "7 CHILDREN"                    
	9           "8+ CHILDREN"                   
;
label values a_pfprcd P240L;  
label define P240L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO CHILDREN < 18 YEARS OLD"    
	2           "ALL CHILDREN 0-2 YEARS OLD"    
	3           "ALL CHILDREN 3-5 YEARS OLD"    
	4           "ALL CHILDREN 6-13 YEARS OLD"   
	5           "ALL CHILDREN 14-17 YEARS OLD"  
	6           "CHILDREN 0-2 AND 3-5 (NONE 6-17)"
	7           "CHILDREN 0-2 AND 6-13 (NONE 3-5 OR 14-1"
	8           "CHILDREN 0-2 AND 14-17 (NONE 3-13)"
	9           "CHILDREN 3-5 AND 6-13 (NONE 0-2 OR 14-1"
	10          "CHILDREN 3-5 AND 14-17 (NONE 0-2 OR 6-1"
	11          "CHILDREN 6-13 AND 14-17 (NONE 0-5)"
	12          "CHILDREN 0-2, 3-5 AND 6-13 (NONE 14-17)"
	13          "CHILDREN 0-2, 3-5 AND 14-17 (NONE 6-13)"
	14          "CHILDREN 0-2, 6-13 AND 14-17 (NONE 3-5)"
	15          "CHILDREN 3-5, 6-13 AND 14-17 (NONE 0-2)"
	16          "CHILDREN FROM ALL AGE GROUPS"  
;
label values a_pfrel  P241L;  
label define P241L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "HUSBAND"                       
	2           "WIFE"                          
	3           "OWN CHILD"                     
	4           "OTHER RELATIVE"                
	5           "UNMARRIED REFERENCE PERSON"    
;
label values a_pfsize P242L;  
label define P242L   
	0           "NOT IN PRIMARY FAMILY"         
;
label values a_pfhhag P243L;  
label define P243L   
	0           "NOT A FAMILY MEMBER"           
	1           "< 25 YEARS OLD"                
	2           "25-44 YEARS OLD"               
	3           "45-54 YEARS OLD"               
	4           "55-64 YEARS OLD"               
	5           "65+ YEARS OLD"                 
;
label values a_lfesm  P244L;  
label define P244L   
	0           "NOT IN PRIMARY FAMILY/NO MALE" 
	1           "EMPLOYED EARNER"               
	2           "SELF-EMPLOYED"                 
	3           "WITHOUT PAY"                   
	4           "UNEMPLOYED"                    
	5           "NOT IN LABOR FORCE"            
	6           "ARMED FORCES"                  
;
label values a_lfesf  P245L;  
label define P245L   
	0           "NOT IN PRIMARY FAMILY/NO FEMALE"
	1           "EMPLOYED EARNER"               
	2           "SELF-EMPLOYED"                 
	3           "WITHOUT PAY"                   
	4           "UNEMPLOYED"                    
	5           "NOT IN LABOR FORCE"            
	6           "ARMED FORCES"                  
;
label values a_pfws   P246L;  
label define P246L   
	-1          "NOT IN PRIMARY FAMILY"         
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO ONE EMPLOYED"               
	2           "SOME EMPLOYED - NO WAGE &  SALARY WORKER"
	3           "WITH WAGE &  SALARY WORKERS, HUSBAND/WIF"
	4           "WITH WAGE &  SALARY WORKERS, HUSBAND/WIF"
	5           "WITH WAGE &  SALARY WORKERS ONLY"
;
label values a_pfftpt P247L;  
label define P247L   
	-1          "NOT IN UNIVERSE (MIS 1,2,3,5,6,7)"
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO EARNERS"                    
	2           "ALL EARNERS FULL TIME"         
	3           "SOME FULL TIME, SOME PART TIME"
	4           "ALL EARNERS PART TIME"         
	5           "NOT IN UNIVERSE"               
;
label values a_pfearn P248L;  
label define P248L   
	-1          "NOT IN PRIMARY FAMILY OR NOT IN UNIVERS"
;
label values a_pfnder P249L;  
label define P249L   
	-1          "NOT IN UNIVERSE"               
	0           "NO EARNERS"                    
	9           "9+ EARNERS"                    
;
label values a_pfnoem P250L;  
label define P250L   
	-1          "NOT IN UNIVERSE"               
	0           "NO EMPLOYED"                   
	9           "9+ EMPLOYED"                   
;
label values a_pfnoum P251L;  
label define P251L   
	-1          "NOT IN UNIVERSE"               
	0           "NO UNEMPLOYED"                 
	9           "9+ UNEMPLOYED"                 
;
label values aplineno P252L;  
label define P252L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
;
label values aprrp    P253L;  
label define P253L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
;
label values apparent P254L;  
label define P254L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
;
label values apage    P255L;  
label define P255L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	4           "ALLOCATED"                     
;
label values apmaritl P256L;  
label define P256L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
	5           "VALUE TO VALUE - NO ERROR"     
;
label values apspouse P257L;  
label define P257L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
;
label values apsex    P258L;  
label define P258L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apvet    P259L;  
label define P259L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values aphga    P260L;  
label define P260L   
	0           "NO CHANGE"                     
	4           "ALLOCATED"                     
;
label values aprace   P261L;  
label define P261L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	4           "ALLOCATED"                     
;
label values aporigin P262L;  
label define P262L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
	8           "BLANK TO N/A CODE"             
;
label values aplfsr   P263L;  
label define P263L   
	0           "NO CHANGE"                     
	4           "ALLOCATED"                     
;
label values apmajact P264L;  
label define P264L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apanywk  P265L;  
label define P265L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values aphrs    P266L;  
label define P266L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values aphrschk P267L;  
label define P267L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apuslft  P268L;  
label define P268L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apftreas P269L;  
label define P269L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values aplostim P270L;  
label define P270L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apovrtim P271L;  
label define P271L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apjobabs P272L;  
label define P272L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apwhyabs P273L;  
label define P273L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values appayabs P274L;  
label define P274L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apftabs  P275L;  
label define P275L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values aplkwk   P276L;  
label define P276L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apmthd   P277L;  
label define P277L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apwhylk  P278L;  
label define P278L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apwkslk  P279L;  
label define P279L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values aplkftpt P280L;  
label define P280L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apavail  P281L;  
label define P281L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apwhyna  P282L;  
label define P282L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apwhenlj P283L;  
label define P283L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apind    P284L;  
label define P284L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apocc    P285L;  
label define P285L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apclswkr P286L;  
label define P286L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apnlflj  P287L;  
label define P287L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apwhylft P288L;  
label define P288L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apwantjb P289L;  
label define P289L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apwhynl  P290L;  
label define P290L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apintend P291L;  
label define P291L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apuslhrs P292L;  
label define P292L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values aphrlywk P293L;  
label define P293L   
	-1          "NOT IN UNIVERSE"               
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values aphrspay P294L;  
label define P294L   
	-1          "NOT IN UNIVERSE"               
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apgrswk  P295L;  
label define P295L   
	-1          "NOT  IN UNIVERSE"              
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apunmem  P296L;  
label define P296L   
	-1          "NOT IN UNIVERSE"               
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apuncov  P297L;  
label define P297L   
	-1          "NOT IN UNIVERSE"               
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apenrchk P298L;  
label define P298L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apenrlw  P299L;  
label define P299L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values aphscol  P300L;  
label define P300L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values apftpt   P301L;  
label define P301L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values l_majact P302L;  
label define P302L   
	1           "WORKING"                       
	2           "WITH JOB BUT NOT AT WORK"      
	3           "LOOKING FOR WORK"              
	4           "KEEPING HOUSE"                 
	5           "GOING TO SCHOOL"               
	6           "UNABLE TO WORK"                
	7           "RETIRED"                       
	8           "OTHER"                         
;
label values l_hrs1   P303L;  
label define P303L   
	-1          "NOT IN UNIVERSE"               
;
label values l_uslft  P304L;  
label define P304L   
	-1          "NOT IN UNIVERSE"               
	1           "YES"                           
	2           "NO"                            
;
label values l_ftreas P305L;  
label define P305L   
	-1          "NOT IN UNIVERSE"               
	1           "SLACK WORK"                    
	2           "MATERIAL SHORTAGE"             
	3           "PLANT OR MACHINE REPAIR"       
	4           "NEW JOB STARTED DURING WEEK"   
	5           "JOB TERMINATED DURING WEEK"    
	6           "COULD FIND ONLY PART TIME WORK"
	7           "HOLIDAY"                       
	8           "LABOR DISPUTE"                 
	9           "BAD WEATHER"                   
	10          "OWN ILLNESS"                   
	11          "ON VACATION"                   
	12          "TOO BUSY WITH HOUSE, SCHOOL, ETC."
	13          "DID NOT WANT FULL TIME WORK"   
	14          "FULL-TIME WORK WEEKS < 35 HRS" 
	15          "OTHER"                         
;
label values l_whyabs P306L;  
label define P306L   
	-1          "NOT IN UNIVERSE"               
	1           "OWN ILLNESS"                   
	2           "ON VACATION"                   
	3           "BAD WEATHER"                   
	4           "LABOR DISPUTE"                 
	5           "NEW JOB TO BEGIN WITHIN 30 DAYS"
	6           "TEMPORARY LAYOFF (UNDER 30 DAYS)"
	7           "INDEFINITE LAYOFF (30 DAYS OR MORE)"
	8           "OTHER"                         
;
label values l_wkslk  P307L;  
label define P307L   
	-1          "NOT IN UNIVERSE"               
;
label values l_lkftpt P308L;  
label define P308L   
	-1          "NOT IN UNIVERSE"               
	1           "FULL-TIME"                     
	2           "PART-TIME"                     
;
label values l_ind    P309L;  
label define P309L   
	-1          "NOT IN UNIVERSE"               
	0           "OLD NOT IN UNIVERSE"           
;
label values l_occ    P310L;  
label define P310L   
	-1          "NOT IN UNIVERSE"               
	0           "OLD NOT IN UNIVERSE"           
;
label values l_lfsr   P311L;  
label define P311L   
	1           "WORKING"                       
	2           "WITH JOB,NOT AT WORK"          
	3           "UNEMPLOYED, LOOKING FOR WORK"  
	4           "UNEMPLOYED, ON LAYOFF"         
	5           "NILF - WORKING W/O PAY < 15 HRS;"
	6           "NILF - UNAVAILABLE"            
	7           "OTHER NILF"                    
;
label values l_wkstat P312L;  
label define P312L   
	1           "NOT IN LABOR FORCE"            
	2           "FULL-TIME SCHEDULES"           
	3           "PART-TIME FOR ECONOMIC REASONS, USUALLY"
	4           "PART-TIME FOR NON-ECONOMIC REASONS, USU"
	5           "PART-TIME FOR ECONOMIC REASONS, USUALLY"
	6           "UNEMPLOYED F/T"                
	7           "UNEMPLOYED P/T"                
;
label values l_wksch  P313L;  
label define P313L   
	-1          "NOT IN UNIVERSE"               
	1           "AT WORK"                       
	2           "WITH JOB, NOT AT WORK"         
	3           "UNEMPLOYED, SEEKS F/T"         
	4           "UNEMPLOYED, SEEKS P/T"         
;
label values l_mjind  P314L;  
label define P314L   
	-1          "NOT IN UNIVERSE"               
	1           "AGRICULTURE"                   
	2           "MINING"                        
	3           "CONSTRUCTION"                  
	4           "MANUFACTURING-DURABLE GOODS"   
	5           "MANUFACTURING-NONDURABLE GOODS"
	6           "TRANSPORTATION"                
	7           "COMMUNICATIONS"                
	8           "UTILITIES AND SANITARY SERVICES"
	9           "WHOLESALE TRADE"               
	10          "RETAIL TRADE"                  
	11          "FINANCE,INSURANCE AND REAL ESTATE"
	12          "PRIVATE HOUSEHOLD"             
	13          "BUSINESS AND REPAIR"           
	14          "PERSONAL SERVICES, EXCEPT PRIVATE HOUSE"
	15          "ENTERTAINMENT"                 
	16          "HOSPITAL"                      
	17          "MEDICAL, EXCEPT HOSPITAL"      
	18          "EDUCATIONAL"                   
	19          "SOCIAL SERVICES"               
	20          "OTHER PROFESSIONAL"            
	21          "FORESTRY AND FISHERIES"        
	22          "PUBLIC ADMINISTRATION"         
	23          "ARMED FORCES"                  
;
label values l_mjocc  P315L;  
label define P315L   
	-1          "NOT IN UNIVERSE"               
	1           "EXECUTIVE, ADMIN. &  MANAGERIAL"
	2           "PROFESSIONAL SPECIALTY"        
	3           "TECHNICIANS &  RELATED SUPPORT"
	4           "SALES"                         
	5           "ADMINISTRATIVE SUPPORT, INCL. CLERICAL"
	6           "PRIVATE HOUSEHOLD"             
	7           "PROTECTIVE SERVICE"            
	8           "OTHER SERVICE"                 
	9           "PRECISION PRODUCTION, CRAFT &  REPAIR"
	10          "MACHINE OPERATORS, ASSEMBLERS &  INSPECT"
	11          "TRANSPORTATION &  MATERIAL MOVING"
	12          "HANDLERS, EQUIP. CLEANERS, ETC."
	13          "FARMING, FORESTRY &  FISHING"  
	14          "ARMED FORCES"                  
	15          "NO PREVIOUS EXPERIENCE - NEVER WORKED"
;
label values l_rcow   P316L;  
label define P316L   
	-1          "NOT IN UNIVERSE"               
	1           "PRIVATE"                       
	2           "FEDERAL"                       
	3           "STATE"                         
	4           "LOCAL"                         
	5           "SE-UNINC."                     
	6           "WITHOUT PAY"                   
	7           "NEVER WORKED"                  
;
label values l_ag_na  P317L;  
label define P317L   
	-1          "NOT IN UNIVERSE"               
	1           "AGRICULTURE IND"               
	2           "NONAGRICULTURE IND"            
;
label values l_flag   P318L;  
label define P318L   
	0           "NOT IN UNIVERSE - MIS = 1 OR 5"
	1           "MATCHED WITH LAST MONTH RECORD"
	2           "NOT MATCHED WITH LAST MONTH RECORD"
;
label values lpmajact P319L;  
label define P319L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values lphrs1   P320L;  
label define P320L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values lpuslft  P321L;  
label define P321L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values lpftreas P322L;  
label define P322L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values lpwhyabs P323L;  
label define P323L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values lpwkslk  P324L;  
label define P324L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values lplkftpt P325L;  
label define P325L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values lpind    P326L;  
label define P326L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values lpocc    P327L;  
label define P327L   
	0           "NO CHANGE"                     
	1           "VALUE TO BLANK"                
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values lplfsr   P328L;  
label define P328L   
	0           "NO CHANGE"                     
	4           "ALLOCATED"                     
;
label values cdrrp    P329L;  
label define P329L   
	1           "NATUAL/ADOPTED CHILD"          
	2           "STEP CHILD"                    
	3           "GRANDCHILD"                    
	4           "BROTHER/SISTER"                
	5           "OTHER RELATIVE OF REF PER"     
	6           "FOSTER CHILD"                  
	7           "NON-REL OF REF PER WITH OWN RELS IN HHL"
	8           "NON-REL OF REF PER-NO OWN RELS IN HHLD"
;
label values cdprntno P330L;  
label define P330L   
	0           "NONE"                          
;
label values cdsex    P331L;  
label define P331L   
	1           "MALE"                          
	2           "FEMALE"                        
;
label values cdrace   P332L;  
label define P332L   
	1           "WHITE"                         
	2           "BLACK"                         
	3           "AMER INDIAN, ALEUT ESKIMO"     
	4           "ASIAN OR PACIFIC ISL"          
	5           "OTHER"                         
;
label values c_rrp    P333L;  
label define P333L   
	5           "OWN CHILD"                     
	7           "BROTHER/SISTER"                
	8           "OTHER RELATIVE OF REF PER"     
	9           "NON-REL OF REF PER WITH OWN RELS IN HHL"
	10          "NON-REL OF REF PER-NO OWN RELS IN HHLD"
;
label values c_parent P334L;  
label define P334L   
	0           "NONE"                          
;
label values c_sex    P335L;  
label define P335L   
	1           "MALE"                          
	2           "FEMALE"                        
;
label values c_race   P336L;  
label define P336L   
	1           "WHITE"                         
	2           "BLACK"                         
	3           "AMER INDIAN, ALEUT ESKIMO"     
	4           "ASIAN OR PACIFIC ISL"          
	5           "OTHER"                         
;
label values c_reorgn P337L;  
label define P337L   
	1           "MEXICAN AMERICAN"              
	2           "CHICANO"                       
	3           "MEXICAN (MEXICANO)"            
	4           "PUERTO RICAN"                  
	5           "CUBAN"                         
	6           "CENTRAL OR SOUTH AMERICAN"     
	7           "OTHER SPANISH"                 
	8           "ALL OTHER"                     
	9           "DON'T KNOW"                    
	10          "NA"                            
;
label values c_exprrp P338L;  
label define P338L   
	5           "NATURAL/ADOPTED CHILD"         
	6           "STEP CHILD"                    
	7           "GRANDCHILD"                    
	9           "BROTHER/SISTER"                
	10          "OTHER RELATIVE"                
	11          "FOSTER CHILD"                  
	12          "NONRELATIVE WITH RELATIVES"    
	14          "NONRELATIVE WITHOUT RELATIVES" 
;
label values c_famnum P339L;  
label define P339L   
	0           "NOT A FAMILY MEMBER"           
	1           "PRIMARY FAMILY MEMBER ONLY"    
;
label values c_famtyp P340L;  
label define P340L   
	1           "PRIMARY FAMILY"                
	2           "PRIMARY INDIVIDUAL"            
	3           "RELATED SUBFAMILY"             
	4           "UNRELATED SUBFAMILY"           
	5           "SECONDARY INDIVIDUAL"          
;
label values c_famrel P341L;  
label define P341L   
	0           "NOT A FAMILY MEMBER"           
	1           "REFERENCE PERSON"              
	2           "SPOUSE"                        
	3           "CHILD"                         
	4           "OTHER RELATIVE (PRIMARY FAMILY &  UNRELA"
;
label values c_pfnocd P342L;  
label define P342L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO CHILDREN"                   
	2           "1 CHILD"                       
	3           "2 CHILDREN"                    
	4           "3 CHILDREN"                    
	5           "4 CHILDREN"                    
	6           "5 CHILDREN"                    
	7           "6 CHILDREN"                    
	8           "7 CHILDREN"                    
	9           "8+ CHILDREN"                   
;
label values c_pfprcd P343L;  
label define P343L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO CHILDREN < 18 YEARS OLD"    
	2           "ALL CHILDREN 0-2 YEARS OLD"    
	3           "ALL CHILDREN 3-5 YEARS OLD"    
	4           "ALL CHILDREN 6-13 YEARS OLD"   
	5           "ALL CHILDREN 14-17 YEARS OLD"  
	6           "CHILDREN 0-2 AND 3-5 (NONE 6-17)"
	7           "CHILDREN 0-2 AND 6-13 (NONE 3-5 OR 14-1"
	8           "CHILDREN 0-2 AND 14-17 (NONE 3-13)"
	9           "CHILDREN 3-5 AND 6-13 (NONE 0-2 OR 14-1"
	10          "CHILDREN 3-5 AND 14-17 (NONE 0-2 OR 6-1"
	11          "CHILDREN 6-13 AND 14-17 (NONE 0-5)"
	12          "CHILDREN 0-2, 3-5 AND 6-13 (NONE 14-17)"
	13          "CHILDREN 0-2, 3-5 AND 14-17 (NONE 6-13)"
	14          "CHILDREN 0-2, 6-13 AND 14-17 (NONE 3-5)"
	15          "CHILDREN 3-5, 6-13 AND 14-17 (NONE 0-2)"
	16          "CHILDREN FROM ALL AGE GROUPS"  
;
label values c_pfrel  P344L;  
label define P344L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "HUSBAND"                       
	2           "WIFE"                          
	3           "OWN CHILD"                     
	4           "OTHER RELATIVE"                
	5           "UNMARRIED REFERENCE PERSON"    
;
label values c_pfsize P345L;  
label define P345L   
	0           "NOT IN PRIMARY FAMILY"         
;
label values c_pfhhag P346L;  
label define P346L   
	0           "NOT A FAMILY MEMBER"           
	1           "< 25 YEARS OLD"                
	2           "25-44 YEARS OLD"               
	3           "45-54 YEARS OLD"               
	4           "55-64 YEARS OLD"               
	5           "65+ YEARS OLD"                 
;
label values c_lfesm  P347L;  
label define P347L   
	0           "NOT IN PRIMARY FAMILY/NO MALE" 
	1           "EMPLOYED EARNER"               
	2           "SELF-EMPLOYED"                 
	3           "WITHOUT PAY"                   
	4           "UNEMPLOYED"                    
	5           "NOT IN LABOR FORCE"            
	6           "ARMED FORCES"                  
;
label values c_lfesf  P348L;  
label define P348L   
	0           "NOT IN PRIMARY FAMILY/NO FEMALE"
	1           "EMPLOYED EARNER"               
	2           "SELF-EMPLOYED"                 
	3           "WITHOUT PAY"                   
	4           "UNEMPLOYED"                    
	5           "NOT IN LABOR FORCE"            
	6           "ARMED FORCES"                  
;
label values c_pfws   P349L;  
label define P349L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO ONE EMPLOYED"               
	2           "SOME EMPLOYED - NO WAGE &  SALARY WORKER"
	3           "WITH WAGE &  SALARY WORKERS, HUSBAND/WIF"
	4           "WITH WAGE &  SALARY WORKERS, HUSBAND/WIF"
	5           "WITH WAGE &  SALARY WORKERS ONLY"
;
label values c_pfftpt P350L;  
label define P350L   
	-1          "NOT IN UNIVERSE (MIS 1,2,3,5,6,7)"
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO EARNERS"                    
	2           "ALL EARNERS FULL TIME"         
	3           "SOME FULL TIME, SOME PART TIME"
	4           "ALL EARNERS PART TIME"         
	5           "NOT IN UNIVERSE"               
;
label values c_pfearn P351L;  
label define P351L   
	-1          "NOT IN UNIVERSE OR NOT IN PRIMARY FAMIL"
;
label values c_pfnoer P352L;  
label define P352L   
	-1          "NOT IN UNIVERSE (NOT IN PRIMARY FAMILY)"
	0           "NO EARNERS"                    
	9           "9+ EARNERS"                    
;
label values c_pfnoem P353L;  
label define P353L   
	-1          "NOT IN UNIVERSE"               
	0           "NO ONE EMPLOYED"               
	9           "9+ EMPLOYED"                   
;
label values c_pfnoun P354L;  
label define P354L   
	-1          "NOT IN UNIVERSE (NOT IN PRIMARY FAMILY)"
	0           "NO UNEMPLOYED"                 
	9           "9+ UNEMPLOYED"                 
;
label values cplineno P355L;  
label define P355L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
;
label values cprrp    P356L;  
label define P356L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
;
label values cpparent P357L;  
label define P357L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
;
label values cpage    P358L;  
label define P358L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	4           "ALLOCATED"                     
;
label values cpsex    P359L;  
label define P359L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values cprace   P360L;  
label define P360L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	4           "ALLOCATED"                     
;
label values cporigin P361L;  
label define P361L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
	8           "BLANK TO N/A CODE"             
;
label values mdrrp    P362L;  
label define P362L   
	1           "REF PER WITH OTHER RELATIVES IN HHLD"
	2           "REF PER WITH NO OTHER RELATIVES IN HHLD"
	3           "HUSBAND"                       
	4           "WIFE"                          
	5           "NATUAL/ADOPTED CHILD"          
	6           "STEP CHILD"                    
	7           "GRANDCHILD"                    
	8           "PARENT"                        
	9           "BROTHER/SISTER"                
	10          "OTHER RELATIVE OF REF PER"     
	11          "FOSTER CHILD"                  
	12          "NON-REL OF REF PER WITH OWN RELS IN HHL"
	13          "PARTNER/ROOMATE"               
	14          "NON-REL OF REF PER-NO OWN RELS IN HHLD"
;
label values mdprntno P363L;  
label define P363L   
	1           "NONE"                          
;
label values mdmarit  P364L;  
label define P364L   
	1           "MARRIED - SPOUSE PRESENT"      
	2           "MARRIED - SPOUSE ABSENT (EXC SEPARATED)"
	3           "WIDOWED"                       
	4           "DIVORCED"                      
	5           "SEPARATED"                     
	6           "NEVER MARRIED"                 
;
label values mdspsnon P365L;  
label define P365L   
	1           "NONE"                          
;
label values mdsex    P366L;  
label define P366L   
	1           "MALE"                          
	2           "FEMALE"                        
;
label values mdhgc    P367L;  
label define P367L   
	1           "YES"                           
	2           "NO"                            
;
label values mdrace   P368L;  
label define P368L   
	1           "WHITE"                         
	2           "BLACK"                         
	3           "AMER INDIAN, ALEUT, ESKIMO"    
	4           "ASIAN OR PACIFIC ISL"          
	5           "OTHER"                         
;
label values m_rrp    P369L;  
label define P369L   
	1           "REF PER WITH OTHER RELATIVES IN HHLD"
	2           "REF PER WITH NO OTHER RELATIVES IN HHLD"
	3           "HUSBAND"                       
	4           "WIFE"                          
	5           "OWN CHILD"                     
	6           "PARENT"                        
	7           "BROTHER/SISTER"                
	8           "OTHER RELATIVE OF REF PER"     
	9           "NON-REL OF REF PER WITH OWN RELS IN HHL"
	10          "NON-REL OF REF PER-NO OWN RELS IN HHLD"
;
label values m_parent P370L;  
label define P370L   
	0           "NONE"                          
;
label values m_maritl P371L;  
label define P371L   
	1           "MARRIED - CIVILIAN SPOUSE PRESENT"
	2           "MARRIED - AF SPOUSE PRESENT"   
	3           "MARRIED - SPOUSE ABSENT (EXC SEPARATED)"
	4           "WIDOWED"                       
	5           "DIVORCED"                      
	6           "SEPARATED"                     
	7           "NEVER MARRIED"                 
;
label values m_spouse P372L;  
label define P372L   
	0           "NONE"                          
;
label values m_sex    P373L;  
label define P373L   
	1           "MALE"                          
	2           "FEMALE"                        
;
label values m_hga    P374L;  
label define P374L   
	0           "NONE"                          
	1           "E1"                            
	2           "E2"                            
	3           "E3"                            
	4           "E4"                            
	5           "E5"                            
	6           "E6"                            
	7           "E7"                            
	8           "E8"                            
	9           "H1"                            
	10          "H2"                            
	11          "H3"                            
	12          "H4"                            
	13          "C1"                            
	14          "C2"                            
	15          "C3"                            
	16          "C4"                            
	17          "C5"                            
	18          "C6+"                           
;
label values m_hgc    P375L;  
label define P375L   
	1           "YES"                           
	2           "NO"                            
;
label values m_race   P376L;  
label define P376L   
	1           "WHITE"                         
	2           "BLACK"                         
	3           "AMER INDIAN, ALEUT ESKIMO"     
	4           "ASIAN OR PACIFIC ISL"          
	5           "OTHER"                         
;
label values m_reorgn P377L;  
label define P377L   
	1           "MEXICAN AMERICAN"              
	2           "CHICANO"                       
	3           "MEXICAN (MEXICANO)"            
	4           "PUERTO RICAN"                  
	5           "CUBAN"                         
	6           "CENTRAL OR SOUTH AMERICAN"     
	7           "OTHER SPANISH"                 
	8           "ALL OTHER"                     
	9           "DON'T KNOW"                    
	10          "NA"                            
;
label values m_exprrp P378L;  
label define P378L   
	1           "REFERENCE PERSON WITH RELATIVES"
	2           "REFERENCE PERSON WITHOUT RELATIVES"
	3           "HUSBAND"                       
	4           "WIFE"                          
	5           "NATURAL/ADOPTED CHILD"         
	6           "STEP CHILD"                    
	7           "GRANDCHILD"                    
	8           "PARENT"                        
	9           "BROTHER/SISTER"                
	10          "OTHER RELATIVE"                
	11          "FOSTER CHILD"                  
	12          "NONRELATIVE WITH RELATIVES"    
	13          "PARTNER/ROOMMATE"              
	14          "NONRELATIVE WITHOUT RELATIVES" 
;
label values m_famnum P379L;  
label define P379L   
	0           "NOT A FAMILY MEMBER"           
	1           "PRIMARY FAMILY MEMBER ONLY"    
;
label values m_famtyp P380L;  
label define P380L   
	1           "PRIMARY FAMILY"                
	2           "PRIMARY INDIVIDUAL"            
	3           "RELATED SUBFAMILY"             
	4           "UNRELATED SUBFAMILY"           
	5           "SECONDARY INDIVIDUAL"          
;
label values m_famrel P381L;  
label define P381L   
	0           "NOT A FAMILY MEMBER"           
	1           "REFERENCE PERSON"              
	2           "SPOUSE"                        
	3           "CHILD"                         
	4           "OTHER RELATIVE (PRIMARY FAMILY &  UNRELA"
;
label values m_pfnocd P382L;  
label define P382L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO CHILDREN"                   
	2           "1 CHILD"                       
	3           "2 CHILDREN"                    
	4           "3 CHILDREN"                    
	5           "4 CHILDREN"                    
	6           "5 CHILDREN"                    
	7           "6 CHILDREN"                    
	8           "7 CHILDREN"                    
	9           "8+ CHILDREN"                   
;
label values m_pfprcd P383L;  
label define P383L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO CHILDREN < 18 YEARS OLD"    
	2           "ALL CHILDREN 0-2 YEARS OLD"    
	3           "ALL CHILDREN 3-5 YEARS OLD"    
	4           "ALL CHILDREN 6-13 YEARS OLD"   
	5           "ALL CHILDREN 14-17 YEARS OLD"  
	6           "CHILDREN 0-2 AND 3-5 (NONE 6-17)"
	7           "CHILDREN 0-2 AND 6-13 (NONE 3-5 OR 14-1"
	8           "CHILDREN 0-2 AND 14-17 (NONE 3-13)"
	9           "CHILDREN 3-5 AND 6-13 (NONE 0-2 OR 14-1"
	10          "CHILDREN 3-5 AND 14-17 (NONE 0-2 OR 6-1"
	11          "CHILDREN 6-13 AND 14-17 (NONE 0-5)"
	12          "CHILDREN 0-2, 3-5 AND 6-13 (NONE 14-17)"
	13          "CHILDREN 0-2, 3-5 AND 14-17 (NONE 6-13)"
	14          "CHILDREN 0-2, 6-13 AND 14-17 (NONE 3-5)"
	15          "CHILDREN 3-5, 6-13 AND 14-17 (NONE 0-2)"
	16          "CHILDREN FROM ALL AGE GROUPS"  
;
label values m_pfrel  P384L;  
label define P384L   
	0           "NOT IN PRIMARY FAMILY"         
	1           "HUSBAND"                       
	2           "WIFE"                          
	3           "OWN CHILD"                     
	4           "OTHER RELATIVE"                
	5           "UNMARRIED REFERENCE PERSON"    
;
label values m_pfsize P385L;  
label define P385L   
	0           "NOT IN PRIMARY FAMILY"         
;
label values m_pfhhag P386L;  
label define P386L   
	0           "NOT A FAMILY MEMBER"           
	1           "< 25 YEARS OLD"                
	2           "25-44 YEARS OLD"               
	3           "45-54 YEARS OLD"               
	4           "55-64 YEARS OLD"               
	5           "65+ YEARS OLD"                 
;
label values m_lfesm  P387L;  
label define P387L   
	0           "NOT IN PRIMARY FAMILY/NO MALE" 
	1           "EMPLOYED EARNER"               
	2           "SELF-EMPLOYED"                 
	3           "WITHOUT PAY"                   
	4           "UNEMPLOYED"                    
	5           "NOT IN LABOR FORCE"            
	6           "ARMED FORCES"                  
;
label values m_lfesf  P388L;  
label define P388L   
	0           "NOT IN PRIMARY FAMILY/NO FEMALE"
	1           "EMPLOYED EARNER"               
	2           "SELF-EMPLOYED"                 
	3           "WITHOUT PAY"                   
	4           "UNEMPLOYED"                    
	5           "NOT IN LABOR FORCE"            
	6           "ARMED FORCES"                  
;
label values m_pfws   P389L;  
label define P389L   
	-1          "NOT IN PRIMARY FAMILY"         
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO ONE EMPLOYED"               
	2           "SOME EMPLOYED - NO WAGE &  SALARY WORKER"
	3           "WITH WAGE &  SALARY WORKERS, HUSBAND/WIF"
	4           "WITH WAGE &  SALARY WORKERS, HUSBAND/WIF"
	5           "WITH WAGE &  SALARY WORKERS ONLY"
;
label values m_pfftpt P390L;  
label define P390L   
	-1          "NOT IN UNIVERSE (MIS 1,2,3,5,6,7)"
	0           "NOT IN PRIMARY FAMILY"         
	1           "NO EARNERS"                    
	2           "ALL EARNERS FULL TIME"         
	3           "SOME FULL TIME, SOME PART TIME"
	4           "ALL EARNERS PART TIME"         
	5           "NOT IN UNIVERSE"               
;
label values m_pfnoer P391L;  
label define P391L   
	-1          "NOT IN UNIVERSE (NOT IN PRIMARY FAMILY)"
	0           "NO EARNERS"                    
	9           "9+ EARNERS"                    
;
label values m_pfnoem P392L;  
label define P392L   
	-1          "NOT IN UNIVERSE"               
	0           "NO ONE EMPLOYED"               
	9           "9+ EMPLOYED"                   
;
label values m_pfnoun P393L;  
label define P393L   
	-1          "NOT IN UNIVERSE (NOT IN PRIMARY FAMILY)"
	0           "NO UNEMPLOYED"                 
	9           "9+ UNEMPLOYED"                 
;
label values mplineno P394L;  
label define P394L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
;
label values mprrp    P395L;  
label define P395L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
;
label values mpparent P396L;  
label define P396L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
;
label values mpage    P397L;  
label define P397L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	4           "ALLOCATED"                     
;
label values mpmaritl P398L;  
label define P398L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
	5           "VALUE TO VALUE - NO ERROR"     
;
label values mpspouse P399L;  
label define P399L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
;
label values mpsex    P400L;  
label define P400L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	3           "VALUE TO VALUE"                
	4           "ALLOCATED"                     
;
label values mphga    P401L;  
label define P401L   
	0           "NO CHANGE"                     
	4           "ALLOCATED"                     
;
label values mprace   P402L;  
label define P402L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	4           "ALLOCATED"                     
;
label values mporigin P403L;  
label define P403L   
	0           "NO CHANGE"                     
	2           "BLANK TO VALUE"                
	5           "VALUE TO VALUE - NO ERROR"     
	8           "BLANK TO N/A CODE"             
;
#delimit cr
