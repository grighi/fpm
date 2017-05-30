#!/bin/Rscript
# a kernel density resampling function separately for family types (1) one to three and (2) four and five.
# also an implementation across months of the CPS, saving the relevant poverty outcomes

library(feather)

source('../opm.R')

setwd('../data-intermediate/')

library(data.table)
library(magrittr)
library(doMC)
registerDoMC(5)

# right now we are sample a new family income value for every person. It should not make much difference to sample a new income for each 
# *family* since family size was not very predictive of incomes in the random forest ... however it may make sense to sample
# at the family level and aggregate incomes after sampling
ind <- function(yr,mo) 12*(yr %% 1999) + mo

comb <- function(x, y) mapply(c, x, y, SIMPLIFY=FALSE)
st <- system.time({
years <- 1999:2015
monthly.poverty <- foreach(yr=rep(years,1), .combine = 'comb') %dopar% {
  cps.yr <- yr+1
  asec.yr <- yr+1
  message(paste(yr, 'from', cps.yr, 'data and', asec.yr, 'asec'))
  asec.incomes <- data.frame(feather::read_feather(paste0('asec', asec.yr, 'sample.f')))
  names(asec.incomes) <- c('hufaminc', 'ftotval', 'famtyp', 'asec.h_faminc', 'nppl', 'nkid', 
                           'wsalval', 'sempval', 'farmval')
  asec.incomes <- data.table(asec.incomes)
  
  monthly.poverty.yr <- list(vector(length = 12), vector(length = 12))
  
  for (mo in 1:12) {
    # if(yr == 1999 & mo < 6) next
    index <- 12*(yr %% 1999) + mo
    
    # yr2 <- 1999+((index+0)%/%12)
    mo2 <- (index+0)%%12
    if(mo2 < mo) mo2 = mo2+1
    filename <- paste0('cps', substr(cps.yr,3,4), month.abb[mo2], '.rds')
    cps <- data.table(readRDS(filename))
    
    cps <- cps[hrhtype %in% 1:8, ]
    
    if (cps.yr %in% 2000:2001) {
      cps[hufaminc %in% -2:-1, hufaminc := -1]
      cps[hufaminc > 0, hufaminc := hufaminc - 1L]
    } else if (cps.yr %in% 2002:2004) {
      cps[hufaminc %in% -3:-1, hufaminc := 1]
      cps[hufaminc > 0, hufaminc := hufaminc - 1L]
      cps$hufaminc <- plyr::mapvalues(cps$hufaminc, 14:15, c(13,13), warn_missing = F)
    } else if (cps.yr %in% 2005:2009) {
      # nada
    }
    
    # if (yr %in% 1999:2001) {
    #   cps[hufaminc %in% -2:-1, hufaminc := -1]
    #   cps[hufaminc > 0, hufaminc := hufaminc - 1L]
    # } else if (yr %in% 2002:2004) {
    #   cps[hufaminc %in% -3:-1, hufaminc := 1]
    #   cps[hufaminc > 0, hufaminc := hufaminc - 1L]
    #   cps$hufaminc <- plyr::mapvalues(cps$hufaminc, 14:15, c(13,13), warn_missing = F)
    # } else if (yr == 2009) {
    #   asec.incomes[hufaminc < 0, hufaminc := -1]
    #   # nada
    # }

    cps[, h_seq := .GRP, by = hrhhid]
    cps[prfamtyp == 3, ftype := 1L]  # move related subfamilies into primary family
    cps[prfamtyp != 3, ftype := as.integer(prfamtyp)]
    cps[ftype == 1, fid := 1]
    cps[ftype != 1, fid := as.numeric(paste0(ftype, prfamnum))]
    cps[is.na(fid), fid := -1]
    cps[ftype == 5, fid := fid + 1:.N, by = .(h_seq)]
    
    cps[, nkid := sum(peage < 18), by = .(h_seq, fid)]
    cps[nkid > 8, nkid := 8]
    
    cps[, nppl := .N + 2, by = .(h_seq, fid)]
    
    
    # a better method is to have second family table:
    # fh_seq - fid - relevant age
    cps[ftype %in% 1:3 & perrp %in% 1:2, hhage := peage, by = h_seq]  # identify reference person
    cps[ftype %in% 1:3, hhage := as.integer(max(hhage, na.rm = T)), by = h_seq]   # give others that hhage
    cps[ftype > 3, hhage := as.integer(max(peage)), by = .(h_seq, fid)]           # unrelated subfamilies get oldest in family
    
    cps[hhage <  65 & nppl == 3, nppl := 1]
    cps[hhage >= 65 & nppl == 3, nppl := 2]
    cps[hhage <  65 & nppl == 4, nppl := 3]
    cps[hhage >= 65 & nppl == 4, nppl := 4]
    
    cps[nppl > 11, nppl := 11]
    
    OPM <- matrix(opm(index-12)$ouThresh, nrow = 11, byrow = T)
    cps[, threshold := OPM[cps$nkid*11 + cps$nppl]]
    
    
    cps[prfamtyp %in% 1:3, primaryFam := 1]
    cps[prfamtyp %in% 4:5, primaryFam := 0]
    asec.incomes$primaryFam <- plyr::mapvalues(asec.incomes$famtyp, from = 1:5, to = c(1,1,1,0,0))
    
    # restrict family sizes
    # this could be optimized: after creating the group matrix, call diff()
    # and the first row with diff()>1 gives the maximum family sizes using the original
    # grouping matrix
    asec.incomes[nppl > 4, nppl := 4]
    cps[nppl > 4, nppl := 4]
    asec.incomes[nkid > 2, nkid := 2]
    cps[nkid > 2, nkid := 2]
    
    # identify groups with three matrices
    groups <- asec.incomes[, .(.GRP, .N), by = .(primaryFam, hufaminc, nppl, nkid)]
    cps <- merge(cps, groups, by = c('primaryFam', 'hufaminc', 'nppl', 'nkid'), all.x = T)
    groups <- merge(groups, cps[, .(Ncps = .N), by = GRP], by = 'GRP', all.x = T)
    groups[is.na(Ncps), Ncps := 0]
    asec.incomes[, N := .N, by = .(primaryFam, hufaminc, nppl, nkid)]
    asec.incomes[, GRP := .GRP, by = .(primaryFam, hufaminc, nppl, nkid)]
    
    cps <- cps[!is.na(GRP)]
    setkey(cps, GRP)
    setkey(asec.incomes, GRP)
    means <- mapply(
              function(x, m) {
                # set.seed(32894+1)  # would need to change for-loop from being year-centered
                x[sample(nrow(x), m, replace = T), .(ftotval, wsalval, sempval, farmval)]
                },
              x = split(asec.incomes, asec.incomes$GRP), 
              m = groups$Ncps) %>% 
      t %>% 
      unlist
    means <- data.frame(split(means, sort(rep(1:4, nrow(cps)))))
    names(means) <- c('inc', 'wsal', 'semp', 'farm')
    cps$fincome <- rnorm(nrow(cps), means$inc, sd = 500)
    cps$selfemp <- means$wsal + means$semp + means$farm
    cps$selfemp <- pmax(means$wsal, means$semp, means$farm)
    cps$selfemp2 <- pmax(means$semp, means$farm)
    rm(means, groups)
    
    # for(f in unique(cps$primaryFam)) {
    #   for(i in unique(cps$hufaminc)) {
    #     for(np in unique(cps$nppl)) {
    #     N <- cps[primaryFam %in% f &
    #                hufaminc == i & 
    #                nppl == np, .N]
    #     
    #     tmp <- asec.incomes$ftotval[which(asec.incomes$primaryFam %in% f &
    #                                         asec.incomes$hufaminc == i & 
    #                                         asec.incomes$nppl == np)]
    #     if (length(tmp) == 0) next
    #     
    #     set.seed(32894)
    #     means <- sample(tmp, N, replace = T)
    #     cps <- cps[primaryFam %in% f & hufaminc == i & nppl == np, fincome :=  rnorm(N, means, sd = 500)]
    #   }}}
    
    # if (mo == 3){
    #   cps[, povstatus := as.numeric(ftotval < threshold)] 
    #   } else {
    
    # I. basic: weekly earnings ~90% poverty 
    cps[, earnings := earn*50]  # annualize weekly earnings
    # cps[pemlr %in% 3:7 & is.na(earn), earn := 0]  # unemployed and missing earnings -> set to zero. this does nothing
    
    # IIa. add self employment if missing earnings
    # cps[is.na(earn) & !is.na(selfemp), earnings := as.double(selfemp)]
    
    # IIb. prefer self employment to earnings (comment out II)
    # cps[!is.na(selfemp), earnings := as.double(selfemp)]
    
    # IIc. add in only non-wage self-employment
    cps[!is.na(earn) & !is.na(selfemp), earnings := earn*50 + selfemp2]
    cps[ is.na(earn) & !is.na(selfemp), earnings := selfemp]
    
    # earnings by family
    cps[, earnings := sum(earnings, na.rm = T), by = .(h_seq, fid)]
    
    # ----> adding  self-employment earnings should bring from ~32% to ~27%
    
    cps[, povstatus := as.numeric(fincome < threshold)]
    cps[, earnpov := as.numeric(earnings < threshold)]
    
    # }
    
    monthly.poverty.yr[[1]][mo] <- weighted.mean(cps$povstatus, cps$weight.fn, na.rm = T) 
    monthly.poverty.yr[[2]][mo] <- weighted.mean(cps$earnpov, cps$weight.fn, na.rm = T) 
    
  }
  monthly.poverty.yr
  }
})
print(st)

