#!/usr/local/bin/Rscript
# script pulls the relevant information from the various CPS to create slimmer datasets
# it is not currently used

# TODO: make this based on 'filename' so that for debugging I can run this function based on filename and return later.
# e.g. I could have a clean() function that is looped through filenames
library(readstata13)
library(data.table)
library(magrittr)
library(feather)

## library(foreach)
# library(doParallel)
## library(parallel)
## cl <- makeCluster(4)
## registerDoParallel(cl)
## library(doMC)
# registerDoParallel(4)

# tmp <- list()
#foreach(yr = 1999, .errorhandling = 'pass') %do% {
for (yr in 1999:2017) {
  # on.exit(registerDoSEQ())
  
   for (mo in 1:12) {
    message(paste(yr, 'Month', mo))

    # extract relevant month
    cps <- paste0('../data/dta/cps', tolower(month.abb[mo]), substr(yr, 3,4),'.dta') %>% 
      read.dta13(convert.factors = F) %>% 
      data.table
    
    # if ('hrsersuf' %in% names(cps)) {
    #   cps[hrsersuf == '-1', hrsersuf := '']
    # } else {
    #   cps[, hrsersuf := substr(hrhhid2, 3, 4)]
    # }
    # cps[, hrhhid := paste0(hrhhid,hrsersuf)]  # add serial suffix for repeated hrhhid
    
    ## when calculate regression trees, want to drop unuseful variables
    # e.g. DROP:
    #   - name starts with an underscore
    #   - variable has only one value
    #   - more than 1/2 of variable are missing values
    # cps <- as.data.frame(cps)[, which(sapply(as.data.frame(cps), function(x) length(table(x))) > 1)] %>%
    #   # .[, -grep("^\\_", names(cps))] %>%
    #   # .[, which(sapply(., function(x) !is.character(x)))] %>%
    #   .[, which(sapply(., function(x) sum(is.na(x))) <= nrow(.)/2)] %>%
    #   data.table
    
    # rename weights variable
# these first two lines used to be necessary:
#    if (yr < 2003 & !(yr == 2000 & mo == 3))
#      names(cps)[grep('_nwsswgt', names(cps))] <- 'weight.fn' else
        names(cps)[grep('pwsswgt', names(cps))] <- 'weight.fn'
#    if (yr < 2003 & !(yr == 2000 & mo == 3))
#      names(cps)[grep('_nworwgt', names(cps))] <- 'weight.or' else
        names(cps)[grep('pworwgt', names(cps))] <- 'weight.or'
    cps[is.na(weight.fn), weight.fn := 0]
    cps[is.na(weight.or), weight.or := 0]
    # rename age variable
    if (yr == 2012 & mo >= 5)
      names(cps)[grep('prtage', names(cps))] <- 'peage'
    if (yr >= 2013)
      names(cps)[grep('prtage', names(cps))] <- 'peage'
    # rename income category 
    if (yr >= 2010)
      names(cps)[grep('hefaminc', names(cps))] <- 'hufaminc'
    # concatenate household ID when it is split
    if (yr >= 2005)
      cps$hrhhid <- paste0(cps$hrhhid, cps$hrhhid2)
    # rename earnings
    if (yr < 2003)
      names(cps)[grep('pternwa', names(cps))] <- 'earn'
    names(cps)[grep('prernwa', names(cps))] <- 'earn'
    # cps[is.na(peern), peern := 0]  # 'overtime earnings'
    # cps[is.na(puern2), puern2 := 0]  # 'second overtimes earnings'
    # cps[, earn := earn + peern + puern2]  # add in two measures of overtime
    # keep self-employment status
    cps[, se.status := (peio1cow %in% 6:7)]
    
    # define non-working status
    cps[, notwork := as.double(NA)]
    # workers
    cps[pemlr %in% c(1:2), notwork := 0]
    # unemployed
    cps[pemlr %in% 3:4, notwork := 1]
    # drop if below legal work age or disabled/retired/other NILF
    cps[peage < 14 | pemlr %in% 5:7, notwork := NA]
    # add back in if NILF for 'other' or missing cause
    cps[pemlr == 7 & (penlfact == 6 | penlfact == -1), notwork := 1]
    # add back in if want job, not disabled
    cps[prwntjob == 1 & penlfact != 1 & penlfact != 3 & pemlr != 6, notwork := 1]
    
    
    # select relevant variables
    cps <- cps[, .(hrhhid, hrmis, pulineno, hufaminc, hrhtype, prfamtyp, 
                   prfamnum, peage, perrp, pemlr, earn, weight.fn, weight.or, 
                   notwork, se.status)]
    
    # save file for year/month
    filename <- paste0('../data-intermediate/cps', substr(yr, 3,4), month.abb[mo], '.rds')
    saveRDS(cps, filename)
    
    ## alternatively we could save it as a feather
    # feathername <- paste0('../data-intermediate/cps', month.abb[mo], substr(yr, 3,4), '.f')
    # feather::write_feather(cps, feathername)
  }
  rm(cps)
  gc()
}

