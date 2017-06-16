

## - - - get asec data: choose python or bash alternative
cd data-asec
# bash get_asec_dta.sh
./get_asec_dta.py


## - - - get monthly data: choose python or bash alternative
cd ../data
# bash get_dta_files.sh
./get_dta_files.py


## - - - play with data
cd ../inputs
./initialize_env.R
./data_clean2.R
./clean_asec.R
./povline.R
./kerneling.R


# README:
#python install, with pip3 install bs4
#r install
#runnning
