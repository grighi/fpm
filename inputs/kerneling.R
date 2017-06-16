#!/usr/bin/Rscript
# This script resamples ASEC incomes to get income estimates in the monthly CPS. It 
# does this separately for primary families and unrelated subfamilies.

library(feather)
library(data.table)
library(magrittr)
library(doMC)
registerDoMC(5)

setwd('../inputs')
source('thresholds.R')
setwd('../data-intermediate/')

ind <- function(yr,mo) 12 * (yr - 1999) + mo  # handy index identifier
comb <- function(x, y) mapply(c, x, y, SIMPLIFY=FALSE)  # for multicore

st <- system.time({
years <- 1999:2015
monthly.poverty <- foreach(yr = rep(years,1), .combine = 'comb') %dopar% {
  # this code is setup to run in parallel to produce many replications across years very quickly.
  # to do this, it uses %dopar% ('doparallel') from the doMC ('do multicore') package. It is 
  # embarassingly parallel because it loops over our years, creating a vector of length 12
  # for each year. To perform replications, we simply feed in years multiple times. The final
  # resulting vector has length 12*(number of years)*(number of reps), and statistics are 
  # taken across the replications.
  
  cps.yr <- yr+1
  asec.yr <- yr+1
  message(paste(yr, 'from', cps.yr, 'data and', asec.yr, 'asec'))
  
  # get asec data
  asec.incomes <- data.frame(feather::read_feather(paste0('asec', asec.yr, 'sample.f')))
  names(asec.incomes) <- c('hufaminc', 'ftotval', 'famtyp', 'asec.h_faminc', 'nppl', 'nkid', 
                           'wsalval', 'sempval', 'farmval')
  asec.incomes <- data.table(asec.incomes)
  
  # create vector for this year 'yr'
  monthly.poverty.yr <- list(vector(length = 12), vector(length = 12))
  
  # fill up vector for year 'yr'
  for (mo in 1:12) {
    index <- 12*(yr %% 1999) + mo
    
    ## get relevant CPS file for this month's poverty estimate 
    # offset lag structure for years
    # yr2 <- 1999+((index+0)%/%12)
    # offset lag structure for months (use "%% 12" since may cross years)
    lagmo <- 0
    yr2 <- cps.yr
    mo2 <- (index + lagmo) %% 12
    if (mo2 == 0) mo2 <- 12
    
    # with lagging, need the following --- 
    # if (mo2 < mo) {
    #   mo2 <- mo2 + 1
    #   yr2 <- cps.yr + 1
    # }
    # 
    # if(yr == 1999 & mo < 6) {
    #   monthly.poverty.yr[[1]][mo] <- NA 
    #   monthly.poverty.yr[[2]][mo] <- NA
    #   next   # needed for different lag structures
    # }
    # -------------------------------------
    
    filename <- paste0('cps', substr(yr2,3,4), month.abb[mo2], '.rds')
    cps <- data.table(readRDS(filename))
    
    cps <- cps[hrhtype %in% 1:8, ]  # no group quarters
    
    # !! -- this is the bulk of this project -- !!
    # it is hard and necessary to have a good conversion between CPS and ASEC income categories
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
    
    # the following data cleaning steps use the data.table syntax
    cps[, h_seq := .GRP, by = hrhhid]  # repurpose variable h_seq into shorter ID
    cps[prfamtyp == 3, ftype := 1L]    # move related subfamilies into primary family
    cps[prfamtyp != 3, ftype := as.integer(prfamtyp)]
    cps[ftype == 1, fid := 1]          # create family ID
    cps[ftype != 1, fid := as.numeric(paste0(ftype, prfamnum))]
    cps[is.na(fid), fid := -1]
    cps[ftype == 5, fid := fid + 1:.N, by = .(h_seq)]
    
    # count types of people in family
    cps[, nkid := sum(peage < 18), by = .(h_seq, fid)]
    cps[nkid > 8, nkid := 8]
    
    cps[, nppl := .N + 2, by = .(h_seq, fid)]
    
    cps[ftype %in% 1:3 & perrp %in% 1:2, hhage := peage, by = h_seq]              # identify reference person
    cps[ftype %in% 1:3, hhage := as.integer(max(hhage, na.rm = T)), by = h_seq]   # give others that hhage
    cps[ftype > 3, hhage := as.integer(max(peage)), by = .(h_seq, fid)]           # unrelated subfamilies get oldest in family
    
    # adjust nppl accordingly
    cps[hhage <  65 & nppl == 3, nppl := 1]
    cps[hhage >= 65 & nppl == 3, nppl := 2]
    cps[hhage <  65 & nppl == 4, nppl := 3]
    cps[hhage >= 65 & nppl == 4, nppl := 4]
    
    cps[nppl > 11, nppl := 11]
    
    OPM <- matrix(off.thr(index - 12)$ouThresh, nrow = 11, byrow = T)  # turn threshold into matrix
    cps[, threshold := OPM[cps$nkid*11 + cps$nppl]]
    
    # classify family type
    cps[prfamtyp %in% 1:3, primaryFam := 1]
    cps[prfamtyp %in% 4:5, primaryFam := 0]
    asec.incomes$primaryFam <- plyr::mapvalues(asec.incomes$famtyp, from = 1:5, to = c(1,1,1,0,0))
    
    # restrict family sizes for income donation (safe since threshold already assigned)
    # this could be optimized. right now it only cuts off nppl and nikds. alternatively:
    # - after creating the group matrix, call diff()
    # - the first row with diff()>1 gives the maximum family sizes using the original
    #   grouping matrix
    asec.incomes[nppl > 4, nppl := 4]
    cps[nppl > 4, nppl := 4]
    asec.incomes[nkid > 2, nkid := 2]
    cps[nkid > 2, nkid := 2]
    
    # assign the same groups to asec.incomes and cps
    groups <- asec.incomes[, .(.GRP, .N), by = .(primaryFam, hufaminc, nppl, nkid)]
    cps <- merge(cps, groups, by = c('primaryFam', 'hufaminc', 'nppl', 'nkid'), all.x = T)
    groups <- merge(groups, cps[, .(Ncps = .N), by = GRP], by = 'GRP', all.x = T)
    groups[is.na(Ncps), Ncps := 0]
    asec.incomes[, N := .N, by = .(primaryFam, hufaminc, nppl, nkid)]
    asec.incomes[, GRP := .GRP, by = .(primaryFam, hufaminc, nppl, nkid)]
    
    # resample from asec.incomes to get means for CPS
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
    # now get means of every category
    means <- data.frame(split(means, sort(rep(1:4, nrow(cps)))))
    names(means) <- c('inc', 'wsal', 'semp', 'farm')
    cps$selfemp <- means$wsal + means$semp + means$farm      # alternative 1: add three self-employment sources
    cps$selfemp <- pmax(means$wsal, means$semp, means$farm)  # alternative 2: (koji's choice) take max
    cps$selfemp2 <- pmax(means$semp, means$farm)
    
    cps$fincome <- rnorm(nrow(cps), means$inc, sd = 500)
    cps$selfemp <- rnorm(cps$selfemp, sd = 500)
    
    rm(means, groups)  # clean up
    
    ## you may want to merge in ASEC and use actual 'ftotval' to get family income when 
    ## month is March but beware: CPS and ASEC do not use same sample of people so you 
    ## may get wildly different estimates unless you can maybe account for change in weights
    # if (mo == 3){
    #   cps[, povstatus := as.numeric(ftotval < threshold)] 
    #   } else {
    
    # I. basic: weekly earnings ~90% poverty 
    cps[, earnings := earn*50]  # annualize weekly earnings
    # cps[pemlr %in% 3:7 & is.na(earn), earn := 0]  # unemployed and missing earnings -> set to zero. this does nothing
    
    ## choose between IIa|IIb|IIc
    # IIa. add self employment if missing earnings
    # cps[is.na(earn) & !is.na(selfemp), earnings := as.double(selfemp)]
    
    # IIb. prefer self employment to earnings
    # cps[!is.na(selfemp), earnings := as.double(selfemp)]
    
    # IIc. add in only non-wage self-employment
    cps[!is.na(earn) & !is.na(selfemp), earnings := earn*50 + selfemp2]
    cps[ is.na(earn) & !is.na(selfemp), earnings := selfemp]
    
    # earnings by family
    cps[, earnings := sum(earnings, na.rm = T), by = .(h_seq, fid)]
    
    # ----> poverty with earnings should be ~32%, drop to ~27% with self-employment earnings
    
    cps[, povstatus := as.numeric(fincome < threshold)]
    cps[, earnpov := as.numeric(earnings < threshold)]
    
    monthly.poverty.yr[[1]][mo] <- weighted.mean(cps$povstatus, cps$weight.fn, na.rm = T) 
    monthly.poverty.yr[[2]][mo] <- weighted.mean(cps$earnpov, cps$weight.fn, na.rm = T) 
  }
  monthly.poverty.yr
  }
})
print(st)

