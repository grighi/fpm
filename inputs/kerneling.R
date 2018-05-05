#!/usr/local/bin/Rscript
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
  years <- 1999:2016
  monthly.poverty <- foreach(yr = rep(years,100), .combine = 'comb') %dopar% {
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
                             'wsalval', 'sempval', 'farmval', 'clswkr')
    asec.incomes <- data.table(asec.incomes)
    
    # create vector for this year 'yr'
    monthly.poverty.yr <- list(vector(length = 12), vector(length = 12), vector(length = 12))
    
    mos <- 1:12
    if(year(Sys.time()) - 1 == yr) {
      list.files(pattern = paste0('cps', substr(yr+1,3,4), '.*')) %>% 
        substr(6,8) %>% 
        match(month.abb) %>%  
        max %>% seq -> mos
    }
    # fill up vector for year 'yr'
    for (mo in mos) {
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
      # note that subsequent cleaning steps use data.table syntax

      cps <- cps[hrhtype %in% 1:8, ]  # no group quarters      

      # !! -- this is the bulk of this project -- !!
      # edit CPS income categories to conform with ASEC categories
      if (cps.yr %in% 2000:2001) {
        # cps[hufaminc %in% -3:-1, hufaminc := -1]
        cps[hufaminc > 0, hufaminc := hufaminc - 1L]
      } else if (cps.yr %in% 2002:2004) {
        cps[hufaminc %in% -3:-1, hufaminc := 1]
        cps[hufaminc > 0, hufaminc := hufaminc - 1L]
        cps$hufaminc <- plyr::mapvalues(cps$hufaminc, 14:15, c(13,13), warn_missing = F)
      } else if (cps.yr %in% 2005:2016) {
        # nada
      }
      
      # create household and family identifiers that will identify a poverty unit
      cps[, h_seq := .GRP, by = hrhhid]  # repurpose variable h_seq into shorter ID
      cps[prfamtyp == 3, ftype := 1L]    # move related subfamilies into primary family
      cps[prfamtyp != 3, ftype := as.integer(prfamtyp)]
      cps[ftype == 1, fid := 1]          # create family ID
      cps[ftype != 1, fid := as.numeric(paste0(ftype, prfamnum))]
      cps[is.na(fid), fid := -1]
      cps[ftype == 5, fid := fid + 1:.N, by = .(h_seq)]
      
      # count adults and kids to identify relevant poverty threshold
      cps[, nkid := sum(peage < 18), by = .(h_seq, fid)]
      cps[nkid > 8, nkid := 8]
      
      cps[, nppl := .N + 2, by = .(h_seq, fid)]
      
      cps[ftype %in% 1:3 & perrp %in% 1:2, hhage := peage, by = h_seq]              # identify reference person
      cps[ftype %in% 1:3, hhage := as.integer(max(hhage, na.rm = T)), by = h_seq]   # give others that hhage
      cps[ftype > 3, hhage := as.integer(max(peage)), by = .(h_seq, fid)]           # unrelated subfamilies get oldest in family
      
      # adjust nppl to match thresholds
      cps[hhage <  65 & nppl == 3, nppl := 1]
      cps[hhage >= 65 & nppl == 3, nppl := 2]
      cps[hhage <  65 & nppl == 4, nppl := 3]
      cps[hhage >= 65 & nppl == 4, nppl := 4]
      
      cps[nppl > 11, nppl := 11]
      
      # merge on poverty thresholds
      OPM <- matrix(off.thr(index - 12)$ouThresh, nrow = 11, byrow = T)  # turn threshold into matrix
      cps[, threshold := OPM[cps$nkid*11 + cps$nppl]]
      
      # classify family type
      cps[prfamtyp %in% 1:3, primaryFam := 1]
      cps[prfamtyp %in% 4:5, primaryFam := 0]
      asec.incomes$primaryFam <- plyr::mapvalues(asec.incomes$famtyp, from = 1:5, to = c(1,1,1,0,0))
      
      # since there are small samples of large families in the ASEC for highest poverty categories
      # we cut off the max family sizes for the income resampling
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
      
      asec.incomes[!(clswkr %in% 5:6), c('wsalval', 'sempval', 'farmval') := NA]
      
      # resample from asec.incomes to get means for CPS
      # cps <- cps[!is.na(GRP)]
      setkey(cps, GRP)
      setkey(asec.incomes, GRP)
      means <- mapply(
        function(x, m) {
          # set.seed(32894+1)  # would need to change for-loop from being year-centered
          x[sample(nrow(x), m, replace = T), .(ftotval)]
        },
        x = split(asec.incomes, asec.incomes$GRP), 
        m = groups$Ncps) %>% 
        t %>% 
        unlist
      # now get means of every category
      cps[!is.na(GRP), fincome := rnorm(means, means, sd = 500)]
      
      # -----------------------------------------------> VERIFY THAT THIS IS WHAT KOJI DID, BUT IN GENERAL, WE WANT
      # -----------------------------------------------  TO DRAW A SECOND SET OF SELF-EMPLOYMENT VALUES AND GIVE THESE
      # --------------------------------------------- ONLY TO THE SELF EMPLOYED PEOPLE. THEN USE SE + EARN TO CALCULATE EARNINGS POVERTY
      # now sample the self-employment earnings
      # recalculate groups
      # procedure: define groups and counts in ASEC; merge onto the CPS; get the needed number for each
      # group in the CPS; bring this back onto groups
      # assign the same groups to asec.incomes and cps
      asec.incomes[!(clswkr %in% 5:6), c('wsalval', 'sempval', 'farmval') := NA]
      # cps[hufaminc == -3, hufaminc := -1]
      cps[, c('GRP', 'N') := NULL]
      groups <- asec.incomes[clswkr %in% 5:6, .(.GRP, .N), by = .(primaryFam, hufaminc, nppl, nkid)]
      cps <- merge(cps, groups, by = c('primaryFam', 'hufaminc', 'nppl', 'nkid'), all.x = T)
      groups <- merge(groups, cps[se.status == T, .(Ncps = .N), by = GRP], by = 'GRP', all.x = T)
      groups[is.na(Ncps), Ncps := 0]
      count <- sum(groups$Ncps)  # count how many are in groups found in both CPS and ASEC
      asec.incomes[, N := .N, by = .(primaryFam, hufaminc, nppl, nkid)]
      asec.incomes[, GRP := .GRP, by = .(primaryFam, hufaminc, nppl, nkid)]
      means <- mapply(
        function(x, m) {
          # set.seed(32894+1)  # would need to change for-loop from being year-centered
          x[sample(nrow(x), m, replace = T), .(wsalval, sempval, farmval)]
        },
        x = split(asec.incomes[clswkr %in% 5:6], asec.incomes[clswkr %in% 5:6]$GRP), 
        m = groups$Ncps) %>% 
        t %>% 
        unlist
      means <- data.frame(split(means, sort(rep(1:3, count))))
      names(means) <- c('wsal', 'semp', 'farm')
      cps[, selfemp := as.double(NA)]
      # cps$selfemp <- means$wsal + means$semp + means$farm      # alternative 1: add three self-employment sources
      cps[se.status == T & !is.na(GRP), selfemp := as.double(means[cbind(1:nrow(means), max.col(means))])]  # alternative 2: (koji's choice) take max
      cps[se.status == T & !is.na(GRP), selfemp := rnorm(selfemp, selfemp, 500)]
      
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
      cps[se.status == T, earnings :=  replace(earn*50, is.na(earn), 0) + as.double(selfemp)]
      # cps[ is.na(ea1rn) & !is.na(selfemp), earnings := selfemp]
      
      # earnings by family
      cps[, earnings := sum(earnings, na.rm = T), by = .(h_seq, fid)]
      
      # identify non-working families: all the people that might be working
      # are indeed not working
      cps[, nw := sum(!is.na(notwork)) == sum(notwork, na.rm = T), by = .(h_seq, fid)]
      cps[cps[, .I[sum(!is.na(notwork)) == 0], by = .(h_seq, fid)]$V1, nw := NA] # ignore families where everyone is retired/disabled
          
            
      # out of 116,000 records, we keep a universe of 61,808, of which 4,422 are not working
      # when we aggregate in families, the universe expands to 99,758, of which 3,742 are nonworking families
      # this number is smaller beacuse often a nonworker is in a family with a worker
      # the original nonworking family rate came from 3742/99578: 0.0375
      # but we want to ask: of these 3742 people in nonworking families, how many are poor?
      # so we zoom in to calculate the mean FPM among these 3742 instead of the 99,000 previously
      # and actually, we're zooming in to 3227 since some people weren't assigned and FPM before (not in universe)
      # of those 3227, poverty rate is .31577
      # if we look at the 1031 children, poverty rate is .4597
      
      # I now identify whether someone is in a nonworking family for all 116,574 records
      # there were 61,458 in the universe of potential non-workers, 4423 did not work
      # that aggregated to 3811 people in nonworking families
      # if family was only retired/disabled, the entire family was ignored
      # ie. 17151 people in 11346 families were ignored
      # and we kept 99423 people in 39442 families
      # 3811 people were in nonworking families
      # cps[nw == 1, mean(povstatus, na.rm = T)]
      
      # ----> poverty with earnings should be ~32%, drop to ~27% with self-employment earnings
      cps[, povstatus := fincome < threshold]
      cps[, c('earnpov') := NA]
      cps[, earnpov := earnings < threshold]
      
      # # ----> this check can be used to compare our output with monthlyCPS_00_1_Cleaned.dta
      # '../../fpm/modifDat/monthlyCPS_01_3_Cleaned.dta' %>%
      #   readstata13::read.dta13(convert.factors = F) %>%
      #   data.table() %>%
      #   set(., i=which(.[['hrsersuf']]=='-1'), j='hrsersuf', value='') %>%
      #   .[, .(hrhhid = paste0(hrhhid,hrsersuf), pulineno, totFamEarn_annual, FPM_earn_seImp, pearn_SE_annual, earnings_SE, FPM_NotWork3)] %>%
      #   merge(cps, ., by = c('hrhhid', 'pulineno')) -> tmp2
      # 
      # # if we combine se.status by family and drop families with SE earnings, we get equal earnings
      # tmp2[, se.status2 := sum(se.status), .(hrhhid, fid)]
      # tmp2[weight.or > 0 & 
      #        round(earnings) != round(totFamEarn_annual) &
      #        floor(earnings) != floor(totFamEarn_annual) & 
      #        se.status2 == F]
      # 
      # table(tmp2$pearn_SE_annual > 0, tmp2$se.status)
      # 
      # # ------> and check with original datafile
      # '../data/dta/cpsmar01.dta' %>% 
      #   readstata13::read.dta13() %>% 
      #   data.table() -> tmp 
      # tmp[hrhhid == '', c('hrhhid', 'pulineno', 'pworwgt', 'prernwa')]
      # -------------> check from datafile why is there difference between Koji's data file and my data for this family? 
      # -------------> does one member have zero or missing earnings and what does that mean?
      monthly.poverty.yr[[1]][mo] <- weighted.mean(cps$povstatus, cps$weight.fn, na.rm = T) 
      # one alternative is to use [hrmis %in% c(1,5)] for income poverty
      monthly.poverty.yr[[2]][mo] <- weighted.mean(cps$earnpov, cps$weight.or, na.rm = T) 
      monthly.poverty.yr[[3]][mo] <- cps[peage < 18 & hufaminc > 0, weighted.mean(nw, weight.fn, na.rm = T)]
     
      if(year(Sys.time()) - 1 == yr) {
       monthly.poverty.yr <- lapply(monthly.poverty.yr, function(x) x[x>0])
      } 
    }
    monthly.poverty.yr
  }
}
)
print(st)