earnings.poverty <- monthly.poverty[[2]]
monthly.poverty <- monthly.poverty[[1]]

grp <- seq_along(monthly.poverty) %% (length(years)*12)
grp[length(grp)] <- length(years)*12
monthly.poverty.sd <- sapply(split(monthly.poverty, grp), sd) %>% as.vector
monthly.poverty <- sapply(split(monthly.poverty, grp), mean) %>% as.vector

poverty <- as.vector(unlist(feather::read_feather('../inputs/calculated_poverty.f')))
poverty <- c(poverty, NA, NA)
official.poverty <- c(11.9, 11.3, 11.7, 12.1, 12.5, 12.7, 12.6, 12.3, 12.5, 13.2, 14.3, 15.1, 15, 15, 14.5, 14.8, 13.5)

plot(1999:2017, poverty, ylab = 'poverty rate', xlab = 'year', 
     ylim = c(0.1, 0.4), type = 'o')
lines(1999:2015, official.poverty / 100, col = 'red')


# monthly.poverty2 = monthly.poverty
# monthly.poverty = monthly.poverty2
# monthly.poverty <- monthly.poverty - rep(c(.013, 0, .013), c(12,36,84))
time <- seq(1999, 2017, length.out = 217)[1:length(monthly.poverty)]
edges <- c(monthly.poverty+monthly.poverty.sd, rev(monthly.poverty-monthly.poverty.sd))
drop.end <- which(is.na(edges))
polygon(c(time, rev(time))[-drop.end], edges[-drop.end], col = 'lightgray', border = F)
lines(time, monthly.poverty, col = 'magenta')
lines(time, earnings.poverty, col = 'green')

