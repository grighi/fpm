#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
THIS SCRIPT IS NOT YET FINISHED.

IT COULD BE WORKED ON TO CHECK VERSIONS OF ASEC FILES
to see which need to be downloaded

python3 translation of script of download dta files
for cross-platform compatibility
"""

# note: check for SSL certificates in OSX python3.6

import bs4
from urllib.request import urlopen
from urllib.request import urlretrieve
from urllib.error import HTTPError
import urllib3
#from multiprocessing.dummy import Pool # use threads for I/O bound tasks
import re
import zipfile
import os
import time
from datetime import datetime
from url2filename import url2filename 
import subprocess
import tarfile
import glob
import sys
from pandas import DataFrame

if 'darwin' in sys.platform:
    print('Running \'caffeinate\' on MacOSX to prevent the system from sleeping')
    subprocess.Popen('caffeinate')

print("getting NBER do-files...")
# get dofiles
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
    with open(dct, 'r') as lines:
        tmp = lines.readline()
        txt = lines.read().splitlines(True)
        txt[0] = re.sub('dictionary using .*.raw', 'infile dictionary', tmp)
    with open(dct, 'w', encoding='latin1') as lines:
        lines.writelines(txt)

tmp_readers = {
  range(201501,201801): 'cpsbjan2015.do',  # remem ranges end at month+1 since zero-indexing
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

import pandas
import datetime
import calendar
table = pandas.read_html('http://www.nber.org/data/cps.html')[1]
table[0][1] = table[0][1] + datetime.date.today().strftime('%B %Y')
for i in range(12):
    m = list(calendar.month_name)[i+1]
    table[0] = [re.sub(m + ' ([0-9]{4,})', '\g<1>'+"{:02d}".format(i), x) for x in table[0]]

for nums in range(len(table[0])):
    num = re.findall('[0-9]{6,}', table[0][nums])
    #if re.match('.*Revised', table[0][8]):
    #    return('do something with revised')
    if len(num) == 2:
        table[0][nums] = range(int(num[0]), int(num[1]))

table = table[1:]
tmp_readers = dict(zip(table[0].tolist(), table[3].tolist()))

readers = {}
for k, v in tmp_readers.items():
    for key in k:
        readers[key] = v

# get data
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

#zipped = [url2filename(url) for url in urls]
#datfiles = ['cps' + re.search('[a-z]{3,}[0-9]+', z).group(0) + '.dat'
#    for z in zipped]
#dtafiles = ['cps' + re.search('[a-z]{3,}[0-9]+', z).group(0) + '.dta'
#    for z in zipped]
#files = list(zip(urls, zipped, datfiles, dtafiles))

# check timestamp if in both places
#candidates = set(dtafiles) & set(os.listdir())
#cand = [x for x in files if x[3] in candidates]

print('checking versions of current files...')

import calendar
#dtafiles = list()
#for y in sorted(list(range(1999,datetime.now().year+1))):
    #if y == datetime.now().year:
        #months = calendar.month_abbr[1:datetime.now().month+1]
    #else:
        #months = calendar.month_abbr[1:13]
    #for x in months:
        #dtafiles.append('cps' + x.lower() + str(y)[2:4] + '.dta') 
dtafiles = ['cps' + re.search('[a-z]{3,}[0-9]+', u).group(0) + '.dta'
    for u in urls]
    
datfiles = [re.sub('dta', 'dat', x) for x in dtafiles]

# get server timestamps:
pool = urllib3.HTTPConnectionPool('www.nber.org')
ts = [pool.request('HEAD', url) for url in urls]
# drop missing dtafiles
while [i.status for i in ts].count(404):
    i = [i.status for i in ts].index(404)
    ts.pop(i); dtafiles.pop(i); datfiles.pop(i); urls.pop(i)
ts = [i.headers['Last-Modified'] for i in ts]
#ts = [urlopen(url).info()['Last-Modified'] for url in urls]

# convert to POSIX
tsdt = [datetime.datetime.strptime(i, '%a, %d %b %Y %H:%M:%S %Z') for i in ts]
tsServer = [time.mktime(i.timetuple()) for i in tsdt]  # to POSIX

# get local timestamps
tsLocal = list()
for i in dtafiles:
    try:
        tsLocal.append(os.stat('dta/' + i).st_mtime)
    except FileNotFoundError:
        tsLocal.append(0)

keys = urls
values = list(zip(datfiles, dtafiles, tsServer, tsLocal))
files = dict(zip(keys, values))

tsdict = dict(zip(['url', 'server.ts', 'local.ts'], (urls, tsServer, tsLocal)))
tsDF = DataFrame.from_dict(tsdict, dtype = 'int')
tsDF = tsDF[['url', 'local.ts', 'server.ts']]  # reorder

# get urls of those that need to be replaced
tsDF = tsDF[tsDF['local.ts'] < tsDF['server.ts']]
print('we need to download a few files:')
print(tsDF)
urls = tsDF['url'].tolist()
newtime = tsDF['server.ts'].tolist()

files = {k: files[k] for k in urls}  # subset files

print('note: using Stata installation at /usr/local/stata15/') 

while urls:
    url = urls.pop(0)
    try:
        zip_path, headers = urlretrieve(url, url2filename(url))
        # this shouldn't be necessary anymore:
        #if url2filename(url) not in set(os.listdir()):
        #print('downloaded ' + url)
    except HTTPError: 
        print('could not find ' + url)
        urls.append(url)
        next
    zip_ref = zipfile.ZipFile(zip_path, 'r')
    oldname = zip_ref.namelist().pop()
    newname = 'cps' + re.search('[a-z]{3,}[0-9]+', oldname).group(0) + '.dat'
    out = zip_ref.extractall()
    os.rename(oldname, newname)
    zip_ref.close()
    os.remove(zip_path)
    print('extracted ' + newname)
    datafile = newname
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
    subprocess.run(['/usr/local/stata15/stata', '-e', 'do', reader])
    os.utime(dta, (time.time(), files[url][2]))



#def download(url):
#    local_filename, headers = urlretrieve(url, url2filename(url))
#    zipped.append(local_filename)
# with Pool(3) as p:
#    print(p.map(download, urls))
# result = Pool(4).map(urlretrieve, urls) # use 4 threads to download files concurrently


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

datafiles = glob.glob('*dat')
dtafiles = glob.glob('*dta')
datafiles = [re.sub('dat', 'dta', x) for x in datafiles]
datafiles = list(set(datafiles) - set(dtafiles))
datafiles = [re.sub('dta', 'dat', x) for x in datafiles]


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
url = 'https://thedataweb.rm.census.gov/pub/cps/basic/199801-/pubuse2000_2002.tar.zip'
urlretrieve(url, url2filename(url))
with open('pubuse2000_2002.tar.zip', 'rb') as zipf:
    z = zipfile.ZipFile(zipf, 'r')
    z.extractall()
os.remove('pubuse2000_2002.tar.zip')
tarf = glob.glob('*tar')[0]
with tarfile.TarFile.open(tarf) as tar:
    def is_within_directory(directory, target):
        
        abs_directory = os.path.abspath(directory)
        abs_target = os.path.abspath(target)
    
        prefix = os.path.commonprefix([abs_directory, abs_target])
        
        return prefix == abs_directory
    
    def safe_extract(tar, path=".", members=None, *, numeric_owner=False):
    
        for member in tar.getmembers():
            member_path = os.path.join(path, member.name)
            if not is_within_directory(path, member_path):
                raise Exception("Attempted Path Traversal in Tar File")
    
        tar.extractall(path, members, numeric_owner=numeric_owner) 
        
    
    safe_extract(tar)
os.remove(tarf)
datafiles = glob.glob('*.dat')
for datafile in datafiles:
    os.chmod(datafile, 777)

# TO DO: is the following really necessary if not doing reweights?
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



    
















