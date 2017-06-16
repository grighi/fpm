
# get asec data
cd data-asec
bash get_asec_dta.sh

# get monthly data
cd ../data
bash get_dta_files.sh

# play with data
cd ../inputs
./initialize_env.R
./data_clean2.R
./clean_asec.R
./povline.R
./kerneling.R
