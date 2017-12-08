
years <- 1999:2015
for(yr in years){
  # this code is setup to run in parallel to produce many replications across years very quickly.
  # to do this, it uses %dopar% ('doparallel') from the doMC ('do multicore') package. It is 
  # embarassingly parallel because it loops over our years, creating a vector of length 12
  # for each year. To perform replications, we simply feed in years multiple times. The final
  # resulting vector has length 12*(number of years)*(number of reps), and statistics are 
  # taken across the replications.
  
  cps.yr <- yr+1
  asec.yr <- yr+1
  
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
    
    if(!('notwork' %in% names(cps))) print(filename)
  }}

    