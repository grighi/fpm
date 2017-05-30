mkdir data
mv get_dta_files.sh data/
mv which_reader.R data/
mv init.do data/
mv add_weights.do data/
mv epi_extract_94_09.do data/
mv epi_dict_00_02_update.dct data/

cd data

mkdir new_weights_2000-2002
mv epi_dict_00_02_update.dct new_weights_2000-2002/
mv epi_extract_94_09.do new_weights_2000-2002/
mv init.do new_weights_2000-2002/

mkdir ../inputs/

bash get_dta_files.sh

cd ../data-asec

bash get_asec_dta.sh

mkdir data-intermediate
mv data_clean.R inputs/
./data_clean.R


# other files:
# cpi.R
# povline.R
# rawOPMThresh.csv (move to R vector!)
# opm.R
# need data-asec/* (march supplements) for povline.R to work

# mv in data_clean.R
# mv in kerneling.R