# separate raw outputs
children.nw.poverty <- monthly.poverty[[3]]
earnings.poverty <- monthly.poverty[[2]]
monthly.poverty  <- monthly.poverty[[1]]

# take means and standard deviations across simulation to get monthly poverty
grp                 <- seq_along(monthly.poverty) %% (length(years)*12)
grp[length(grp)]    <- length(years)*12
monthly.poverty.sd  <- sapply(split(monthly.poverty, grp), sd) %>% as.vector
monthly.poverty     <- sapply(split(monthly.poverty, grp), mean) %>% as.vector
earnings.poverty.sd <- sapply(split(earnings.poverty, grp), sd) %>% as.vector
earnings.poverty    <- sapply(split(earnings.poverty, grp), mean) %>% as.vector
children.nw.poverty.sd <- sapply(split(children.nw.poverty, grp), sd) %>% as.vector
children.nw.poverty    <- sapply(split(children.nw.poverty, grp), mean) %>% as.vector

# get official poverty
poverty          <- as.vector(unlist(feather::read_feather('../inputs/calculated_poverty.f')))
official.poverty <- c(11.9, 11.3, 11.7, 12.1, 12.5, 12.7, 12.6, 12.3, 12.5, 13.2, 14.3, 15.1, 15, 15, 14.5, 14.8, 13.5, 12.7)

