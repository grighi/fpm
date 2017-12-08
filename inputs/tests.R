

# should be using the same number of fincome observations as Koji to estimate FPM_3

# --------------------------------------------------------------------------------------------------
# --------- for some specific month, the earnings should relatively match --------------------------
'../../fpm/modifDat/monthlyCPS_01_3_Cleaned.dta' %>% 
  readstata13::read.dta13(convert.factors = F) %>% 
  data.table() %>%
  set(., i=which(.[['hrsersuf']]=='-1'), j='hrsersuf', value='') %>%
  .[, .(hrhhid = paste0(hrhhid,hrsersuf), pulineno, totFamEarn_annual, FPM_earn_seImp, pearn_SE_annual, earnings_SE)] %>% 
  merge(cps, ., by = c('hrhhid', 'pulineno')) -> tmp2

# if we combine se.status by family and drop families with SE earnings, we get equal earnings
tmp2[, se.status2 := sum(se.status), .(hrhhid, fid)]
tmp2[weight.or > 0 & 
       round(earnings) != round(totFamEarn_annual) &
       floor(earnings) != floor(totFamEarn_annual) & 
       se.status2 == F]  # should yield zero rows if earnings match

# --------------------------------------------------------------------------------------------------
# -------- for some specific month, the SE earnings should have similar distributions --------------
'../../fpm/modifDat/monthlyCPS_01_3_Cleaned.dta' %>% 
  readstata13::read.dta13(convert.factors = F) %>% 
  data.table() %>% 
  .[, c('hrhhid', 'pulineno', 'totFamEarn_annual', 'FPM_earn_seImp', 'earnings_SE')] %>% 
  merge(cps, ., by = c('hrhhid', 'pulineno')) -> tmp2

table(!is.na(tmp2$earnings_SE), tmp2$se.status)  # match number of self-employed?







