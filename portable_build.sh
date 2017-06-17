

## - - - get asec data: choose python or bash alternative
cd data-asec
# bash get_asec_dta.sh
python3 get_asec_dta.py


## - - - get monthly data: choose python or bash alternative
cd ../data
# bash get_dta_files.sh
python3 get_dta_files.py


## - - - play with data
cd ../inputs
Rscript initialize_env.R
Rscript data_clean2.R
Rscript clean_asec.R
Rscript povline.R
Rscript kerneling.R
