#!/usr/bin/Rscript
# Download required pacakges
# June 1, 2017 -- G Righi -- modified from GS-Lab script

# Local_build will be TRUE if this script was called from initialize_local.sh
# build <- commandArgs(TRUE)[1]
cat("Commencing R package installations.\n")

# if (build == "RCC"){
#     ## Set-up RCC Environment when "RCC" is specified as a command line argument
#     setwd('~')
#     unlink('R_libs/*', recursive = TRUE)
#     unlink('R-dev/*', recursive = TRUE)
# }

## Install CRAN Packages
packages <- c("data.table", "readstata13", "feather", "blsAPI", "rjson",
              "randomForest", "doMC", "magrittr", "plyr")

repo <- "http://cran.cnr.Berkeley.edu/"

a <- available.packages(contriburl = contrib.url(repo))
b <- installed.packages()

invisible(
  sapply(packages, function(pkg) {
    if (a[pkg, 'Version'] != b[pkg, 'Version']) {
      install.packages(pkg, repos = repo, quiet = T)}
    }))

cat("Package download complete.\n")
