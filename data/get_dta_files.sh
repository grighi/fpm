#! /bin/bash

## this script pulls all the CPS basic data and associated files from the NBER site. 
## It requires ~50GB of free space. 
## Files are pulled down as zip, named appropriately during unzipping to dat, 
## and converted to stata .dta files with the dct and do files on the NBER website.

## Therefore, this script is limited to create dct & do files *only* for the data 
## dictionaries on the NBER site. It may be worthwhile to make .do scripts to use 
## the (more comprehensive?) dictionaries at the Census website.

## !! NOTE: this script is still a work in progress. It does not yet correctly make 
## all the files for which we have .do files

## by Giovanni Righi
## updated 11 October 2016


# download data

curl http://www.nber.org/data/cps_basic.html |
  sed '/<!--/ {
N;N;N;N;N;N;N;N; N; N; N; N; N; N; N; N; N; N; N; N; N; N; N; N; N;
s/<!--.*-->// }' | 
  grep -i href | 
  egrep "17r?pub.zip" | 
  grep -o "/cps-basic/.*.zip" |
   while read line
  do
    echo www.nber.org$line
  done | 
  parallel wget -nv

curl http://www.nber.org/data/cps_basic.html |
  sed '/<!--/ {
N;N;N;N;N;N;N;N; N; N; N; N; N; N; N; N; N; N; N; N; N; N; N; N; N;
s/<!--.*-->// }' | 
  grep -i href | 
  egrep "17r?pub.zip" | 
  grep -o "/cps-basic/.*.zip" |
   while read line
  do
    echo www.nber.org$line
  done | 
  parallel wget -nv

# unzip those guys with appropriate name
# !! it would be nice to unzip and run stata (see end) on these one-by-one, but some of the do-files have different names, so it won't work :(
parallel "unzip -p {} > cps{= s:([a-z]{3,}[0-9]+).+:\1:; =}.dat" ::: *.zip 
rm *.zip


# pull down dct files for conversion 

curl -s http://www.nber.org/data/cps_basic_progs.html |
  grep href |
  grep -oPe /data.*?cps[a-z].*?.dct |
  egrep "[0129][0-9]t?.dct" | 
  while read line
  do
    echo www.nber.org$line
  done | 
  parallel wget -nv

# it is not clear which are the correct dictionary files. The CPS downloads page (linked at the NBER dct page) says that, e.g. 2010 and 2011 january should follow the same dct file. But running `diff` on these two files from the NBER page shows that there are differences (??)


# associated do files
curl -s http://www.nber.org/data/cps_basic_progs.html |
  grep href |
  grep -oPe /data.*?cps[a-z].*?.do |
  egrep "[0129][0-9]t?.do" | 
  while read line
  do
    echo www.nber.org$line
  done | 
  parallel wget -nv


# change some text in dct
for file in *.dct
do
  sed -i 's/dictionary using .*.raw/infile dictionary/' $file
done


# change some text in do
for file in *.do
do
  sed -i 's/\/homes\/data\/cps-basic\///g' $file
  sed -i 's/\/homes\/data\/cps\///g' $file
  
  # -Fxq matches "only that text" *and* "that whole text on a whole line"
  if ! grep -Fxq '#delimit cr' $file; 
    then 
    echo '#delimit cr' >> $file 
  fi

  # change save delimiter if it is backwards 
  a=$(grep -n 'save.*`d' $file | cut -f1 -d:)
  b=$(grep -n '#delimit cr' $file | cut -f1 -d:)
  if [[ $a < $b ]]; then
    sed -i 's/\(save.*\)/\1;/' $file
  else
    # or make sure it is not
    sed -i 's/\(save.*replace\);/\1/' $file   
  fi
done


# fix for dec 2007 reweights
wget http://www.nber.org/cps-basic/cpsrwdec07.zip

unzip cpsrwdec07.zip && rm cpsrwdec07.zip
sed -i -e 's/cpsdec07.dat/cpsrwdec07.dat/' cpsrwdec07.do
sed -i -e 's/cpsdec07.dta/cpsrwdec07.dta/' cpsrwdec07.do


# convert to stata
i=1
for datafile in *.dat; do
  reader=$(./which_reader.R $datafile)
  dict=${reader%do}dct
  dta=${datafile%dat}dta
  
  # strip quotes if they exist
  sed -i -e 's/\(local d.._name \)"\(.*\)"/\1\2/' $reader

  # replace file names
  sed -i "s/local dat.*dat/local dat_name $datafile/" $reader
  sed -i "s/local dta.*dta/local dta_name $dta/" $reader
  sed -i "s/local dct.*dct/local dct_name $dict/" $reader

  # if storage-constrained, use:  && rm $datafile
  $(stata -b do $reader) &
  pids[${i}]=$!; ((i+=1));
done

for pid in ${pids[*]}; do 
  wait $pid; 
done;

# in May 2017, should read 220 files

# now get the revised weights
cd new_weights_2000-2002/
wget http://thedataweb.rm.census.gov/pub/cps/basic/199801-/pubuse2000_2002.tar.zip

unzip pubuse2000_2002.tar.zip && rm pubuse2000_2002.tar.zip
tar -xvf pubuse2000_2002.tar && rm pubuse2000_2002.tar
# a couple files need write permissions
chmod +w *_2000b.dat 

if [ ! -d dta ]; 
  then mkdir dta; 
fi

import glob
datafiles = glob.glob('*dat')
stata -b do init.do

rm *_2000b.dat

cd ..

# if set up for the Stanford AFS files, you may prefer:
# stata -b do concatenate_cps_1999-2016.do
# else
stata -b do add_weights_monthly.do

# clean up
rm *.dat

if [ ! -d dta ]; 
  then mkdir logs; 
fi
mv *.dta dta/

if [ ! -d logs ]; 
  then mkdir logs; 
fi
mv *.log logs/

if [ ! -d dofiles ]; 
  then mkdir dofiles; 
fi
mv *.{do,dct} dofiles/

# rm cps[a-z]*.dta cps*.do *.dct