png('../output.png')
ylim <- c(0.1, 0.16)  # for simple FPM
plot(c(0,0), ylab = 'poverty rate', xlab = 'year', 
     ylim = ylim, xlim = c(1998, 2018), main = 'frequent poverty rate')
rug(x = c(years, 2017, 2018), ticksize = 1, side = 1, col = 'gray', lty = 2)
lines(stepfun(2000:2016, poverty))
lines(stepfun(2000:2016, official.poverty / 100), col = 'red')

# draw gray boundary that is 2*(standard deviation) from mean of simulation
time  <- seq(1999, 2017, length.out = length(monthly.poverty)+1)[1:length(monthly.poverty)] + .04
edges <- c(monthly.poverty + 2*monthly.poverty.sd, rev(monthly.poverty - 2*monthly.poverty.sd))
drop.end <- which(is.na(edges))
polygon(c(time+.5, rev(time+.5))[-drop.end], edges[-drop.end], col = 'lightgray', border = F)
# rgb(211,211,211,0.1, maxColorValue=255)
lines(time + .5, monthly.poverty, col = 'blue')
dev.off()

pdf('../output2.pdf')
ylim <- c(0.25, 0.35)  # for earnings poverty
plot(c(0,0), ylab = 'poverty rate', xlab = 'year', 
     ylim = ylim, xlim = c(1998, 2018), main = 'frequent earnings poverty rate')
