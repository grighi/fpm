#!/usr/local/bin/Rscript
# This pulls the relevant information from the various CPS to create slimmer datasets

library(readstata13)
library(data.table)
library(magrittr)
library(feather)
library(doMC)
registerDoMC(3)


# variables that need to be rewritten because we will use them
# question: how well do the following variables match across march basic CPS / asec?
# - hufaminc - prfamtyp/ftype - prfamnum/ffpos

# ASEC:
# ftotval
# h_idnum
# a _lineno
# ftype
# ffpos


# CPS:
# month
# prfamtyp
# peage
# hrhhid
# prfamnum
# pulineno
# -- but others are required since running RF

# all the other variables should be added but don't need to be identified

files <- c(paste('CPS Stata Ready Data', 1999:2012, 'March Supp.dta'), 
           paste0('cpsmar', 13:16, '.dta'))

foreach(yr = 2000:2016) %dopar% {
  # extract data froms stata file, save to feather to save memory
  # (not sure how memory is handled here -- does R spawn an environment with `%>%`?)
  paste0('../data/dta/cps_monthly_', substr(yr, 3,4),'.dta') %>%
    read.dta13(convert.factors = F) %>%
    write_feather('cpsyearly.f')
  
  for (mo in 1:12) {
    message(paste(yr, 'Month', mo))
    index <- yr - 1999 + 1  # index for output vector
    
    # extract relevant month
    # (not sure how memory is handled here -- does R drop the rest well?)
    cps <- data.table(read_feather('cpsyearly.f'))[hrmonth == mo, ]


    ## when calculate regression trees, want to drop unuseful variables
    # DROP:
    #   - name starts with an underscore
    #   - variable has only one value
    #   - more than 1/2 of variable are missing values

    # cps <- as.data.frame(cps)[, which(sapply(as.data.frame(cps), function(x) length(table(x))) > 1)] %>%
    #   # .[, -grep("^\\_", names(cps))] %>%
    #   # .[, which(sapply(., function(x) !is.character(x)))] %>%
    #   .[, which(sapply(., function(x) sum(is.na(x))) <= nrow(.)/2)] %>%
    #   data.table
    
    # rename weights
    if (yr < 2003)
      names(cps)[grep('_nwsswgt', names(cps))] <- 'weight.fn' else
        names(cps)[grep('pwsswgt', names(cps))] <- 'weight.fn'
    cps[is.na(weight.fn), weight.fn := 0]

    # rename age variable
    if (yr >= 2012 & mo >= 5)
      names(cps)[grep('prtage', names(cps))] <- 'peage'
#       cps[, peage := prtage]
#     if (yr >= 2013)
# 	    names(cps)[grep('prtage', names(cps))] <- 'peage'
    # rename income category 
    if (yr >= 2010)
      names(cps)[grep('hefaminc', names(cps))] <- 'hufaminc'
    # concatenate household ID when it is split
    if (yr >= 2005)
      cps$hrhhid <- paste0(cps$hrhhid, cps$hrhhid2)
    # rename earnings
    names(cps)[grep('prernwa', names(cps))] <- 'earn'
    cps[is.na(peern), peern := 0]  # 'overtime earnings'
    cps[is.na(puern2), puern2 := 0]  # 'second overtimes earnings'
    cps[, earn := earn + peern + puern2]  # add in two measures of overtime
    
    # select relevant variables
    cps <- cps[, .(hrhhid, hrmis, pulineno, hufaminc, hrhtype, prfamtyp, 
                   prfamnum, peage, perrp, pemlr, earn, weight.fn)]
    
    # save file for year/month
    filename <- paste0('../data-intermediate/cps', substr(yr, 3,4), month.abb[mo], '.rds')
    saveRDS(cps, filename)
    
    ## alternatively we could save it as a feather
    # feathername <- paste0('../data-intermediate/cps', month.abb[mo], substr(yr, 3,4), '.f')
    # feather::write_feather(cps, feathername)
    
  }
  unlink('cpsyearly.f')  # deletes file
  rm(cps)
  gc()
}





