
# This script calculates the poverty status of families from the ASEC


library(data.table)
library(readstata13)
library(randomForest)
library(magrittr)
# library(doMC)

source('../opm.R')

files <- c(#paste('CPS Stata Ready Data', 1999:2012, 'March Supp.dta'), 
           paste0('cpsmar', substr(1999:2016,3,4), '.dta'))
files <- paste0('../data/cpsmar', sprintf(0:16, fmt = '%0.2i'), '.dta')


poverty <- vector(length = 16)
for (yr in 1999:2015) {
  # tryCatch({
  message(yr)
  
  # asec gives OPM of previous year
  i <- yr - 1999 + 1
    
  index <- yr - 1999 + 1
  asec <- read.dta13(files[index],
                     convert.factors = F)
  saveRDS(asec, paste0('asec', index))
  #asec <- readRDS(paste0('asec', index))

  index <- (yr - 1999) * 12 + 2 - 11

  attr.asec <- attributes(asec)
  names(attr.asec$var.labels) <- names(asec)
  asec <- data.table(asec)
  
  # h_idnum OR h_seq?
  # a <- asec[, unique(h_idnum), by = .(h_seq)]
  # some h_idnums appear in different households
  # there are 17 h_idnums which appear in two different h_seq
  # interestingly there are 17 more h_seq than h_idnums
  # note h_seq = fh_seq
  
  asec[ftype == 3, ftype2 := 1L]  # move related subfamilies into primary family
  asec[ftype != 3, ftype2 := as.integer(ftype)]
  
  asec[ftype2 == 1, fid := 1]
  asec[ftype2 != 1, fid := as.numeric(paste0(ftype, ffpos))]
  
  asec[, fincome := sum(ptotval), by = .(fh_seq, fid)]
  
  asec[, nkid := sum(a_age < 18), by = .(fh_seq, fid)]
  asec[nkid > 8, nkid := 8]
  
  asec[, nppl := .N + 2, by = .(fh_seq, fid)]
  
  
  # a better method is to have second family table:
  # fh_seq - fid - relevant age
  asec[ftype %in% 1:3 & perrp %in% 1:2, hhage := a_age, by = fh_seq]  # identify reference person
  asec[ftype %in% 1:3, hhage := as.integer(max(hhage, na.rm = T)), by = fh_seq]   # give others that hhage
  asec[ftype > 3, hhage := as.integer(max(a_age)), by = .(fh_seq, fid)]           # unrelated subfamilies get oldest in family
  
  asec[hhage <  65 & nppl == 3, nppl := 1]
  asec[hhage >= 65 & nppl == 3, nppl := 2]
  asec[hhage <  65 & nppl == 4, nppl := 3]
  asec[hhage >= 65 & nppl == 4, nppl := 4]
  
  OPM <- matrix(opm(index+12)$ouThresh, nrow = 11, byrow = T)
  asec[, threshold := OPM[asec$nkid*11 + asec$nppl]]
  
  # nkid BY nppl
  # opm1 <- matrix(c(8959,8259,11531,10409,13470,17761,21419,24636,28347,31704,38138,
  #                  NA,NA,11869,11824, 13861,18052,21731,24734,28524,31984,38322,
  #                  NA,NA,NA,NA,13874,17463,21065,24224,27914,31408,37813,
  #                  NA,NA,NA,NA,NA,17524,20550,23736,27489,30904,37385,
  #                  NA,NA,NA,NA,NA,NA,20236,23009,26696,30188,36682,
  #                  NA,NA,NA,NA,NA,NA,NA,22579,25772,29279,35716,
  #                  NA,NA,NA,NA,NA,NA,NA,NA,24758,28334,34841,
  #                  NA,NA,NA,NA,NA,NA,NA,NA,NA,28093,34625,
  #                  NA,NA,NA,NA,NA,NA,NA,NA,NA,26753,33291), nrow = 11)
  
  
  asec[, povstatus := as.numeric(fincome < threshold)]
  
  poverty[i] <- weighted.mean(asec$povstatus, asec$a_fnlwgt, na.rm = T) 
  
  # }, error = function(e) {
  #   print(e)
  # }, finally = {
  #   next
  # })
}

feather::write_feather(data.frame(poverty), 'calculated_poverty.f')

poverty <- as.vector(unlist(feather::read_feather('calculated_poverty.f')))

official.poverty <- c(11.9, 11.3, 11.7, 12.1, 12.5, 12.7, 12.6, 12.3, 12.5, 13.2, 14.3, 15.1, 15, 15, 14.5, 14.8, 13.5)

plot(1999:2015, poverty, ylab = 'poverty rate', xlab = 'year', 
     ylim = c(0.1, 0.16), type = 'o')
lines(1999:2015, official.poverty / 100, col = 'red')