rug(x = c(years, 2017, 2018), ticksize = 1, side = 1, col = 'gray', lty = 2)
lines(stepfun(2000:2016, c(poverty)))
# draw gray boundary that is 2*(standard deviation) from mean of simulation
time  <- seq(1999, 2017, length.out = 217)[1:length(monthly.poverty)]
edges <- c(earnings.poverty + 2*earnings.poverty.sd, rev(earnings.poverty - 2*earnings.poverty.sd))
drop.end <- which(is.na(edges))
polygon(c(time, rev(time))[-drop.end], edges[-drop.end], col = 'lightgray', border = F)
# rgb(211,211,211,0.1, maxColorValue=255)
lines(time+1, earnings.poverty, col = 'darkgreen')
dev.off()

pdf('../output3.pdf')
ylim <- c(0, 0.16)  # for nonworking children poverty
plot(c(0,0), ylab = 'poverty rate', xlab = 'year', 
     ylim = ylim, xlim = c(1998, 2018), main = 'children in nonworking families')
rug(x = c(years, 2017, 2018), ticksize = 1, side = 1, col = 'gray', lty = 2)
lines(stepfun(2000:2016, poverty))
time  <- seq(1999, 2017, length.out = 217)[1:length(monthly.poverty)]
edges <- c(children.nw.poverty + 2*children.nw.poverty.sd, rev(children.nw.poverty - 2*children.nw.poverty.sd))
drop.end <- which(is.na(edges))
polygon(c(time, rev(time))[-drop.end], edges[-drop.end], col = 'lightgray', border = F)
lines(time+1, children.nw.poverty, col = 'coral4')
dev.off()



# save outputs
write_feather(data.frame(monthly.poverty), 'monthly.poverty.fthr')
write_feather(data.frame(monthly.poverty.sd), 'monthly.poverty.sd.fthr')

write_feather(data.frame(earnings.poverty), 'earnings.poverty.fthr')
write_feather(data.frame(earnings.poverty.sd), 'earnings.poverty.sd.fthr')

write_feather(data.frame(children.nw.poverty), 'children.nw.poverty.fthr')
write_feather(data.frame(children.nw.poverty.sd), 'children.nw.poverty.sd.fthr')

# # or, for fun:
# zoo::rollmean(monthly.poverty, 12) %>%
# lines(seq(1999, 2017, length.out = 217)[6:198], ., type = 'l', col = 'green')

monthly.poverty        <- unlist(read_feather('monthly.poverty.fthr'))
monthly.poverty.sd     <- unlist(read_feather('monthly.poverty.sd.fthr'))

earnings.poverty       <- unlist(read_feather('earnings.poverty.fthr'))
earnings.poverty.sd    <- unlist(read_feather('earnings.poverty.sd.fthr'))

children.nw.poverty    <- unlist(read_feather('children.nw.poverty.fthr'))
children.nw.poverty.sd <- unlist(read_feather('children.nw.poverty.sd.fthr'))

# --------------------------- DEPRACATED

### the following code resamples family incomes and self employment incomes at the same time
# # resample from asec.incomes to get means for CPS
# cps <- cps[!is.na(GRP)]
# setkey(cps, GRP)
# setkey(asec.incomes, GRP)
# means <- mapply(
#   function(x, m) {
#     # set.seed(32894+1)  # would need to change for-loop from being year-centered
#     x[sample(nrow(x), m, replace = T), .(ftotval, wsalval, sempval, farmval)]
#   },
#   x = split(asec.incomes, asec.incomes$GRP), 
#   m = groups$Ncps) %>% 
#   t %>% 
#   unlist
# # now get means of every category
# means <- data.frame(split(means, sort(rep(1:4, nrow(cps)))))
# names(means) <- c('inc', 'wsal', 'semp', 'farm')
# cps$selfemp <- means$wsal + means$semp + means$farm      # alternative 1: add three self-employment sources
# cps$selfemp <- pmax(means$wsal, means$semp, means$farm)  # alternative 2: (koji's choice) take max
# cps$selfemp2 <- pmax(means$semp, means$farm)
# 
# cps$fincome <- rnorm(nrow(cps), means$inc, sd = 500)
# cps$selfemp <- rnorm(cps$selfemp, sd = 500)




