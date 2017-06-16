#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 14 13:19:58 2017

@author: giovannirighi
"""

import sys
import re

file = sys.argv[1]
find = sys.argv[2]
repl = sys.argv[3]

text = []
with open(file, 'r', encoding = "ISO-8859-1") as lines:  # not sure why this 
# encoding works if unicode doesn't
    for line_i in lines:
        line_i = re.sub(find, repl, line_i)
        text.append(line_i)
with open(file, 'w') as lines:
    lines.writelines(text)