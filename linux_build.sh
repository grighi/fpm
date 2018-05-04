
# you may want to upgrade pip and install some packages
# pip install -U pip
# pip install bs4
# pip install pandas

# get asec data
cd data-asec
# bash get_asec_dta.sh
python get_asec_dta.py

# get monthly data
cd ../data
# bash get_dta_files.sh
python get_dta_files.py

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





