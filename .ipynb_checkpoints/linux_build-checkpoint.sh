
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

# put figures in excel, create final write-up
python3 output_images.py
pandoc -o write-up.docx write-up.md
pandoc -o write-up.html write-up.md
pandoc -o write-up.pdf  write-up.md





