capture log close
log using cpsrwdec07.log, replace
set mem 500m

/*------------------------------------------------
  by Jean Roth Fri Feb 27 13:10:21 EST 2009
  Please report errors to jroth@nber.org
  NOTE:  This program is distributed under the GNU GPL. 
  See end of this file and http://www.gnu.org/licenses/ for details.
  Run with do cpsrwdec07
----------------------------------------------- */

/* The following line should contain
   the complete path and name of the raw data file.
   On a PC, use backslashes in paths as in C:\  */   

local dat_name cpsrwdec07.dat

/* The following line should contain the path to your output '.dta' file */

local dta_name "./cpsrwdec07.dta"

/* The following line should contain the path to the data dictionary file */

local dct_name "./cpsrwdec07.dct"

/* The line below does NOT need to be changed */

quietly infile using "`dct_name'", using("`dat_name'") clear

/*------------------------------------------------

  All items, except those with one character, also can have values
  of -1, -2, or -3 even if the values are not in the documentation
  The meaning is
       -1 .Blank or not in universe
       -2 .Don't know
       -3 .Refused

  The following changes in variable names have been made, if necessary:
      '$' to 'd';            '-' to '_';              '%' to 'p';
      ($ = unedited data;     - = edited data;         % = allocated data)

  Decimal places have been made explict in the dictionary file.  
  Stata resolves a missing value of -1 / # of decimal places as a missing value.  
 -----------------------------------------------*/

** These note statements incorporate variable universes into the Stata data file.
note: by Jean Roth, jroth@nber.org Fri Feb 27 13:10:21 EST 2009
note pwcmpwgt: U PRPERTYP = 1-3
*Everything below this point, aside from the final save, are value labels

#delimit ;

;

#delimit cr
compress
saveold `dta_name' , replace

/*
Copyright 2009 shared by the National Bureau of Economic Research and Jean Roth

National Bureau of Economic Research.
1050 Massachusetts Avenue
Cambridge, MA 02138
jroth@nber.org

This program and all programs referenced in it are free software. You
can redistribute the program or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
USA.
*/
