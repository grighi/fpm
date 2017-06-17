#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 15 13:23:09 2017

@author: giovannirighi
"""

import bs4
from urllib.request import urlopen
from urllib.request import urlretrieve
#from multiprocessing.dummy import Pool # use threads for I/O bound tasks
import re
import zipfile
import os
from url2filename import url2filename 
import subprocess
import glob


url = 'http://www.nber.org/data/cps.html'
html_page = urlopen(url)
soup = bs4.BeautifulSoup(html_page, "html5lib")
urls = []
for link in soup.findAll('a'):
    match = re.search('cpsmar(20)?[012][0-9].zip', link.get('href'))
    if match:
        urls.append('http://www.nber.org' + link.get('href'))

# drop the 2001 SCHIP file from downloaded files
urls.remove('http://www.nber.org/cps/cpsmar2001.zip')

zipped = []
#def download(url):
#    local_filename, headers = urlretrieve(url, url2filename(url))
#    zipped.append(local_filename)
# with Pool(3) as p:
#    print(p.map(download, urls))  # use 3 threads
for url in urls:
    local_filename, headers = urlretrieve(url, url2filename(url))
    zipped.append(local_filename)


zipped = glob.glob('*.zip')
datafiles = []
for zip_path in zipped:
    zip_ref = zipfile.ZipFile(zip_path, 'r')
    oldname = zip_ref.namelist().pop()
    newname = 'cpsmar' + re.search('[0-9]+', zip_path).group(0) + '.dat'
    out = zip_ref.extractall()
    os.rename(oldname, newname)
    zip_ref.close()
    os.remove(zip_path)
    datafiles.append(newname)


# now get the associated dofiles
dofiles = 'http://www.nber.org/data/cps_progs.html'    
html_page = urlopen(dofiles)
soup = bs4.BeautifulSoup(html_page, "html5lib")
urls = []
for link in soup.findAll('a'):
    match_dct = re.search('data.*?cpsmar(20)?[012][0-9].dct', link.get('href'))
    match_do  = re.search('data.*?cpsmar(20)?[012][0-9].do',  link.get('href'))
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
    with open(dct, 'r', encoding = 'latin-1') as lines:
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
    
for do in dos:
    text = []
    with open(do, 'r', encoding = "latin-1") as lines:  # not sure why this 
        # encoding works if unicode doesn't
        for lineno,line_i in enumerate(lines):
            if re.search("#delimit cr", line_i):
                delimline = lineno
            if re.search("save(old)?.*replace", line_i):
                saveline = lineno
            line_i = re.sub('/homes/data/cps-basic/', '', line_i)
            line_i = re.sub('/homes/data/cps-basic/', '', line_i)
            text.append(line_i)
        if saveline < delimline:
            # ensure semicolon
            text[saveline] = re.sub('(save.*)', '\g<1>;', text[saveline])
        else:
            # remove semicolon if there
            text[saveline] = re.sub('(save.*replace);', '\g<1>\n', text[saveline])
        del saveline, delimline
    with open(do, 'w') as lines:
        lines.writelines(text)

# get names of datafiles
import glob
datafiles = glob.glob('*dat')
dtafiles = glob.glob('*dta')
datafiles = [re.sub('dat', 'dta', x) for x in datafiles]
datafiles = list(set(datafiles) - set(dtafiles))
datafiles = [re.sub('dta', 'dat', x) for x in datafiles]

## some have 4-character strings for years, but all should have 2-char str
#for datafile in datafiles:
#    m = re.search('[0-9]{4}', datafile)
#    if m:
#        os.rename(datafile, 'cpsmar' + m[0][2:4] + '.dat')
#
## get datafiles again 
#import glob
#datafiles = glob.glob('*dat')
#dtafiles = glob.glob('*dta')
#datafiles = [re.sub('dat', 'dta', x) for x in datafiles]
#datafiles = list(set(datafiles) - set(dtafiles))
#datafiles = [re.sub('dta', 'dat', x) for x in datafiles]


for datafile in datafiles:
    
    # get some filenames
    reader = re.sub('dat', 'do', datafile)
    dct    = re.sub('dat', 'dct', datafile)
    dta    = re.sub('dat', 'dta', datafile) 
    
    # substitute items in do-file to match our object
    with open(reader, 'r', encoding = "latin-1") as readerlines:
        text = []
        for line in readerlines:
            # strip quotes if present
            line = re.sub('(local d.._name )"(.*)"', '\g<1>\g<2>', line)  # drops quotes
            # add correct filenames
            line = re.sub('local dat.*dat', 'local dat_name '+ datafile, line)
            line = re.sub('local dta.*dta', 'local dta_name '+ dta, line)
            line = re.sub('local dct.*dct', 'local dct_name '+ dct, line)
            # 2000-2002 do files need another edit:
            line = re.sub('(quietly infile using )(cpsmar[0-9]*)', 
                          '\g<1>\g<2>.dct, using(\g<2>.dat)', line)
            text.append(line)
    with open(reader, 'w') as readerlines:
        readerlines.writelines(text)
    
    subprocess.run(['stata', '-e', 'do', reader])


for file in glob.glob('*.dat'):
    os.remove(file)
os.makedirs('dta', exist_ok = True)
for file in glob.glob('*.dta'):
    m = re.search('[0-9]{4}', file)
    if m:
        os.rename(file, 'cpsmar' + m[0][2:4] + '.dta')
        file = 'cpsmar' + m[0][2:4] + '.dta'
    os.rename(file, 'dta/'+file)
os.makedirs('logs', exist_ok = True)
for file in glob.glob('*.log'):
    os.rename(file, 'logs/'+file)
for file in glob.glob('*.smcl'):
    os.rename(file, 'logs/'+file)

os.makedirs('dofiles', exist_ok = True)
for file in glob.glob('*.do'):
    os.rename(file, 'dofiles/'+file)
for file in glob.glob('*.dct'):
    os.rename(file, 'dofiles/'+file)




















