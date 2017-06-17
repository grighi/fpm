#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
python3 translation of script ot download dta files
for cross-platform compatibility
"""


import bs4
from urllib.request import urlopen
from urllib.request import urlretrieve
from urllib.error import HTTPError
#from multiprocessing.dummy import Pool # use threads for I/O bound tasks
import re
import zipfile
import os
from url2filename import url2filename 
import subprocess
import tarfile
import glob


url = 'http://www.nber.org/data/cps_basic.html'
html_page = urlopen(url)
soup = bs4.BeautifulSoup(html_page, "html5lib")
urls = []
for link in soup.findAll('a'):
    match = re.search('[0-2][0-9]r?pub.zip', link.get('href'))
    if match:
        urls.append('http://www.nber.org' + link.get('href'))
    match2 = re.search('99r?pub.zip', link.get('href'))
    if match2:
        urls.append('http://www.nber.org' + link.get('href'))
    
zipped = []
#def download(url):
#    local_filename, headers = urlretrieve(url, url2filename(url))
#    zipped.append(local_filename)
# with Pool(3) as p:
#    print(p.map(download, urls))
    
# result = Pool(4).map(urlretrieve, urls) # use 4 threads to download files concurrently

for url in urls:
    try:
        local_filename, headers = urlretrieve(url, url2filename(url))
        zipped.append(local_filename)
    except HTTPError: 
        print('could not find ' + url)
        next

datafiles = []
for zip_path in zipped:
    zip_ref = zipfile.ZipFile(zip_path, 'r')
    oldname = zip_ref.namelist().pop()
    newname = 'cps' + re.search('[a-z]{3,}[0-9]+', oldname).group(0) + '.dat'
    out = zip_ref.extractall()
    os.rename(oldname, newname)
    zip_ref.close()
    os.remove(zip_path)
    datafiles.append(newname)


# now get the associated dofiles
dofiles = 'http://www.nber.org/data/cps_basic_progs.html'    
html_page = urlopen(dofiles)
soup = bs4.BeautifulSoup(html_page, "html5lib")
urls = []
for link in soup.findAll('a'):
    match_dct = re.search('9[7-9].dct|[012][0-9]t?.dct', link.get('href'))
    match_do  = re.search('9[7-9].do|[012][0-9]t?.do',  link.get('href'))
    if match_dct:
        urls.append('http://www.nber.org' + link.get('href'))
    if match_do:
        urls.append('http://www.nber.org' + link.get('href'))

dcts = []; dos = []
for url in urls:
    local_filename, headers = urlretrieve(url, url2filename(url))
    if re.search('.dct', local_filename):
        dcts.append(local_filename)
    if re.search('.do', local_filename):
        dos.append(local_filename)

for dct in dcts:
    with open(dct, 'r') as lines:
        tmp = lines.readline()
        txt = lines.read().splitlines(True)
        txt[0] = re.sub('dictionary using .*.raw', 'infile dictionary', tmp)
    with open(dct, 'w') as lines:
        lines.writelines(txt)
        
# the do-files were written with Latin-1 encoding, so they should be read as
# such, or they can be replaced with unicode encoding, basics of which are:
# from bs4 import UnicodeDammit
# dammit = UnicodeDammit("Mayag\xfcez")
# print(dammit.unicode_markup)
    
#for do in dos:
#    text = []
#    with open(do, 'r', encoding = "ISO-8859-1") as lines:  # not sure why this 
#    # encoding works if unicode doesn't
#        for lineno,line_i in enumerate(lines):
#            if re.search("#delimit cr", line_i):
#                delimline = lineno
#            if re.search("save.*d", line_i):
#                saveline = lineno
#            line_i = re.sub('/homes/data/cps-basic/', '', line_i)
#            line_i = re.sub('/homes/data/cps-basic/', '', line_i)
#            text.append(line_i)
#        if saveline < delimline:
#            # add semicolon
#            text[saveline] = re.sub('\(save.*\)', '\1;\n', text[saveline])
#        else:
#            # remove semicolon if there
#            text[saveline] = re.sub('\(save.*replace\);', '\1\n', text[saveline])
#        del saveline, delimline
#    with open(do, 'w') as lines:
#        lines.writelines(text)

import glob
datafiles = glob.glob('*dat')
dtafiles = glob.glob('*dta')
datafiles = [re.sub('dat', 'dta', x) for x in datafiles]
datafiles = list(set(datafiles) - set(dtafiles))
datafiles = [re.sub('dta', 'dat', x) for x in datafiles]


tmp_readers = {
  range(201501,201711): 'cpsbjan2015.do',  # remem ranges end at month+1 since zero-indexing
  range(201404,201413): 'cpsbapr2014.do',
  range(201401,201404): 'cpsbjan2014.do',
  range(201301,201313): 'cpsbjan13.do',
  range(201205,201213): 'cpsbmay12.do',
  range(201001,201205): 'cpsbjan10.do',
  range(200901,200913): 'cpsbjan09.do',
  range(200701,200813): 'cpsbjan07.do',
  range(200508,200613): 'cpsbaug05.do',
  range(200405,200508): 'cpsbmay04.do',
  range(200301,200405): 'cpsbjan03.do',
  range(199801,200213): 'cpsbjan98.do'}

readers = {}
for k, v in tmp_readers.items():
    for key in k:
        readers[key] = v

for datafile in datafiles:
    # find readerid associated with this file
    yrs = range(1995,2040)
    i1 = [str(x)[2:4] for x in yrs].index(datafile[6:8])
    mos = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']
    i2 = mos.index(datafile[3:6]) + 1  # since zero-indexed
    
    readerid = int(
        str(yrs[i1]) + "{:02d}".format(i2))
    
    # get some filenames
    reader = readers[readerid]
    dct    = re.sub('do', 'dct', reader)
    dta    = re.sub('dat', 'dta', datafile) 
    
    # substitute items in do-file to match our object
    with open(reader, 'r', encoding = "ISO-8859-1") as readerlines:
        text = []
        for line in readerlines:
            line = re.sub('(local d.._name )"(.*)"', '\g<1>\g<2>', line)  # drops quotes
            line = re.sub('local dat.*dat', 'local dat_name '+ datafile, line)
            line = re.sub('local dta.*dta', 'local dta_name '+ dta, line)
            line = re.sub('local dct.*dct', 'local dct_name '+ dct, line)
            text.append(line)
    with open(reader, 'w') as readerlines:
        readerlines.writelines(text)
    
    subprocess.run(['stata', '-e', 'do', reader])

# in May 2017, should read 220 files

# calculate dec 2007 reweights
reweights = 'cpsrwdec07.zip'
urlretrieve('http://www.nber.org/cps-basic/cpsrwdec07.zip', reweights)
with open(reweights, 'rb') as zipf:
    z = zipfile.ZipFile(zipf, 'r')
    z.extractall()
os.remove(reweights)
with open('cpsrwdec07.do', 'r') as reader:
    text = []
    for line in reader:
        line = re.sub('local dat.*dat"', 
                      'local dat_name '+ re.sub('zip', 'dat', reweights), line)
        text.append(line)
with open('cpsrwdec07.do', 'w') as reader:
    reader.writelines(text)

subprocess.run(['stata', '-e', 'do', re.sub('zip', 'do', reweights)])

# now get other revised weights
os.chdir('new_weights_2000-2002')
url = 'http://thedataweb.rm.census.gov/pub/cps/basic/199801-/pubuse2000_2002.tar.zip'
urlretrieve(url, url2filename(url))
with open('pubuse2000_2002.tar.zip', 'rb') as zipf:
    z = zipfile.ZipFile(zipf, 'r')
    z.extractall()
os.remove('pubuse2000_2002.tar.zip')
tarf = glob.glob('*tar')[0]
with tarfile.TarFile.open(tarf) as tar:
    tar.extractall()
os.remove(tarf)
datafiles = glob.glob('*.dat')
for datafile in datafiles:
    os.chmod(datafile, 777)

subprocess.run(['stata', '-e', 'do', 'init.do'])
    
for datafile in datafiles:
    os.remove(datafile)

os.chdir('..')
subprocess.run(['stata', '-e', 'do', 'add_weights_monthly.do'])

# clean up
for file in glob.glob('*.dat'):
    os.remove(file)
os.makedirs('dta', exist_ok = True)
for file in glob.glob('*.dta'):
    os.rename(file, 'dta/'+file)
os.makedirs('logs', exist_ok = True)
for file in glob.glob('*.log'):
    os.rename(file, 'logs/'+file)
os.makedirs('dofiles', exist_ok = True)
for file in glob.glob('*.do'):
    os.rename(file, 'dofiles/'+file)
for file in glob.glob('*.dct'):
    os.rename(file, 'dofiles/'+file)



    
