# separate raw outputs
earnings.poverty <- monthly.poverty[[2]]
monthly.poverty  <- monthly.poverty[[1]]

# take means and standard deviations across simulation to get monthly poverty
grp                 <- seq_along(monthly.poverty) %% (length(years)*12)
grp[length(grp)]    <- length(years)*12
monthly.poverty.sd  <- sapply(split(monthly.poverty, grp), sd) %>% as.vector
monthly.poverty     <- sapply(split(monthly.poverty, grp), mean) %>% as.vector
earnings.poverty.sd <- sapply(split(earnings.poverty, grp), sd) %>% as.vector
earnings.poverty    <- sapply(split(earnings.poverty, grp), mean) %>% as.vector

# get official poverty
poverty          <- as.vector(unlist(feather::read_feather('../inputs/calculated_poverty.f')))
official.poverty <- c(11.9, 11.3, 11.7, 12.1, 12.5, 12.7, 12.6, 12.3, 12.5, 13.2, 14.3, 15.1, 15, 15, 14.5, 14.8, 13.5)

png('../output.png')
ylim <- c(0.1, 0.35)  # for earnings poverty
ylim <- c(0.1, 0.16)  # for simple FPM
plot(stepfun(2000:2015, c(poverty)), ylab = 'poverty rate', xlab = 'year', 
     ylim = ylim, xlim = c(1998, 2018), main = 'frequent poverty rate')
lines(stepfun(2000:2015, official.poverty / 100), col = 'red')

# draw gray boundary that is 2*(standard deviation) from mean of simulation
time  <- seq(1999, 2017, length.out = 217)[1:length(monthly.poverty)]
edges <- c(monthly.poverty + 2*monthly.poverty.sd, rev(monthly.poverty - 2*monthly.poverty.sd))
drop.end <- which(is.na(edges))
polygon(c(time, rev(time))[-drop.end], edges[-drop.end], col = 'lightgray', border = F)
lines(time, monthly.poverty, col = 'blue')
lines(time, earnings.poverty, col = 'green')

dev.off()

# save outputs
write_feather(data.frame(monthly.poverty), 'monthly.poverty.fthr')
write_feather(data.frame(monthly.poverty.sd), 'monthly.poverty.sd.fthr')

# # or, for fun:
# zoo::rollmean(monthly.poverty, 12) %>%
# lines(seq(1999, 2017, length.out = 217)[6:198], ., type = 'l', col = 'green')

