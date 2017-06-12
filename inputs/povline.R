# Calculate families' poverty status from the ASEC. This is as close as we can get to replicating the official poverty measure.

library(data.table)
library(readstata13)
library(magrittr)

`%!in%` <- function(x,y) !`%in%`(x,y)

# get poverty thresholds
source('thresholds.R')

# datafiles names
files <- paste0('../data-asec/cpsmar', sprintf(0:16, fmt = '%0.2i'), '.dta')

poverty <- vector(length = 16)
for (yr in 1999:2015) {
  message(yr)
  
  rewrite <- F
  
  # asec gives OPM of previous year
  i <- yr - 1999 + 1
  if (rewrite){  
    asec <- read.dta13(files[i],
                     convert.factors = F)
    if ("./cache" %!in% list.dirs()) dir.create('cache')
    saveRDS(asec, paste0('cache/asec', substr(yr,3,4)))
    } else {
  asec <- readRDS(paste0('cache/asec', substr(yr,3,4))) }

  attr.asec <- attributes(asec)
  names(attr.asec$var.labels) <- names(asec)
  asec <- data.table(asec)
  
  # h_idnum identifies households according to NBER matching files 
  # but there are 17 more fh_seq than h_idnum
  
  if(length(names(asec)[grep('h_idnum', names(asec))]) == 2) {
    asec[, h_idnum := paste0(h_idnum1, h_idnum2)]
  }
  # note: official poverty rate can be calculated using fh_seq or h_idnum as household variable.
  # but h_idnum is not enough for 2001-2003 , so we choose fh_seq

  # identify primary families
  asec[ftype == 3, ftype2 := 1L]  # move related subfamilies into primary family
  asec[ftype != 3, ftype2 := as.integer(ftype)]
  
  # create unique family identifier
  asec[ftype2 == 1, fid := 1]
  asec[ftype2 != 1, fid := as.numeric(paste0(ftype, ffpos))]
  
  # calculate family income 
  asec[, fincome := sum(ptotval), by = .(fh_seq, fid)]
  
  # count people in family
  asec[, nkid := sum(a_age < 18), by = .(fh_seq, fid)]
  asec[nkid > 8, nkid := 8]
  
  asec[, nppl := .N + 2, by = .(fh_seq, fid)]  # gives space for nppl to vary by family age
  
  # calculate family age
  asec[ftype %in% 1:3 & perrp %in% 1:2, hhage := a_age, by = fh_seq]              # identify reference person's age
  asec[ftype %in% 1:3, hhage := as.integer(max(hhage, na.rm = T)), by = fh_seq]   # give others that hhage
  asec[ftype > 3, hhage := as.integer(max(a_age)), by = .(fh_seq, fid)]           # unrelated subfamilies get oldest in family
  
  # vary nppl by family age
  asec[hhage <  65 & nppl == 3, nppl := 1]
  asec[hhage >= 65 & nppl == 3, nppl := 2]
  asec[hhage <  65 & nppl == 4, nppl := 3]
  asec[hhage >= 65 & nppl == 4, nppl := 4]
  
  # get threshold
  tm <- (yr - 1999) * 12 + 2  # e.g. in yr 1999, need 03/2000 thresholds ==> need tm=2 for off.thr
  OPM <- matrix(off.thr(tm)$ouThresh, nrow = 11, byrow = T)
  asec[, threshold := OPM[asec$nkid*11 + asec$nppl]]
  
  asec[, povstatus := as.numeric(fincome < threshold)]
  
  poverty[i] <- weighted.mean(asec$povstatus, asec$a_fnlwgt, na.rm = T) 
}

# save poverty measure
feather::write_feather(data.frame(poverty), 'calculated_poverty.f')
poverty <- as.vector(unlist(feather::read_feather('calculated_poverty.f')))

official.poverty <- c(11.9, 11.3, 11.7, 12.1, 12.5, 12.7, 12.6, 12.3, 12.5, 13.2, 14.3, 15.1, 15, 15, 14.5, 14.8, 13.5)

plot(1999:2015, poverty, ylab = 'poverty rate', xlab = 'year', 
     ylim = c(0.1, 0.16), type = 'o')
lines(1999:2015, official.poverty / 100, col = 'red')

rm(asec, OPM, rawOPM, attr.asec, files, i, index, rewrite, tm, yr)

