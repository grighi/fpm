mkdir data
mv get_dta_files.sh data/
mv which_reader.R data/
mv init.do data/
mv new_weights_2000-2002 data/

cd data

mkdir new_weights_2000-2002
mv epi_dict_00_02_update.dct new_weights_2000-2002/
mv init.do new_weights_2000-2002/

mkdir ../inputs/

bash get_dta_files.sh

cd ..
mkdir data-intermediate
mkdir inputs

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
