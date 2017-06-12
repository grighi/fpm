# Get most recent CPI and save as dataframe

library(blsAPI)
library(rjson)
library(feather)

# pull the CPI for all urban consumers
cpi1 <- list('seriesid' = 'CUUR0000SA0', 'startyear' = '1999', 'endyear' = '2009',
             'registrationkey' = 'a0ccc7b5a4de49ffa7608692ef251fbc') %>% 
  blsAPI() %>% 
  fromJSON()
cpi1 <- data.frame(
  month = factor(sapply(X = cpi1$Results$series[[1]]$data, FUN = `[[`, "periodName")),
  year = as.numeric(sapply(X = cpi1$Results$series[[1]]$data, FUN = `[[`, "year")),
  value = as.numeric(sapply(X = cpi1$Results$series[[1]]$data, FUN = `[[`, "value")))

cpi2 <- list('seriesid' = 'CUUR0000SA0', 'startyear' = '2010', 'endyear' = '2017',
             'registrationkey' = 'a0ccc7b5a4de49ffa7608692ef251fbc') %>% 
  blsAPI() %>% 
  fromJSON()
cpi2 <- data.frame(
  month = factor(sapply(X = cpi2$Results$series[[1]]$data, FUN = `[[`, "periodName")),
  year = as.numeric(sapply(X = cpi2$Results$series[[1]]$data, FUN = `[[`, "year")),
  value = as.numeric(sapply(X = cpi2$Results$series[[1]]$data, FUN = `[[`, "value")))

cpi <- rbind(cpi2, cpi1)
rm(cpi1, cpi2)

cpi$month <- match(cpi$month, month.name)
cpi$value <- cpi$value / 165.4  # make CPI relevant to first half of 2016
names(cpi) <- c('month', 'year', 'cpi')

write_feather(cpi, 'cpi.f')