write_feather(data.frame(monthly.poverty), 'monthly.poverty.fthr')
write_feather(data.frame(monthly.poverty.sd), 'monthly.poverty.sd.fthr')

# # or, for fun:
# zoo::rollmean(monthly.poverty, 12) %>% 
# lines(seq(1999, 2009, length.out = 120)[1:181], ., type = 'l', col = 'green')

# 
# # we are off. Why? This uses ASEC from povline.R and cps from here:
# hist(cps[prfamtyp %in% 1:3, fincome], xlim = c(0,300000), breaks = 1000, freq = F, ylim = c(0, 1.5e-5))
# hist(cps01[prfamtyp %in% 1:3, ftotval], xlim = c(0,300000), breaks = 1000, freq = F, ylim = c(0, 1.5e-5))
# hist(asec[ftype %in% 1:3, ftotval], xlim = c(0,300000), breaks = 1000, freq = F, ylim = c(0, 1.5e-5))
# 
# hist(cps[prfamtyp %in% 4:5, fincome], xlim = c(0,300000), breaks = 1000, freq = F, ylim = c(0, 5e-5))
# hist(asec[ftype %in% 4:5, ftotval], xlim = c(0,300000), breaks = 1000, freq = F, ylim = c(0, 5e-5))
# 
# cps[, mean(fincome < threshold, na.rm = T)]
# asec[, mean(fincome < threshold, na.rm = T)]
# 
# # hist(cps[prfamtyp %in% 1:3, sqrt(fincome)], freq = F, breaks = 100, ylim = c(0, 0.0045))
# # hist(asec[ftype %in% 1:3, sqrt(ftotval)], freq = F, breaks = 100, ylim = c(0, 0.0045))
# 
# kernel <- KernSmooth::bkde(asec01[asec.ftype %in% 1:3, ftotval], bandwidth = 5000)
# kernel2 <- KernSmooth::bkde(cps01[prfamtyp %in% 1:3, ftotval], bandwidth = 5000)
# kernel3 <- KernSmooth::bkde(cps[prfamtyp %in% 1:3, fincome], bandwidth = 5000)
# lines(kernel$x, kernel$y, col = 'red')
# lines(kernel2$x, kernel2$y, col = 'green')
# lines(kernel3$x, kernel3$y, col = 'yellow')
# 
# # I'm oversampling high earners with the CPS sample as compared to the ASEC sample --- I should check why this is.
# # Is it because I'm dropping people from the ASEC dataset when doing the merge to create asec2000mar.f? Is it because I drop people when doing the final
# # CPS merge?
# # Is it worth trying to match up the distribution among the income categories?
# 
# 
# # asec <- read.dta13(files[1], convert.factors = F)
# # asec = data.table(asec)
# # asec <- asec[, .(h_faminc, ftotval, ftype, ffpos, h_idnum, a_lineno)]
# # 
# # cps <- read.dta13('../data/cps_monthly_00.dta', convert.factors = F)
# # cps <- data.table(cps)
# # cps <- cps[hrmonth == 3]
# # cps <- cps[, .(hufaminc, prfamtyp, prfamnum, hrhhid, pulineno)]
# # 
# # cps[hufaminc == -1, hufaminc := NA]
# # cps[hufaminc < 0, hufaminc := -1]
# # cps[hufaminc > 0, hufaminc := hufaminc-1]
# # 
# # hist(asec$h_faminc, freq = F)
# # hist(cps$hufaminc, freq = F)
# 
# 
# # CHECK THIS OUT. choose a year. get asec from povline.R. choose mo = 3. get cps with h_faminc from kerneling.R
# # cps.true is actually the result from merging in the 2000ASEC -- it should actually reflect 1999 poverty
# cbind(rbind(0,0,0,ddply(cps[prfamtyp %in% 1:3], .(hufaminc), summarize, cps2000 = mean(povstatus, na.rm = T))),
#       #cps.true = ddply(cps, .(asec.h_faminc), summarize, cps2000 = mean(tru.povstatus, na.rm = T))[,2],
#       asec01 = ddply(asec[ftype %in% 1:3], .(hufaminc), summarize, mean(povstatus, na.rm = T))[,2])
# # note: the CPS and ASEC povstatus should not actually match. The CPS povstatus tells us current poverty, 
# # while the ASEC povstatus should tell us poverty from one year ago.
# # HOWEVER: to check whether the CPS sample is well-done, we should also calculate the poverty status from the 
# # March CPS edition of the ASEC.
# # --- split this up by ftype?
# mean(cps$povstatus, na.rm = T)
# mean(cps$tru.povstatus, na.rm = T)
# mean(asec$povstatus, na.rm = T)
# # so overestimating the poverty rate...
# hist(asec[h_faminc == 2, ftotval], breaks = 100, xlim = c(0,2e5), freq = F)
# hist(cps[asec.h_faminc == 2, ftotval], breaks = 100, xlim = c(0,2e5), freq = F)
# 
# hist(cps[hufaminc == 3, ftotval], breaks = 100, xlim = c(0,2e5), freq = F, ylim = c(0,1e-4))
# hist(cps[asec.h_faminc == 2, fincome], breaks = 200, xlim = c(0,2e5), freq = F, ylim = c(0,1e-4))
# # but how ... ??