# # --------- some old relevant snippets
# ftypes <- split(asec$ftype, asec$fh_seq)
# ftypes <- lapply(ftypes, unique)
# 
# table(sapply(ftypes, function(x) if(`%in%`(2, x)) paste(x, collapse = '') else 0))
# 
# 
# 
# setkey(cps, idhh, idou, xfamily)
# 
# cps[a_famtyp != 3, x_oupovInc := sum(fincome), by = .(idhh, idou, xfamily)]
# 
# if (sum(is.na(cps$oPovLine)) > 0) stop('I did not code the many-to-many merge because it seemed unnecessary, but there are multiple HH without ouThresh!')
# 
# cps[!is.na(x_oupovInc) & !is.na(oPovLine), marchOPM := 0]
# cps[x_oupovInc < oPovLine, marchOPM := 1]
# 
# 
# cps[, idou := 1000]
# # Primary family, primary singles, related individuals
# cps[a_famtyp %in% 1:3, idou := 1]
# # Unrelated subfamilies
# cps[a_famtyp == 4, idou := 101]
# # Unrelated people
# cps[a_famtyp == 5, idou := 201]
# 
# # sort by household sequence number, poverty unit, then family ID
# setorder(cps, h_seq, idou, ffpos)
# 
# # give unrelated subfamilies within household different poverty units {102,103...}
# cps[idou == 101, idou := idou + (ffpos - 2), by=.(h_seq,ffpos)]
# 
# # give unrelated people different poverty units
# # note that no unrelated people are in the same family:
# # cps[idou == 201, if (.N > 1) .(h_seq, idou, ffpos, fincome), by = .(h_seq, ffpos)]
# cps[idou == 201, idou := idou + (ffpos - min(ffpos)), by = .(h_seq)]
# 
# # count people in poverty unit
# cps[, ctAll := .N, by = .(h_seq, idou)]
# # count kids (under age 15) in poverty unit
# cps[, ctChild := sum(age < 15), by = .(h_seq, idou)]
# # drop loose kids
# cps[ctAll == ctChild, idou := NA]
# 
# # ****** MERGE with OPM thresholds ********
# # *****************************************
# # create max age variable
# cps[idou==1 & perrp %in% 1:2, hhage := age, by = h_seq]
# cps[idou==1, hhage := max(hhage, na.rm = T), by = h_seq]
# cps[idou>1, hhage := max(age), by = h_seq]
# 
# cps[ctChild > 8, ctChild := 8]
# cps[, idouChildTotal := ctChild]
# cps[, idouTotal := ctAll + 2]
# cps[idouTotal > 8, idouTotal := 11]
# cps[ctAll == 1 & hhage < 65, idouTotal := 1]
# cps[ctAll == 1 & hhage >=65, idouTotal := 2]
# cps[ctAll == 2 & hhage < 65, idouTotal := 3]
# cps[ctAll == 2 & hhage < 65, idouTotal := 4]
# 
# 
# # create Family Number (FN):
# # This is a modification of ffpos to consider acquainted single people (unmarried
# # partners, housemates, roommates) that are listed as part of the primary family (ffpos == 1)
# cps[ffpos == 1, xfamily := 0]
# cps[ffpos  > 1, xfamily := as.double(ffpos)]
# cps[ffpos == 1 & perrp >=10 & perrp <=18, xfamily := xfamily + 10]
# 
# # Adding cohabiting family
# # count number of unmarried partners in household
# cps[, hhpart := sum(perrp ==13 | perrp ==14), by = h_seq]
# # count number of unmarried partners by family number
# cps[,  fpart := sum(perrp ==13 | perrp ==14), by = .(h_seq, xfamily)]
# cps[,  xpart := 0]
# # if one or more unmarried partners are in the primary family
# cps[hhpart >= 1 & xfamily == 0,  xpart := 1]
# # if there is one or more unmarried partners in other families
# cps[ fpart >= 1 & xfamily  > 0,  xpart := 1]
# cps[, hhpart := NULL]
# cps[, fpart  := NULL]
# 



# Here is the same estimated official poverty if I merge the asec data into the cps for each month
poverty <- vector(length = 16)
for (yr in 2000:2016) {
  i <- yr - 1999
  
  index <- yr - 1999
  asec <- readRDS(paste0('../data-intermediate/cps',substr(yr,3,4),'Mar.rds'))

  index <- (yr - 1999) * 12 + 2 - 11
  
  attr.asec <- attributes(asec)
  # names(attr.asec$var.labels) <- names(asec)
  asec <- data.table(asec)
  
  # h_idnum OR h_seq?
  # a <- asec[, unique(h_idnum), by = .(h_seq)]
  # some h_idnums appear in different households
  # there are 17 h_idnums which appear in two different h_seq
  # interestingly there are 17 more h_seq than h_idnums
  # note h_seq = fh_seq
  
  asec[prfamtyp == 3, ftype2 := 1L]  # move related subfamilies into primary family
  asec[prfamtyp != 3, ftype2 := as.integer(prfamtyp)]
  
  asec[ftype2 == 1, fid := 1]
  asec[ftype2 != 1, fid := as.numeric(paste0(prfamtyp, prfamnum))]
  
  asec[, fincome := sum(ptotval), by = .(fh_seq, fid)]
  
  asec[, nkid := sum(peage < 18), by = .(fh_seq, fid)]
  asec[nkid > 8, nkid := 8]
  
  asec[, nppl := .N + 2, by = .(fh_seq, fid)]
  
  
  # a better method is to have second family table:
  # fh_seq - fid - relevant age
  asec[prfamtyp %in% 1:3 & perrp %in% 1:2, hhage := peage, by = fh_seq]  # identify reference person
  asec[prfamtyp %in% 1:3, hhage := as.integer(max(hhage, na.rm = T)), by = fh_seq]   # give others that hhage
  asec[prfamtyp > 3, hhage := as.integer(max(peage)), by = .(fh_seq, fid)]           # unrelated subfamilies get oldest in family
  
  asec[hhage <  65 & nppl == 3, nppl := 1]
  asec[hhage >= 65 & nppl == 3, nppl := 2]
  asec[hhage <  65 & nppl == 4, nppl := 3]
  asec[hhage >= 65 & nppl == 4, nppl := 4]
  
  OPM <- matrix(opm(index)$ouThresh, nrow = 11, byrow = T)
  asec[, threshold := OPM[asec$nkid*11 + asec$nppl]]
  
  asec[, povstatus := as.numeric(fincome < threshold)]
  
  poverty[i] <- weighted.mean(asec$povstatus, asec$weight.fn, na.rm = T) 
}

lines(1999:2008, poverty[1:10], col = 'green')



