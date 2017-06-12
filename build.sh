
# get asec data
cd data-asec
bash get_asec_dta.sh

# get monthly data
cd ../inputs
bash get_dta_files.sh

# play with data
./data_clean.R
./clean_asec.R
./povline.R
./kerneling.R
