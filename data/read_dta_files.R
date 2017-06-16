#! /usr/bin/Rscript

# the following is inspired by the dict construct in python but is a clunky way to do this:
readers <- list(
  list(201501:as.numeric(format(Sys.time(), "%Y%m")), 'cpsbjan2015.do'),
  list(201404:201412, 'cpsbapr2014.do'),
  list(201401:201403, 'cpsbjan2014.do'),
  list(201301:201312, 'cpsbjan13.do'),
  list(201205:201212, 'cpsbmay12.do'),
  list(201001:201204, 'cpsbjan10.do'),
  list(200901:200912, 'cpsbjan09.do'),
  list(200701:200812, 'cpsbjan07.do'),
  list(200508:200612, 'cpsbaug05.do'),
  list(200405:200507, 'cpsbmay04.do'),
  list(200301:200404, 'cpsbjan03.do'),
  list(199801:200212, 'cpsbjan98.do'))

find_reader <- function(x, find){
  if(datafile == 'cpsrwdec07.dat') {
    return('cpsrwdec07.do') 
  } else if(is.element(find, x[[1]])) {
    return(x[[2]])
  }
}

# r <- unlist(lapply(readers, find_reader, find = serial))
# 
# r <- unique(r)
# 
# write(r, stdout())

for (datafile in list.files(pattern = 'dat')) {
  mo <- substr(datafile, 4, 6)
  yr <- substr(datafile, 7, 8)
  
  mos <- tolower(month.abb)
  m <- which(mos == mo)
  yrs <- 1970:2069
  y <- yrs[which(substr(as.character(yrs), 3, 4) == yr)]
  
  serial <- as.numeric(y) * 100 + as.numeric(m)
  
  reader <- unlist(lapply(readers, find_reader, find = serial))
  dict   <- sub('do', 'dct', reader)
  dta    <- sub('do', 'dta', reader)
  
  readLines(reader)
}
