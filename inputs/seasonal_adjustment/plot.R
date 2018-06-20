#!/usr/bin/Rscript
# this figure plot all the results from kerneling.R
# giovanni righi
# 27 April 2018


adjusted <- read.table('out', header = T)
monthly.poverty        <- adjusted[,1]
monthly.poverty.sd     <- adjusted[,2]
earnings.poverty       <- adjusted[,3]
earnings.poverty.sd    <- adjusted[,4]
children.nw.poverty    <- adjusted[,5]
children.nw.poverty.sd <- adjusted[,6]


# get official poverty
poverty          <- as.vector(unlist(feather::read_feather('../calculated_poverty.f')))
official.poverty <- c(11.9, 11.3, 11.7, 12.1, 12.5, 12.7, 12.6, 12.3, 12.5, 13.2, 14.3, 15.1, 15, 15, 14.5, 14.8, 13.5, 12.7)

for(i in 1:2) {
  if (i==1) png('all.png')
    else pdf('all.pdf')
  ylim <- c(0, 0.5)  # for simple FPM
  xlim <- c(as.Date('1999-12-01'), as.Date('2018-12-01'))
  plot(as.Date('1990-12-01'), 0, ylab = 'poverty rate', xlab = 'year', 
       ylim = ylim, xlim = xlim, main = 'frequent poverty rate')
  rug.years <- seq(from = as.Date('2000-01-01'), to = as.Date('2018-01-01'), by = "year")
  rug(x = rug.years, ticksize = 1, side = 1, col = 'gray', lty = 2)
  opm.years <- seq(from = as.Date('2000-01-01'), to = as.Date('2016-01-01'), by = "year")
  lines(stepfun(opm.years, poverty))
  #lines(stepfun(opm.years, official.poverty / 100), col = 'red')
  
  # draw gray boundary that is 2*(standard deviation) from mean of simulation
  time  <- seq(from = as.Date("2000-01-01"), by = "month", length.out = length(monthly.poverty))
  edges <- c(monthly.poverty + 2*monthly.poverty.sd, rev(monthly.poverty - 2*monthly.poverty.sd))
  drop.end <- which(is.na(edges))
  polygon(c(time, rev(time))[-drop.end], edges[-drop.end], col = 'lightgray', border = F)
  # rgb(211,211,211,0.1, maxColorValue=255)
  lines(time, monthly.poverty, col = 'blue')

  lines(time, earnings.poverty, col = 'red')

  lines(time, children.nw.poverty, col = 'green')

  x <- par()$usr[1] + 100
  y <- par()$usr[4] * 0.98
  legend(x, y, xpd = T, lty = 1, pch = c(NA,NA,NA,1), col = c('blue', 'red', 'green', 'black'), 
         box.col = 'ghostwhite', bg = 'ghostwhite',
  	c('monthly poverty', 'earnings poverty', 'children nonworking families poverty', 
          'official poverty measure'))
  
}



