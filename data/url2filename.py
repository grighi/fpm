#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import posixpath
try:
    from urlparse import urlsplit
    from urllib import unquote
except ImportError: # Python 3
    from urllib.parse import urlsplit, unquote

def url2filename(url):
    """Return basename corresponding to url.
    >>> print(url2filename('http://example.com/path/to/file%C3%80?opt=1'))
    fileÀ
    >>> print(url2filename('http://example.com/slash%2fname')) # '/' in name
    Traceback (most recent call last):
    ...
    ValueError
    """
    urlpath = urlsplit(url).path
    basename = posixpath.basename(unquote(urlpath))
    if (os.path.basename(basename) != basename or
        unquote(posixpath.basename(urlpath)) != basename):
        raise ValueError  # reject '%2f' or 'dir%5Cbasename.ext' on Windows
    return basename

if __name__=="__main__":
    import doctest; doctest.testmod()
    
# --- from a stackoverflow answer on how to do multiple downloads:
#    
#import asyncio
#import logging
#from contextlib import closing
#import aiohttp # $ pip install aiohttp
#
#@asyncio.coroutine
#def download(url, session, semaphore, chunk_size=1<<15):
#    with (yield from semaphore): # limit number of concurrent downloads
#        filename = url2filename(url)
#        logging.info('downloading %s', filename)
#        response = yield from session.get(url)
#        with closing(response), open(filename, 'wb') as file:
#            while True: # save file
#                chunk = yield from response.content.read(chunk_size)
#                if not chunk:
#                    break
#                file.write(chunk)
#        logging.info('done %s', filename)
#    return filename, (response.status, tuple(response.headers.items()))
#
#urls = [...]
#logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s')
#with closing(asyncio.get_event_loop()) as loop, \
#     closing(aiohttp.ClientSession()) as session:
#    semaphore = asyncio.Semaphore(4)
#    download_tasks = (download(url, session, semaphore) for url in urls)
#    result = loop.run_until_complete(asyncio.gather(*download_tasks))