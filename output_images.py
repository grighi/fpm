# Export figures to excel file
#
# giovanni righi
# 2 mar 2018


import os
import glob
import xlsxwriter

filename = "figures.xlsx"

try:
    os.remove(filename)
except OSError:
    pass

workbook = xlsxwriter.Workbook(filename)

for fig in ['output2.png', 'output3.png']:  # glob.glob('*png')
    worksheet = workbook.add_worksheet()
    worksheet.insert_image('A1', fig)

workbook.close()

