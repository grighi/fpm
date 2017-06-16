# function to return poverty thresholds adjusted for inflation

cpi <- data.frame(feather::read_feather('cpi.f'))

rawOPM <- read.csv('OPMthresh.csv', stringsAsFactors = F)
rawOPM <- rawOPM[, which(colnames(rawOPM) != 'threshYear')]
rawOPM <- rawOPM[order(rawOPM$idouTotal, rawOPM$idouChildTotal), ]

# time counter starts as -11 in Jan 1999
cpi$time <- (cpi$year - 2000)*12 + cpi$month

off.thr <- function(tm = -11) {
  if (!(tm %in% -11:max(cpi$time))) stop("time is outside of current CPI data")
  
  rawOPM$ouThresh <- cpi$cpi[which(cpi$time == tm)] * rawOPM$ouThresh
  return(rawOPM)
}
