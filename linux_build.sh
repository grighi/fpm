
# you may want to upgrade pip and install some packages
# pip install -U pip
# pip install bs4
# pip install pandas

trap exit SIGINT SIGTERM

echo 'Do you want to download all data files again? y/[n]'
read yesno

if [ "$yesno" == "y" ]; then
  # get asec data
  cd data-asec
  # bash get_asec_dta.sh
  python3 get_asec_dta.py

  # get monthly data
  cd ../data
  # bash get_dta_files.sh
  python3 get_dta_files.py
  cd ../inputs
else
  echo 'continuing...'
  cd inputs
fi

# play with data
Rscript initialize_env.R
Rscript data_clean2.R
Rscript clean_asec.R
Rscript povline.R
Rscript kerneling.R
Rscript plot.R

# put figures in excel, create final write-up
python3 output_images.py
pandoc -o write-up.docx write-up.md
pandoc -o write-up.html write-up.md
pandoc -o write-up.pdf  write-up.md

 



