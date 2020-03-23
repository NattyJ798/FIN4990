# -*- coding: utf-8 -*-
"""
Created on Wed Mar 11 10:01:16 2020

@author: 12699
"""

import quandl
import datetime as date

# underhood data conversion for now
def get_stock(ticker, key_path = 'C:/Users/12699/Desktop/Quandl_key.txt', path = ""  ):
    file = open(key_path,'r')
    QUANDL_API_KEY = file.readlines()[0]
    quandl.ApiConfig.api_key = QUANDL_API_KEY
    df = quandl.get(ticker)
    # get the time
    Date = date.datetime.now( )
    text_doc = ticker.split("/")[0]+ticker.split("/")[1]+"_"+str(Date.year)+str(Date.month) 
    text_doc += str(Date.day) + str(Date.hour) + str(Date.minute) +".csv"
    df.to_csv(text_doc, index = False, header = True)
    return(text_doc)
print(get_stock('EURONEXT/ABN'))
    