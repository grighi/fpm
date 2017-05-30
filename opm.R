# cpi <- read.csv('cpi_u_2016_10.csv')
# cpi$month <- match(cpi$month, month.abb)
# cpi <- na.omit(cpi)
# --- ? do need cpi "annual" ( == NA) to be replaced with zero?
cpi <- data.frame(read_feather('cpi.f'))

rawOPM <- read.csv('rawOPMThresh.csv', stringsAsFactors = F)
rawOPM <- rawOPM[, which(colnames(rawOPM) != 'threshYear')]
rawOPM$ouThresh <- as.numeric(gsub('[,.]', '', rawOPM$ouThresh))
rawOPM <- rawOPM[order(rawOPM$idouTotal, rawOPM$idouChildTotal), ]
# --- ? this DF is copy/pasted with two additional columns:
# --- year = 1999, month = 1
# and that is repeated for every month and year to the present
# so if this DF has 99 columns, the final DF has 99 columns for 1999:1, 
# 99 columns for 1999:2, ... 99 columns for 2016:12

# every year-month has 
# * cpi
# * 99-row rawOPM

# time counter starts as -12 at 1999:jan
cpi$time <- (cpi$year - 2000)*12 + cpi$month

# We should create OPM thresholds for yearly CPS data but these come with ouThresh = NA in the povLineOPM_ASEC.dta set
# -> povLineOPM_ASEC seems to be a bad file with no OPMs ...?
# -> povLineOPM is recreated with the function below, adjusting the OPM threshold with CPI

# OPM thresholds for monthly CPS data
# feather::read.feather('cpi.f')  # not yet implemented but useful across scripts...
# feather::read.feather('rawopm.f')
opm <- function(tm = -11, total, kids) {
  # OPM starts tm=-11:jan1999 or tm=0:jan2000
  if (!(min(tm) %in% -11:max(cps$time))) stop("time is outside of current CPI data")
  if (!(max(tm) %in% -11:max(cps$time))) stop("time is outside of current CPI data")
  
  i <- match(total, rawOPM$idouTotal)
  j <- match(kids, rawOPM$idouChildTotal)
  k <- intersect(i,j)
  
  povThresh <- cpi$cpi[match(tm, cpi$time)] * rawOPM$ouThresh[i]
  return(povThresh)
}

opm <- function(tm = -11) {
  if (!(tm %in% -11:max(cpi$time))) stop("time is outside of current CPI data")
  
  rawOPM$ouThresh <- cpi$cpi[which(cpi$time == tm)] * rawOPM$ouThresh
  return(rawOPM)
}
