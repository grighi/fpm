#!/usr/local/bin/Rscript
# this figure plot all the results from kerneling.R
# giovanni righi
# 27 April 2018

library(feather)

setwd('../data-intermediate')

years <- 2000:2017

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

# # or, for fun:
# zoo::rollmean(monthly.poverty, 12) %>%
# lines(seq(1999, 2017, length.out = 217)[6:198], ., type = 'l', col = 'green')


