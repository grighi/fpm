#!/usr/bin/Rscript
# this figure plot all the results from kerneling.R
# giovanni righi
# 27 April 2018

library(feather)

setwd('../data-intermediate')

# get calculated poverty
monthly.poverty        <- unlist(read_feather('monthly.poverty.fthr'))
monthly.poverty.sd     <- unlist(read_feather('monthly.poverty.sd.fthr'))

earnings.poverty       <- unlist(read_feather('earnings.poverty.fthr'))
earnings.poverty.sd    <- unlist(read_feather('earnings.poverty.sd.fthr'))

children.nw.poverty    <- unlist(read_feather('children.nw.poverty.fthr'))
children.nw.poverty.sd <- unlist(read_feather('children.nw.poverty.sd.fthr'))

# get official poverty
poverty          <- as.vector(unlist(feather::read_feather('../inputs/calculated_poverty.f')))
official.poverty <- c(11.9, 11.3, 11.7, 12.1, 12.5, 12.7, 12.6, 12.3, 12.5, 13.2, 14.3, 15.1, 15, 15, 14.5, 14.8, 13.5, 12.7)

for(i in 1:2) {
  ifelse(i==1, png('../fpm.png'), pdf('../fpm.pdf'))
  ylim <- c(0.1, 0.16)  # for simple FPM
  xlim <- c(as.Date('1998-01-01'), as.Date('2018-12-01'))
  plot(as.Date('1990-12-01'), 0, ylab = 'poverty rate', xlab = 'year', 
       ylim = ylim, xlim = xlim, main = 'frequent poverty rate')
  rug.years <- seq(from = as.Date('2000-01-01'), to = as.Date('2018-01-01'), by = "year")
  rug(x = rug.years, ticksize = 1, side = 1, col = 'gray', lty = 2)
  opm.years <- seq(from = as.Date('2000-01-01'), to = as.Date('2016-01-01'), by = "year")
  lines(stepfun(opm.years, poverty))
  lines(stepfun(opm.years, official.poverty / 100), col = 'red')
  
  # draw gray boundary that is 2*(standard deviation) from mean of simulation
  time  <- seq(from = as.Date("2000-01-01"), by = "month", length.out = length(monthly.poverty))
  edges <- c(monthly.poverty + 2*monthly.poverty.sd, rev(monthly.poverty - 2*monthly.poverty.sd))
  drop.end <- which(is.na(edges))
  polygon(c(time, rev(time))[-drop.end], edges[-drop.end], col = 'lightgray', border = F)
  # rgb(211,211,211,0.1, maxColorValue=255)
  lines(time[-1], monthly.poverty[-1], col = 'blue')
  dev.off()
}

paste('latest monthly poverty at', tail(time,1), ':', round(tail(monthly.poverty,1), 3))

pdf('../earnings_poverty.pdf')
ylim <- c(0.25, 0.35)  # for earnings poverty
xlim <- c(as.Date('1998-01-01'), as.Date('2018-12-01'))
plot(as.Date('1990-12-01'), 0, ylab = 'poverty rate', xlab = 'year', 
     ylim = ylim, xlim = xlim, main = 'earnings poverty rate')
rug.years <- seq(from = as.Date('2000-01-01'), to = as.Date('2018-01-01'), by = "year")
rug(x = rug.years, ticksize = 1, side = 1, col = 'gray', lty = 2)
opm.years <- seq(from = as.Date('2000-01-01'), to = as.Date('2016-01-01'), by = "year")
lines(stepfun(opm.years, poverty))

# draw gray boundary that is 2*(standard deviation) from mean of simulation
time  <- seq(from = as.Date("2000-01-01"), by = "month", length.out = length(monthly.poverty))
edges <- c(earnings.poverty + 2*earnings.poverty.sd, rev(earnings.poverty - 2*earnings.poverty.sd))
drop.end <- which(is.na(edges))
polygon(c(time, rev(time))[-drop.end], edges[-drop.end], col = 'lightgray', border = F)
# rgb(211,211,211,0.1, maxColorValue=255)
lines(time, earnings.poverty, col = 'darkgreen')
dev.off()

paste('latest earnings poverty at', tail(time,1), ':', round(tail(earnings.poverty,1), 3))

pdf('../nonworking_poverty.pdf')
ylim <- c(0, 0.16)  # for nonworking families poverty
xlim <- c(as.Date('1998-01-01'), as.Date('2018-12-01'))
plot(as.Date('1990-12-01'), 0, ylab = 'poverty rate', xlab = 'year', 
     ylim = ylim, xlim = xlim, main = 'earnings poverty rate')
rug.years <- seq(from = as.Date('2000-01-01'), to = as.Date('2018-01-01'), by = "year")
rug(x = rug.years, ticksize = 1, side = 1, col = 'gray', lty = 2)
opm.years <- seq(from = as.Date('2000-01-01'), to = as.Date('2016-01-01'), by = "year")
lines(stepfun(opm.years, poverty))

time  <- seq(from = as.Date("2000-01-01"), by = "month", length.out = length(monthly.poverty))
edges <- c(children.nw.poverty + 2*children.nw.poverty.sd, rev(children.nw.poverty - 2*children.nw.poverty.sd))
drop.end <- which(is.na(edges))
polygon(c(time, rev(time))[-drop.end], edges[-drop.end], col = 'lightgray', border = F)
lines(time+1, children.nw.poverty, col = 'coral4')
dev.off()

paste('latest earnings poverty at', tail(time,1), ':', round(tail(children.nw.poverty,1), 3))

# # or, for fun:
# zoo::rollmean(monthly.poverty, 12) %>%
# lines(seq(1999, 2017, length.out = 217)[6:198], ., type = 'l', col = 'green')


