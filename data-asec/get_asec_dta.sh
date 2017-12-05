#!/bin/bash

## this script is a modification of the other data-fetching script that only 
## fetches ASEC data.

## Therefore, this script is limited to create dct & do files *only* for the data 
## dictionaries on the NBER site. It may be worthwhile to make .do scripts to use 
## the (more comprehensive?) dictionaries at the Census website.

## by Giovanni Righi
## updated 29 May 2017

echo 'downloading data...' 

# download data
curl http://www.nber.org/data/cps.html |
  sed '/<!--/ {
N;N;N;N;N;N;N;N; N; N; N; N; N; N; N; N; N; N; N; N; N; N; N; N; N;
s/<!--.*-->// }' | 
  grep -i href | 
  egrep "cpsmar(20)?[012][0-9].zip" | 
  grep -o "/cps/.*.zip" |
  while read line
   do
     echo www.nber.org$line
   done | 
  parallel wget -nv


# unzip those guys with appropriate name
parallel "unzip -p {} > {= s:([a-z]{3,}[0-9]+).+:\1:; =}.dat" ::: *.zip 
rm *.zip


# pull down NBER dct files for conversion 
curl -s http://www.nber.org/data/cps_progs.html |
  grep href |
  grep -oPe /data.*?cpsmar.*?.dct |
  egrep "[012][0-9].dct" | 
   while read line
  do
    echo www.nber.org$line
  done | 
  parallel wget -nv


# download associated do files
curl -s http://www.nber.org/data/cps_progs.html |
  grep href |
  grep -oPe /data.*?cpsmar.*?.do |
  egrep "[012][0-9].do" | 
   while read line
  do
    echo www.nber.org$line
  done | 
  parallel wget -nv

# edit dct for simplicity since filenames are consistent
for file in *.dct
do
  sed -i 's/dictionary using .*.raw/infile dictionary/' $file
done

# change some text in do
for file in cps*.do
do
  sed -i 's/\/homes\/data\/cps\///g' $file
  sed -i 's/\/homes\/data\/cps\///g' $file
  # -Fxq matches "only that text" and "that whole text on a whole line":
  if ! grep -Fxq '#delimit cr' $file; 
    then 
    echo '#delimit cr' >> $file 
  fi

  # add colon to save if it comes before change in delimiter
  a=$(grep -n 'save\(old\)\?.*replace' $file | cut -f1 -d:)
  b=$(grep -n '#delimit cr' $file | cut -f1 -d:)
  #echo $a
  #echo $b
  #if [ -z a ]; then
#	  echo "Did not find 'save' line in $file"
 # fi
  #if [ -z b ]; then
#	  echo "Did not find 'delimit' line in $file"
 # fi
  if [[ $a < $b ]]; then
    # make sure save is delimited
    sed -i 's/\(save.*\)/\1;/' $file
  else
    # or make sure it is not
    sed -i 's/\(save.*replace\);/\1/' $file   
  fi
done

rm cpsmar2001.dat

# convert to stata
i=1;
for datafile in *.dat; do
  reader=${datafile%dat}do
  dict=${datafile%dat}dct
  dta=${datafile%dat}dta	
  
  # strip quotes if they exist
  sed -i -e 's/\(local d.._name \)"\(.*\)"/\1\2/' $reader

  # replace file names
  sed -i "s/local dat.*dat/local dat_name $datafile/" $reader
  sed -i "s/local dta.*dta/local dta_name $dta/" $reader
  sed -i "s/local dct.*dct/local dct_name $dict/" $reader

  # file names also appear a different way in some do files
  sed -i "s/\(quietly infile using \)\(cpsmar[0-9]*\)/\1\\2.dct, using(\2.dat)/" $reader

  $(stata -b do $reader) &
#&& rm $datafile) &
  pids[${i}]=$!; ((i+=1));
done

for pid in ${pids[*]}; do 
  wait $pid; 
done;


## now get the revised weights
#cd new_weights_2000-2002/
#wget http://thedataweb.rm.census.gov/pub/cps/basic/199801-/pubuse2000_2002.tar.zip

#tar -xzvf pubuse2000_2002.tar.zip
## a couple files need write permissions
#chmod +w *_2000b.dat 


