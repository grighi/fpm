#!/usr/bin/Rscript

library(readstata13)
library(data.table)
library(magrittr)
library(feather)

#setwd('~/Documents/fpm/inputs')

files <- c(paste0('../data-asec/dta/cpsmar', sprintf('%0.2i', 00:16), '.dta'))

mo <- 3

# to do: check all files in data-asec with "Stata ready CPS march supp blabla"
# migrate to using only those files

for (yr in 2000:2016) {
  message(paste(yr, 'Month', mo))
  index <- yr - 1999

  if (yr >= 2013) {
    asec <- read.dta13(paste0('../data-asec/', files[index]), convert.factors = F)
    asec <- data.table(asec)
    
    asec$h_idnum <- paste0(asec$h_idnum1, asec$h_idnum2)
    names(asec)[grep('hefaminc', names(asec))] <- 'h_faminc'
    
    asec <- asec[, .(h_idnum, a_lineno, ftype, ffpos, h_faminc, ftotval, fh_seq, ptotval, a_age, 
                     h_hhtype, perrp, wsal_val, semp_val, frse_val, a_fnlwgt)] 
    setnames(asec, 3:5, paste0('asec.', c('ftype', 'ffpos', 'h_faminc')))
    asec[, id := paste(h_idnum, a_lineno)]
    # asec[, h_idnum := NULL]
    # asec[, a_lineno := NULL]
    
    # modify ftotval to include ptype 3 into related subfamily
    asec[asec.ftype == 3, ftype2 := 1L]  # move related subfamilies into primary family
    asec[asec.ftype != 3, ftype2 := as.integer(asec.ftype)]
    asec[ftype2 == 1, fid := 1]
    asec[ftype2 != 1, fid := as.numeric(paste0(asec.ftype, asec.ffpos))]
    asec[, ftotval := sum(ptotval), by = .(fh_seq, fid)]
    
    asec <- asec[, .(h_idnum,  a_lineno, asec.h_faminc, h_hhtype, asec.ftype, asec.ffpos, a_age, 
                     perrp, wsal_val, semp_val, frse_val, a_fnlwgt, ftotval)]
    
    
    # calculate nppl to add to output -- this is modified from kerneling.R
    asec[, h_seq := .GRP, by = h_idnum]
    asec[asec.ftype == 3, ftype := 1L]  # move related subfamilies into primary family
    asec[asec.ftype != 3, ftype := as.integer(asec.ftype)]
    asec[ftype == 1, fid := 1]
    asec[ftype != 1, fid := as.numeric(paste0(ftype, asec.ffpos))]
    asec[is.na(fid), fid := -1]
    asec[ftype == 5, fid := fid + 1:.N, by = .(h_seq)]
    asec[, nkid := sum(a_age < 18), by = .(h_seq, fid)]
    asec[nkid > 8, nkid := 8]
    asec[, nppl := .N + 2, by = .(h_seq, fid)]
    asec[ftype %in% 1:3 & perrp %in% 1:2, hhage := a_age, by = h_seq]  # identify reference person
    asec[ftype %in% 1:3, hhage := as.integer(max(hhage, na.rm = T)), by = h_seq]   # give others that hhage
    asec[ftype > 3, hhage := as.integer(max(a_age)), by = .(h_seq, fid)]           # unrelated subfamilies get oldest in family
    asec[hhage <  65 & nppl == 3, nppl := 1]
    asec[hhage >= 65 & nppl == 3, nppl := 2]
    asec[hhage <  65 & nppl == 4, nppl := 3]
    asec[hhage >= 65 & nppl == 4, nppl := 4]
    asec[nppl > 11, nppl := 11]
    
  } else {
    asec <- read.dta13(paste0('../data-asec/', files[index]), convert.factors = F)
    asec <- data.table(asec)
    
    if (yr >= 2005) {
      asec$h_idnum <- paste0(asec$h_idnum1, asec$h_idnum2)
      names(asec)[grep('faminc', names(asec))] <- 'h_faminc'
    }
    asec <- asec[, .(h_idnum, a_lineno, ftype, ffpos, h_faminc, ftotval, fh_seq, ptotval, a_age, 
                     h_hhtype, perrp, wsal_val, semp_val, frse_val, a_fnlwgt)] 
    setnames(asec, 3:5, paste0('asec.', c('ftype', 'ffpos', 'h_faminc')))
    asec[, id := paste(h_idnum, a_lineno)]
    # asec[, h_idnum := NULL]
    # asec[, a_lineno := NULL]
    
    # this could be extended to check whether addition of benefits brings people to ptotval
    
    # modify ftotval to include ptype 3 into related subfamily
    asec[asec.ftype == 3, ftype2 := 1L]  # move related subfamilies into primary family
    asec[asec.ftype != 3, ftype2 := as.integer(asec.ftype)]
    asec[ftype2 == 1, fid := 1]
    asec[ftype2 != 1, fid := as.numeric(paste0(asec.ftype, asec.ffpos))]
    asec[, ftotval := sum(ptotval), by = .(fh_seq, fid)]
    
    asec <- asec[, .(h_idnum,  a_lineno, asec.h_faminc, h_hhtype, asec.ftype, asec.ffpos, a_age, 
                     perrp, wsal_val, semp_val, frse_val, a_fnlwgt, ftotval)]
    
    # calculate nppl to add to output -- this is modified from kerneling.R
    asec[, h_seq := .GRP, by = h_idnum]
    asec[asec.ftype == 3, ftype := 1L]  # move related subfamilies into primary family
    asec[asec.ftype != 3, ftype := as.integer(asec.ftype)]
    asec[ftype == 1, fid := 1]
    asec[ftype != 1, fid := as.numeric(paste0(ftype, asec.ffpos))]
    asec[is.na(fid), fid := -1]
    asec[ftype == 5, fid := fid + 1:.N, by = .(h_seq)]
    asec[, nkid := sum(a_age < 18), by = .(h_seq, fid)]
    asec[nkid > 8, nkid := 8]
    asec[, nppl := .N + 2, by = .(h_seq, fid)]
    asec[ftype %in% 1:3 & perrp %in% 1:2, hhage := a_age, by = h_seq]  # identify reference person
    asec[ftype %in% 1:3, hhage := as.integer(max(hhage, na.rm = T)), by = h_seq]   # give others that hhage
    asec[ftype > 3, hhage := as.integer(max(a_age)), by = .(h_seq, fid)]           # unrelated subfamilies get oldest in family
    asec[hhage <  65 & nppl == 3, nppl := 1]
    asec[hhage >= 65 & nppl == 3, nppl := 2]
    asec[hhage <  65 & nppl == 4, nppl := 3]
    asec[hhage >= 65 & nppl == 4, nppl := 4]
    asec[nppl > 11, nppl := 11]
  }
  
  # Koji does this but it appears less precise:
  # asec <- asec[perrp %in% 1:2]
  
  #cps[, id := paste(hrhhid, pulineno)]
  #asec[, id := paste(h_idnum, a_lineno)]
  #cps <- merge(cps, asec, by = "id")
  
  # save feather with hufaminc and ftotval for kernel drawing
  filename <- paste0('../data-intermediate/asec', yr, 'sample.f')
  #cps[hufaminc == -1, hufaminc := NA]
  feather::write_feather(asec[, .(asec.h_faminc, ftotval, asec.ftype, asec.h_faminc, nppl, nkid, wsal_val, semp_val, frse_val)], filename)
  
  rm(asec)
}


